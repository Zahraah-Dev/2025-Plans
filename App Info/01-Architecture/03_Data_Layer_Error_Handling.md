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

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Data Layer Specific Criteria:**
- [ ] All data operations use Result pattern
- [ ] No exceptions thrown to UI layer
- [ ] User-friendly error messages displayed
- [ ] Proper error logging and monitoring
- [ ] Retry logic implemented for network failures
- [ ] Error recovery mechanisms in place

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Data Layer Specific Pitfalls:**
- **Avoid**: Throwing exceptions to UI layer
- **Avoid**: Generic error messages without context
- **Avoid**: No retry logic for network failures
- **Avoid**: Missing error logging and monitoring
- **Avoid**: Inconsistent error handling patterns
- **Avoid**: No error recovery mechanisms

---



## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **Data Layer & Error Handling Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Data Inconsistency** | High | Medium | Transaction management, data validation, conflict resolution |
| **Network Failures** | High | High | Retry mechanisms, offline support, graceful degradation |
| **Security Vulnerabilities** | High | Medium | Input validation, secure storage, encryption |
| **Performance Issues** | Medium | High | Caching strategies, data pagination, query optimization |
| **Error Propagation** | High | Medium | Result pattern, proper error handling, user-friendly messages |
| **Data Corruption** | High | Low | Data validation, backup strategies, integrity checks |

## 📊 **Implementation Priority | أولوية التنفيذ**

> **Reference**: See [Implementation Priority Template](../00-Templates/02_Implementation_Priority_Template.md) for standard phases.

### **Data Layer & Error Handling Specific Priorities:**
- **Phase 1: Foundation (Must Have)**
  - [ ] Result pattern implementation
  - [ ] Repository pattern with error handling
  - [ ] Network client configuration (Dio)
  - [ ] Local storage setup (Hive)
- **Phase 2: Enhancement (Should Have)**
- [ ] Comprehensive error types and mapping
- [ ] Caching strategy implementation
- [ ] Offline support and sync
- [ ] Data validation and sanitization

### **Phase 3: Optimization (Could Have)**
- [ ] Advanced caching strategies
- [ ] Performance monitoring and optimization
- [ ] Data migration and versioning
- [ ] Advanced error recovery mechanisms

## 📋 **Architecture Decision Record (ADR)**

### **ADR-001: Clean Architecture Pattern**
- **Status**: Accepted
- **Date**: 2025-01-27
- **Context**: Need for maintainable, testable architecture
- **Decision**: Implement Clean Architecture with 4 layers
- **Consequences**: 
  - ✅ Better testability
  - ✅ Clear separation of concerns
  - ⚠️ More initial setup complexity
  - ⚠️ Learning curve for team

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Data Layer & Error Handling Specific Quality Gates:**
- [ ] All data operations use Result pattern
- [ ] No exceptions thrown to UI layer
- [ ] User-friendly error messages displayed
- [ ] Proper error logging and monitoring
- [ ] Retry logic implemented for network failures
- [ ] Data validation and sanitization working
- [ ] Offline support and sync functioning

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Success Metrics Template](../00-Templates/04_Success_Metrics_Template.md) for standard metrics.

### **Data Layer & Error Handling Specific Metrics:**
- **Error Handling**: 100% of operations use Result pattern
- **Data Consistency**: Zero data corruption incidents
- **Network Resilience**: 95%+ success rate with retry logic
- **User Experience**: Clear, actionable error messages
- **Performance**: <500ms average data operation time
- **Security**: Zero data breaches or security incidents


## 🏗️ **نماذج غير قابلة للتغيير | Immutable Models**

### **1. Product Model**
```dart
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String title,
    required double price,
    String? imageUrl,
    String? description,
    @Default([]) List<String> categories,
    @Default(0) int stock,
    @Default(false) bool isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

### **2. Cart Item Model**
```dart
@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    required String name,
    required double price,
    required int quantity,
    String? variantId,
    String? imageUrl,
    @Default({}) Map<String, String> attributes,
  }) = _CartItem;
  
  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      productId: product.id,
      name: product.title,
      price: product.price,
      quantity: quantity,
      imageUrl: product.imageUrl,
    );
  }
}
```

---

## 🔄 **Result/Failure Pattern**

### **1. Result Type**
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

### **2. AppFailure Sealed Class**
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

---

## 🗄️ **Repository Pattern**

### **1. Abstract Repository**
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

### **2. Repository Implementation**
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
  
  @override
  Future<Result<Product>> getProduct(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final product = await _remoteDataSource.getProduct(id);
        await _localDataSource.cacheProduct(product);
        return Result.ok(product);
      } catch (e) {
        return Result.err(AppFailure.server(e.toString()));
      }
    } else {
      try {
        final cachedProduct = await _localDataSource.getCachedProduct(id);
        return Result.ok(cachedProduct);
      } catch (e) {
        return Result.err(AppFailure.cache());
      }
    }
  }
}
```

---

## 🌐 **Data Sources**

### **1. Remote Data Source**
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

### **2. Local Data Source**
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

---

## 🔧 **Network & Connectivity**

### **1. Network Info**
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

### **2. Dio Configuration**
```dart
class ApiClient {
  static late Dio _dio;
  
  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(),
      ErrorInterceptor(),
    ]);
  }
  
  static Dio get instance => _dio;
}
```

---

## 🧪 **Testing Data Layer**

### **1. Repository Testing**
```dart
void main() {
  group('CatalogRepository', () {
    late CatalogRepositoryImpl repository;
    late MockCatalogRemoteDataSource mockRemoteDataSource;
    late MockCatalogLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;
    
    setUp(() {
      mockRemoteDataSource = MockCatalogRemoteDataSource();
      mockLocalDataSource = MockCatalogLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      
      repository = CatalogRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    });
    
    group('getProducts', () {
      test('should return products from remote when connected', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProducts(any, any, any, any, any))
            .thenAnswer((_) async => [testProduct]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct]);
        verify(mockRemoteDataSource.getProducts(any, any, any, any, any));
        verify(mockLocalDataSource.cacheProducts([testProduct]));
      });
      
      test('should return cached products when offline', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getCachedProducts())
            .thenAnswer((_) async => [testProduct]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct]);
        verify(mockLocalDataSource.getCachedProducts());
        verifyNever(mockRemoteDataSource.getProducts(any, any, any, any, any));
      });
    });
  });
}
```

---

## 🔧 **Troubleshooting | استكشاف الأخطاء وإصلاحها**

### **Common Data Layer Issues:**

#### **1. Data Inconsistency**
**Problem**: Data doesn't match between local and remote sources
**Solution**:
- Implement proper data validation
- Use transaction management
- Implement conflict resolution strategies

#### **2. Network Failures**
**Problem**: API calls fail frequently
**Solution**:
- Implement retry mechanisms with exponential backoff
- Add offline support and sync
- Provide graceful degradation

#### **3. Error Propagation**
**Problem**: Exceptions thrown to UI layer
**Solution**:
- Use Result pattern for all operations
- Implement proper error mapping
- Add user-friendly error messages

#### **4. Cache Issues**
**Problem**: Stale or corrupted cached data
**Solution**:
- Implement proper cache invalidation
- Add data validation before caching
- Use appropriate TTL values

## 📊 **Best Practices**

### **1. Error Handling**
- [ ] استخدم Result pattern للعمليات
- [ ] عرّف أنواع أخطاء محددة
- [ ] سجل الأخطاء للتحليل
- [ ] اعرض رسائل خطأ واضحة

### **2. Caching Strategy**
- [ ] استخدم cache-aside pattern
- [ ] حدد TTL مناسب للبيانات
- [ ] نظف الـ cache عند الحاجة
- [ ] استخدم cache invalidation

### **3. Network Resilience**
- [ ] تعامل مع انقطاع الشبكة
- [ ] استخدم retry mechanism
- [ ] اعرض حالة الاتصال
- [ ] استخدم offline-first approach

---

## 🔗 **الروابط ذات الصلة | Related Links**

- [إدارة الحالة وحقن الاعتماديات](02_State_Management_DI.md)
- [طبقة المجال](04_Domain_Layer.md)
- [طبقة العرض](05_Presentation_Layer.md)
- [استراتيجية الاختبار](08_Testing_Strategy.md)

---

## 📚 **المراجع | References**

- [Flutter Data & Backend](https://docs.flutter.dev/development/data-and-backend)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Hive Local Storage](https://pub.dev/packages/hive)

---

**🔴 ENHANCEMENT**: محتوى مأخوذ من الوثائق الأصلية  
**🔵 SUGGESTION**: اقتراحات مبنية على الخبرة التقنية

---

## 🔗 **Navigation | التنقل**

[← Previous: State Management & DI | السابق: إدارة الحالة وحقن التبعية](02_State_Management_DI.md)
[Next: Domain Layer | التالي: طبقة المجال →](04_Domain_Layer.md)
[🏠 Home | الرئيسية](../../index.html)

---
