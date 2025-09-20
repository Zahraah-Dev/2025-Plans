# 26. قوالب طبقة البيانات
## 26. Data Layer Templates

> **الجزء السادس: المراجع والأدوات | Part VI: References & Tools**

## 🎯 **Objective | الهدف**
Provide comprehensive data layer templates for API clients, local storage, and data models in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: قوالب جاهزة لطبقة البيانات + نماذج API + التخزين المحلي + معالجة الأخطاء  
**English**: Ready-to-use data layer templates + API models + Local storage + Error handling

## 💡 **Benefits | الفوائد**
- **API Integration | تكامل API**: Standardized API client implementation
- **Data Modeling | نمذجة البيانات**: Consistent data model patterns
- **Local Storage | التخزين المحلي**: Efficient local data management
- **Error Handling | معالجة الأخطاء**: Robust error handling patterns
- **Caching | التخزين المؤقت**: Effective caching strategies
- **Offline Support | دعم عدم الاتصال**: Offline-first data management

---

## 🌐 **API Client Templates | قوالب عميل API**

### **1. Dio Client Template**
```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:zahraah_app/core/config/app_config.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication headers
    final token = _getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  String? _getAuthToken() {
    // Get token from secure storage
    return null; // Implement token retrieval
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    handler.next(response);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.enableLogging) {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    handler.next(err);
  }
}
```

### **2. API Service Template**
```dart
// lib/features/catalog/data/datasources/catalog_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:zahraah_app/core/network/dio_client.dart';
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/data/models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getProductsByCategory(String categoryId);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final DioClient _dioClient;

  CatalogRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dioClient.dio.get('/products');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dioClient.dio.get('/products/$id');
      return ProductModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dioClient.dio.get('/products/search', queryParameters: {
        'q': query,
      });
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _dioClient.dio.get('/categories/$categoryId/products');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return ServerException('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return CancelException('Request cancelled');
      default:
        return UnknownException('Unknown error: ${e.message}');
    }
  }
}
```

---

## 💾 **Local Storage Templates | قوالب التخزين المحلي**

### **1. Hive Storage Template**
```dart
// lib/core/storage/hive_storage.dart
import 'package:hive/hive.dart';
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/data/models/product_model.dart';

class HiveStorage {
  static const String _productsBox = 'products';
  static const String _cartBox = 'cart';
  static const String _userBox = 'user';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CartItemModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    
    // Open boxes
    await Hive.openBox<ProductModel>(_productsBox);
    await Hive.openBox<CartItemModel>(_cartBox);
    await Hive.openBox<UserModel>(_userBox);
  }

  static Box<ProductModel> get productsBox => Hive.box<ProductModel>(_productsBox);
  static Box<CartItemModel> get cartBox => Hive.box<CartItemModel>(_cartBox);
  static Box<UserModel> get userBox => Hive.box<UserModel>(_userBox);
}

class ProductLocalDataSource {
  final Box<ProductModel> _box;

  ProductLocalDataSource({required Box<ProductModel> box}) : _box = box;

  Future<List<Product>> getProducts() async {
    return _box.values.map((model) => model.toEntity()).toList();
  }

  Future<Product?> getProductById(String id) async {
    final model = _box.get(id);
    return model?.toEntity();
  }

  Future<void> cacheProducts(List<Product> products) async {
    final models = products.map((product) => ProductModel.fromEntity(product)).toList();
    await _box.putAll(Map.fromEntries(
      models.map((model) => MapEntry(model.id, model)),
    ));
  }

  Future<void> cacheProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    await _box.put(model.id, model);
  }

  Future<void> clearCache() async {
    await _box.clear();
  }
}
```

### **2. Secure Storage Template**
```dart
// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // Token management
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  // User data management
  static Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<void> clearUserData() async {
    await _storage.delete(key: _userIdKey);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

---

## 📊 **Data Model Templates | قوالب نماذج البيانات**

### **1. Entity Template**
```dart
// lib/domain/entities/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    required String imageUrl,
    String? description,
    String? categoryId,
    List<String>? tags,
    @Default(0) int stock,
    @Default(false) bool isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;
}
```

### **2. Model Template**
```dart
// lib/data/models/product_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zahraah_app/domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required double price,
    required String imageUrl,
    String? description,
    String? categoryId,
    List<String>? tags,
    @Default(0) int stock,
    @Default(false) bool isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      imageUrl: entity.imageUrl,
      description: entity.description,
      categoryId: entity.categoryId,
      tags: entity.tags,
      stock: entity.stock,
      isAvailable: entity.isAvailable,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

extension ProductModelX on ProductModel {
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      description: description,
      categoryId: categoryId,
      tags: tags,
      stock: stock,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: UI Component Templates | السابق: قوالب مكونات الواجهة](26_UI_Component_Templates.md)
[Next: Troubleshooting | التالي: حل المشاكل →](../27_Troubleshooting.md)
[🏠 Home | الرئيسية](../../../index.html)

---
