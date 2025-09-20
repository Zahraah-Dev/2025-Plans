# 4. واجهات المستودعات
## 4. Repository Interfaces

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Define comprehensive repository interfaces for data access abstraction and dependency inversion in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: واجهات المستودعات في Domain + تجريد الوصول للبيانات + عكس التبعية  
**English**: Repository interfaces in Domain + Data access abstraction + Dependency inversion

## 💡 **Benefits | الفوائد**
- **Dependency Inversion | عكس التبعية**: Domain layer doesn't depend on data layer
- **Testability | قابلية الاختبار**: Easy to mock repository implementations
- **Flexibility | المرونة**: Easy to switch data sources
- **Clean Architecture | معمارية نظيفة**: Clear separation of concerns
- **Maintainability | سهولة الصيانة**: Easy to modify data access logic
- **Reusability | إعادة الاستخدام**: Repository interfaces can be reused

---

## 🏪 **Repository Interfaces | واجهات المستودعات**

### **1. Catalog Repository Interface**
```dart
// lib/domain/repositories/catalog_repository.dart
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/domain/entities/category.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class CatalogRepository {
  // Product operations
  Future<Either<Failure, List<Product>>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });
  
  Future<Either<Failure, Product>> getProduct(String productId);
  
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
  
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  
  Future<Either<Failure, List<Product>>> getRecommendedProducts(String userId);
  
  // Category operations
  Future<Either<Failure, List<Category>>> getCategories();
  
  Future<Either<Failure, Category>> getCategory(String categoryId);
  
  Future<Either<Failure, List<Category>>> getSubcategories(String parentCategoryId);
  
  // Filter operations
  Future<Either<Failure, List<String>>> getAvailableFilters(String categoryId);
  
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    String? category,
    Map<String, List<String>>? filters,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  });
}
```

### **2. Cart Repository Interface**
```dart
// lib/domain/repositories/cart_repository.dart
import 'package:zahraah_app/domain/entities/cart_item.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class CartRepository {
  // Cart operations
  Future<Either<Failure, List<CartItem>>> getCartItems(String userId);
  
  Future<Either<Failure, CartItem>> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    Map<String, dynamic>? options,
  });
  
  Future<Either<Failure, CartItem>> updateCartItem({
    required String userId,
    required String cartItemId,
    required int quantity,
  });
  
  Future<Either<Failure, void>> removeFromCart({
    required String userId,
    required String cartItemId,
  });
  
  Future<Either<Failure, void>> clearCart(String userId);
  
  Future<Either<Failure, int>> getCartItemCount(String userId);
  
  Future<Either<Failure, double>> getCartTotal(String userId);
  
  // Cart validation
  Future<Either<Failure, bool>> validateCart(String userId);
  
  Future<Either<Failure, List<CartItem>>> getValidCartItems(String userId);
}
```

### **3. User Repository Interface**
```dart
// lib/domain/repositories/user_repository.dart
import 'package:zahraah_app/domain/entities/user.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  // Authentication operations
  Future<Either<Failure, User>> authenticate(String email, String password);
  
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, void>> refreshToken();
  
  // User profile operations
  Future<Either<Failure, User>> getCurrentUser();
  
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  });
  
  Future<Either<Failure, User>> getUserById(String userId);
  
  Future<Either<Failure, User>> getUserByEmail(String email);
  
  // Address operations
  Future<Either<Failure, List<Address>>> getUserAddresses(String userId);
  
  Future<Either<Failure, Address>> addAddress({
    required String userId,
    required Address address,
  });
  
  Future<Either<Failure, Address>> updateAddress({
    required String userId,
    required String addressId,
    required Address address,
  });
  
  Future<Either<Failure, void>> deleteAddress({
    required String userId,
    required String addressId,
  });
  
  Future<Either<Failure, Address>> setDefaultAddress({
    required String userId,
    required String addressId,
  });
  
  // Verification operations
  Future<Either<Failure, void>> sendEmailVerification(String userId);
  
  Future<Either<Failure, void>> verifyEmail(String userId, String token);
  
  Future<Either<Failure, void>> sendPhoneVerification(String userId);
  
  Future<Either<Failure, void>> verifyPhone(String userId, String code);
}
```

### **4. Order Repository Interface**
```dart
// lib/domain/repositories/order_repository.dart
import 'package:zahraah_app/domain/entities/order.dart';
import 'package:zahraah_app/domain/entities/cart_item.dart';
import 'package:zahraah_app/domain/entities/address.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class OrderRepository {
  // Order operations
  Future<Either<Failure, Order>> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required Address shippingAddress,
    required Address billingAddress,
    required double total,
    String? couponCode,
  });
  
  Future<Either<Failure, Order>> getOrder(String orderId);
  
  Future<Either<Failure, List<Order>>> getUserOrders(String userId);
  
  Future<Either<Failure, List<Order>>> getOrdersByStatus(OrderStatus status);
  
  Future<Either<Failure, Order>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? trackingNumber,
  });
  
  Future<Either<Failure, Order>> cancelOrder(String orderId);
  
  Future<Either<Failure, Order>> returnOrder(String orderId);
  
  // Order tracking
  Future<Either<Failure, String>> getOrderTracking(String orderId);
  
  Future<Either<Failure, List<OrderStatusUpdate>>> getOrderStatusHistory(String orderId);
  
  // Order validation
  Future<Either<Failure, bool>> validateOrder(String orderId);
  
  Future<Either<Failure, double>> calculateOrderTotal({
    required List<CartItem> cartItems,
    required Address shippingAddress,
    String? couponCode,
  });
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String? note;
  
  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.note,
  });
}
```

---

## 🔧 **Repository Implementation Guidelines | إرشادات تنفيذ المستودعات**

### **1. Error Handling**
```dart
// lib/data/repositories/catalog_repository_impl.dart
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
  Future<Either<Failure, List<Product>>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final products = await _remoteDataSource.getProducts(
          category: category,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
        
        // Cache the data
        await _localDataSource.cacheProducts(products);
        
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final products = await _localDataSource.getProducts(
          category: category,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
        return Right(products);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
```

### **2. Caching Strategy**
```dart
// lib/data/repositories/catalog_repository_impl.dart
class CatalogRepositoryImpl implements CatalogRepository {
  // ... existing code ...
  
  @override
  Future<Either<Failure, Product>> getProduct(String productId) async {
    try {
      // Try local cache first
      final localProduct = await _localDataSource.getProduct(productId);
      if (localProduct != null) {
        return Right(localProduct);
      }
      
      // If not in cache, fetch from remote
      if (await _networkInfo.isConnected) {
        final remoteProduct = await _remoteDataSource.getProduct(productId);
        
        // Cache the product
        await _localDataSource.cacheProduct(remoteProduct);
        
        return Right(remoteProduct);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Entities & Models | السابق: الكيانات والنماذج](04_Entities_Models.md)
[Next: Presentation Layer | التالي: طبقة العرض →](../05_Presentation_Layer.md)
[🏠 Home | الرئيسية](../../../index.html)

---
