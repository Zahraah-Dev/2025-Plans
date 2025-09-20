# 3. Data Sources Implementation | تنفيذ مصادر البيانات
## Remote & Local Data Sources with Error Handling | مصادر البيانات البعيدة والمحلية مع معالجة الأخطاء

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Quality Level**: Enterprise-grade, Production-ready

## 🎯 **Objective | الهدف**
Implement robust remote and local data sources with comprehensive error handling, caching strategies, and offline support for Flutter e-commerce application.

---

## 🌐 **Remote Data Sources | مصادر البيانات البعيدة**

### **1. Remote Data Source Interface**
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
```

### **2. Remote Data Source Implementation**
```dart
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
  
  @override
  Future<Product> getProduct(String id) async {
    final response = await _dio.get('/products/$id');
    
    if (response.statusCode == 200) {
      return Product.fromJson(response.data['data']);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Product not found');
    } else {
      throw ServerException('Failed to load product');
    }
  }
  
  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _dio.get('/products/search', queryParameters: {
      'q': query,
    });
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to search products');
    }
  }
}
```

---

## 🗄️ **Local Data Sources | مصادر البيانات المحلية**

### **1. Local Data Source Interface**
```dart
abstract class CatalogLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<Product> getCachedProduct(String id);
  Future<void> cacheProducts(List<Product> products);
  Future<void> cacheProduct(Product product);
  Future<void> clearCache();
}
```

### **2. Local Data Source Implementation**
```dart
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
  Future<Product> getCachedProduct(String id) async {
    final box = await _hive.openBox(_productsBox);
    final cachedData = box.get('product_$id');
    
    if (cachedData != null) {
      return Product.fromJson(cachedData);
    } else {
      throw CacheException('Product not found in cache');
    }
  }
  
  @override
  Future<void> cacheProducts(List<Product> products) async {
    final box = await _hive.openBox(_productsBox);
    final jsonData = products.map((product) => product.toJson()).toList();
    await box.put(_cacheKey, jsonData);
  }
  
  @override
  Future<void> cacheProduct(Product product) async {
    final box = await _hive.openBox(_productsBox);
    await box.put('product_${product.id}', product.toJson());
  }
  
  @override
  Future<void> clearCache() async {
    final box = await _hive.openBox(_productsBox);
    await box.clear();
  }
}
```

---

## 🔧 **Network & Connectivity | الشبكة والاتصال**

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

### **3. Error Interceptor**
```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Request timeout');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        switch (statusCode) {
          case 401:
            throw UnauthorizedException('Unauthorized');
          case 403:
            throw ForbiddenException('Forbidden');
          case 404:
            throw NotFoundException('Not found');
          case 500:
            throw ServerException('Internal server error');
          default:
            throw ServerException('Server error: $statusCode');
        }
      case DioExceptionType.cancel:
        throw CancelledException('Request cancelled');
      default:
        throw NetworkException('Network error');
    }
  }
}
```

---

## 🏗️ **Immutable Models | النماذج غير القابلة للتغيير**

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

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Data Sources Specific Criteria:**
- [ ] Remote data sources implemented with proper error handling
- [ ] Local data sources with caching strategies
- [ ] Network connectivity checking
- [ ] Dio configuration with interceptors
- [ ] Immutable models with Freezed
- [ ] Proper exception handling and mapping

---

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Data Sources Specific Pitfalls:**
- **Avoid**: Not handling network connectivity
- **Avoid**: Missing error interceptors
- **Avoid**: No caching strategy
- **Avoid**: Mutable models
- **Avoid**: Generic error handling
- **Avoid**: No offline support

---

## 🔗 **Navigation | التنقل**

[← Previous: Result/Failure Patterns | السابق: أنماط النتيجة/الفشل](03_Result_Failure_Patterns.md)
[Next: Testing Data Layer | التالي: اختبار طبقة البيانات →](03_Testing_Data_Layer.md)
[🏠 Home | الرئيسية](../../../index.html)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Data Sources  
**Status | الحالة**: ✅ Production Ready
