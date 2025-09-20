# 3. Result/Failure Pattern Implementation | تنفيذ نمط النتيجة/الفشل
## Data Layer Error Handling - Core Patterns | معالجة أخطاء طبقة البيانات - الأنماط الأساسية

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Quality Level**: Enterprise-grade, Production-ready

## 🎯 **Objective | الهدف**
Implement robust Result/Failure pattern for comprehensive error handling in Flutter e-commerce data layer operations.

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

---

## 🔄 **Result/Failure Pattern | نمط النتيجة/الفشل**

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

### **3. Usage Examples**
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

---

## 🗄️ **Repository Pattern Implementation | تنفيذ نمط المستودع**

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

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Result/Failure Pattern Specific Criteria:**
- [ ] Result<T> pattern implemented for all data operations
- [ ] AppFailure sealed class with comprehensive error types
- [ ] Bilingual error messages (Arabic/English)
- [ ] Repository pattern using Result pattern
- [ ] Proper error mapping and user-friendly messages
- [ ] Type-safe error handling throughout

---

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Result/Failure Pattern Specific Pitfalls:**
- **Avoid**: Throwing exceptions instead of returning Result.err
- **Avoid**: Generic error messages without context
- **Avoid**: Missing error type definitions
- **Avoid**: Inconsistent error handling patterns
- **Avoid**: No bilingual error message support
- **Avoid**: Not handling all Result cases in UI

---

## 🔗 **Navigation | التنقل**

[← Previous: Data Layer Overview | السابق: نظرة عامة على طبقة البيانات](../03-Data-Layer/03_Data_Layer_Overview.md)
[Next: Data Sources Implementation | التالي: تنفيذ مصادر البيانات →](03_Data_Sources_Implementation.md)
[🏠 Home | الرئيسية](../../../index.html)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Error Handling  
**Status | الحالة**: ✅ Production Ready
