# 3. طبقة البيانات ومعالجة الأخطاء
## 3. Data Layer & Error Handling

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement robust data layer with comprehensive error handling, secure data management, and reliable network communication for Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: لا ترمي Exceptions للأعلى؛ أرجِع Result<Success, Failure> مع معالجة شاملة للأخطاء  
**English**: Don't throw Exceptions upward; return Result<Success, Failure> with comprehensive error handling

## 💡 **Benefits | الفوائد**
- **Unified Error Handling | معالجة موحدة للأخطاء**: Consistent error management across UI
- **Type Safety | أمان الأنواع**: Compile-time error checking with Result pattern
- **Better UX | تجربة مستخدم أفضل**: User-friendly error messages and recovery
- **Debugging | سهولة التصحيح**: Clear error categorization and logging
- **Maintainability | سهولة الصيانة**: Centralized error handling logic
- **Testing | الاختبار**: Easy to test error scenarios and edge cases

## 🛠️ **Implementation | التطبيق**
- **Use in**: All data operations, API calls, and external service interactions
- **How to implement**:
  - Use Result<T> pattern for all data operations
  - Implement comprehensive error types (Network, Server, Cache, Auth, Validation)
  - Add proper error mapping and user-friendly messages
  - Implement retry logic with exponential backoff
  - Add proper logging and monitoring
- **Result**: Reliable data layer with excellent error handling and user experience

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../../00-Templates/13_Generic_Priority_Framework.md) for priority levels and criteria.

### **Data Layer & Error Handling Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Implement Result pattern and comprehensive error handling
- **🔴 Critical**: Set up data sources (remote, local) and repository pattern
- **🟠 High**: Add network connectivity checks and basic caching

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Implement retry logic and advanced error recovery
- **🟠 High**: Add comprehensive logging and monitoring
- **🟡 Medium**: Implement advanced caching strategies and offline support

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: AI-powered error prediction and automated recovery
- **🟡 Medium**: Advanced analytics and performance optimization
- **🟢 Low**: Advanced monitoring and AI-powered data management

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../../00-Templates/15_Comprehensive_Metrics_Template.md) for topic-specific metrics.

### **Data Layer & Error Handling Specific Metrics:**
- **Error Handling**: 100% Result pattern usage, zero exceptions to UI
- **Data Reliability**: 99.9% data operation success, <1% data corruption
- **User Experience**: 100% user-friendly error messages, <2s error display
- **Network Resilience**: 95%+ retry success rate, <5s recovery time
- **Caching Performance**: 80%+ cache hit rate, <100ms cache access
- **Monitoring Coverage**: 100% error tracking, <1min error detection

---



## 🔄 **Result/Failure Pattern Implementation | تنفيذ نمط النتيجة/الفشل**

### **1. Result Type | نوع النتيجة**
```dart
@freezed
class Result<T> with _$Result<T> {
  const factory Result.ok(T data) = Ok<T>;
  const factory Result.err(AppFailure failure) = Err<T>;
  
  bool get isSuccess => this is Ok<T>;
  bool get isError => this is Err<T>;
  
  T? get data => isSuccess ? (this as Ok<T>).data : null;
  AppFailure? get failure => isError ? (this as Err<T>).failure : null;
}
```

### **2. AppFailure Sealed Class | فئة AppFailure المختومة**
```dart
@freezed
class AppFailure with _$AppFailure {
  const factory AppFailure.network() = NetworkFailure;
  const factory AppFailure.server(String message) = ServerFailure;
  const factory AppFailure.cache() = CacheFailure;
  const factory AppFailure.validation(String message) = ValidationFailure;
  const factory AppFailure.unauthorized() = UnauthorizedFailure;
  const factory AppFailure.forbidden() = ForbiddenFailure;
  const factory AppFailure.notFound() = NotFoundFailure;
  const factory AppFailure.timeout() = TimeoutFailure;
  const factory AppFailure.unknown(String message) = UnknownFailure;
  
  String get message {
    return when(
      network: () => 'اتصالك بالإنترنت غير متوفر',
      server: (msg) => msg,
      cache: () => 'خطأ في التخزين المؤقت',
      validation: (msg) => msg,
      unauthorized: () => 'يرجى تسجيل الدخول',
      forbidden: () => 'لا تملكين إذن تنفيذ هذا الإجراء',
      notFound: () => 'المحتوى غير موجود',
      timeout: () => 'انتهت مهلة الطلب',
      unknown: (msg) => msg,
    );
  }
}
```

### **3. Usage Examples | أمثلة الاستخدام**
```dart
// Repository method returning Result
Future<Result<List<Product>>> getProducts() async {
  try {
    final products = await _dataSource.getProducts();
    return Result.ok(products);
  } catch (e) {
    return Result.err(AppFailure.server(e.toString()));
  }
}

// UI layer handling Result
final result = await repository.getProducts();
result.when(
  ok: (products) => _displayProducts(products),
  err: (failure) => _showError(failure.message),
);
```

## 🗄️ **Repository Pattern Implementation | تنفيذ نمط المستودع**

### **1. Abstract Repository | المستودع المجرد**
```dart
abstract class CatalogRepository {
  Future<Result<List<Product>>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });
  
  Future<Result<Product>> getProduct(String id);
  
  Future<Result<List<Product>>> searchProducts(String query);
  
  Future<Result<List<String>>> getCategories();
  
  Future<Result<void>> addToWishlist(String productId);
  
  Future<Result<void>> removeFromWishlist(String productId);
}
```

### **2. Repository Implementation | تنفيذ المستودع**
```dart
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remoteDataSource;
  final CatalogLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  CatalogRepositoryImpl({
    required CatalogRemoteDataSource remoteDataSource,
    required CatalogLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;
  
  @override
  Future<Result<List<Product>>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.getProducts(
          category: category,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
        
        // Cache the result
        await _localDataSource.cacheProducts(result);
        
        return Result.ok(result);
      } catch (e) {
        return Result.err(AppFailure.server(e.toString()));
      }
    } else {
      try {
        final cachedProducts = await _localDataSource.getCachedProducts();
        return Result.ok(cachedProducts);
      } catch (e) {
        return Result.err(AppFailure.cache());
      }
    }
  }
}
```

---

## 🏗️ **Data Sources Implementation | تنفيذ مصادر البيانات**

### **1. Remote Data Source | مصدر البيانات البعيد**
```dart
abstract class CatalogRemoteDataSource {
  Future<List<Product>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });
  
  Future<Product> getProduct(String id);
  
  Future<List<Product>> searchProducts(String query);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final Dio _dio;
  
  CatalogRemoteDataSourceImpl({required Dio dio}) : _dio = dio;
  
  @override
  Future<List<Product>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _dio.get('/products', queryParameters: {
      if (category != null) 'category': category,
      'page': page,
      'limit': limit,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to load products');
    }
  }
}
```

### **2. Local Data Source | مصدر البيانات المحلي**
```dart
abstract class CatalogLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<Product> getCachedProduct(String id);
  Future<void> cacheProducts(List<Product> products);
  Future<void> cacheProduct(Product product);
  Future<void> clearCache();
}

class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  final HiveInterface _hive;
  static const String _productsBox = 'products';
  static const String _cacheKey = 'cached_products';
  
  CatalogLocalDataSourceImpl({required HiveInterface hive}) : _hive = hive;
  
  @override
  Future<List<Product>> getCachedProducts() async {
    final box = await _hive.openBox(_productsBox);
    final cachedData = box.get(_cacheKey);
    
    if (cachedData != null) {
      final List<dynamic> data = cachedData;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw CacheException('No cached products found');
    }
  }
  
  @override
  Future<void> cacheProducts(List<Product> products) async {
    final box = await _hive.openBox(_productsBox);
    final jsonData = products.map((product) => product.toJson()).toList();
    await box.put(_cacheKey, jsonData);
  }
}
```

### **3. Network & Connectivity | الشبكة والاتصال**
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  NetworkInfoImpl({required Connectivity connectivity}) : _connectivity = connectivity;
  
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
```

## 📊 **Best Practices | أفضل الممارسات**

### **1. Error Handling | معالجة الأخطاء**
- [ ] استخدم Result pattern للعمليات
- [ ] عرّف أنواع أخطاء محددة
- [ ] سجل الأخطاء للتحليل
- [ ] اعرض رسائل خطأ واضحة

### **2. Caching Strategy | استراتيجية التخزين المؤقت**
- [ ] استخدم cache-aside pattern
- [ ] حدد TTL مناسب للبيانات
- [ ] نظف الـ cache عند الحاجة
- [ ] استخدم cache invalidation

### **3. Network Resilience | مرونة الشبكة**
- [ ] تعامل مع انقطاع الشبكة
- [ ] استخدم retry mechanism
- [ ] اعرض حالة الاتصال
- [ ] استخدم offline-first approach

---

## 📚 **References | المراجع**

- [Flutter Data & Backend](https://docs.flutter.dev/development/data-and-backend)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Hive Local Storage](https://pub.dev/packages/hive)
- [Freezed Code Generation](https://pub.dev/packages/freezed)

---

## 🔗 **Navigation | التنقل**

[← Previous: State Management & DI | السابق: إدارة الحالة وحقن التبعية](02_State_Management_DI.md)
[Next: Domain Layer | التالي: طبقة المجال →](04_Domain_Layer.md)
[🏠 Home | الرئيسية](../../index.html)

### **Quick Navigation | التنقل السريع**
- [Detailed Implementation Guides | أدلة التنفيذ التفصيلية](#-detailed-implementation-guides--أدلة-التنفيذ-التفصيلية)
- [Best Practices | أفضل الممارسات](#-best-practices--أفضل-الممارسات)
- [References | المراجع](#-references--المراجع)

### **Related Files | الملفات ذات الصلة**
- [State Management & DI | إدارة الحالة وحقن التبعية](02_State_Management_DI.md)
- [Domain Layer | طبقة المجال](04_Domain_Layer.md)
- [Architecture Overview | نظرة عامة على المعمارية](01_Architecture_Overview.md)

### **Shared Architecture Resources | موارد المعمارية المشتركة**
- [Quality Standards | معايير الجودة](Quality_Standards.md)
- [Testing Strategy | استراتيجية الاختبار](Testing_Strategy.md)
- [Troubleshooting Guide | دليل استكشاف الأخطاء](Troubleshooting_Guide.md)
- [Best Practices | أفضل الممارسات](Best_Practices.md)
- [Success Criteria | معايير النجاح](Success_Criteria.md)

---
