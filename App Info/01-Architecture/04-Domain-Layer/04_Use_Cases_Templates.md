# 4. قوالب حالات الاستخدام
## 4. Use Cases Templates

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Provide comprehensive use case templates for business operations and workflows in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: قوالب جاهزة لحالات الاستخدام + منطق الأعمال + التحقق من الصحة + معالجة الأخطاء  
**English**: Ready-to-use use case templates + Business logic + Validation + Error handling

## 💡 **Benefits | الفوائد**
- **Business Logic Centralization | مركزية منطق الأعمال**: All business operations in use cases
- **Reusability | إعادة الاستخدام**: Use cases can be reused across different UI implementations
- **Testability | قابلية الاختبار**: Easy to test business logic independently
- **Maintainability | سهولة الصيانة**: Clear separation of business concerns
- **Validation | التحقق**: Centralized business validation rules
- **Error Handling | معالجة الأخطاء**: Consistent error handling patterns

---

## 🎯 **Use Cases | حالات الاستخدام**

### **1. Get Product List Use Case**
```dart
class GetProductList {
  final CatalogRepository _repository;
  
  GetProductList(this._repository);
  
  Future<Result<List<Product>>> call({
    String? category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    // Validate input parameters
    if (page < 1) {
      return Result.err(AppFailure.validation('Page must be greater than 0'));
    }
    
    if (limit < 1 || limit > 100) {
      return Result.err(AppFailure.validation('Limit must be between 1 and 100'));
    }
    
    return await _repository.getProducts(
      category: category,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
```

### **2. Get Product Details Use Case**
```dart
class GetProductDetails {
  final CatalogRepository _repository;
  
  GetProductDetails(this._repository);
  
  Future<Result<Product>> call(String productId) async {
    if (productId.isEmpty) {
      return Result.err(AppFailure.validation('Product ID is required'));
    }
    
    return await _repository.getProduct(productId);
  }
}
```

### **3. Search Products Use Case**
```dart
class SearchProducts {
  final CatalogRepository _repository;
  
  SearchProducts(this._repository);
  
  Future<Result<List<Product>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Result.err(AppFailure.validation('Search query is required'));
    }
    
    if (query.trim().length < 2) {
      return Result.err(AppFailure.validation('Search query must be at least 2 characters'));
    }
    
    return await _repository.searchProducts(query.trim());
  }
}
```

---

## 🛒 **Cart Use Cases | حالات استخدام السلة**

### **1. Add to Cart Use Case**
```dart
class AddToCart {
  final CartRepository _repository;
  final ValidationService _validationService;
  
  AddToCart(this._repository, this._validationService);
  
  Future<Result<CartItem>> call({
    required String productId,
    required int quantity,
    Map<String, dynamic>? options,
  }) async {
    // Validate input
    final validationResult = _validationService.validateAddToCart(
      productId: productId,
      quantity: quantity,
      options: options,
    );
    
    if (validationResult.isErr) {
      return Result.err(validationResult.err);
    }
    
    // Check product availability
    final productResult = await _repository.getProduct(productId);
    if (productResult.isErr) {
      return Result.err(productResult.err);
    }
    
    final product = productResult.ok;
    if (!product.isAvailable) {
      return Result.err(AppFailure.business('Product is not available'));
    }
    
    if (product.stock < quantity) {
      return Result.err(AppFailure.business('Insufficient stock'));
    }
    
    // Add to cart
    return await _repository.addToCart(
      productId: productId,
      quantity: quantity,
      options: options ?? {},
    );
  }
}
```

### **2. Remove from Cart Use Case**
```dart
class RemoveFromCart {
  final CartRepository _repository;
  
  RemoveFromCart(this._repository);
  
  Future<Result<void>> call(String cartItemId) async {
    if (cartItemId.isEmpty) {
      return Result.err(AppFailure.validation('Cart item ID is required'));
    }
    
    return await _repository.removeFromCart(cartItemId);
  }
}
```

### **3. Update Cart Quantity Use Case**
```dart
class UpdateCartQuantity {
  final CartRepository _repository;
  final ValidationService _validationService;
  
  UpdateCartQuantity(this._repository, this._validationService);
  
  Future<Result<CartItem>> call({
    required String cartItemId,
    required int quantity,
  }) async {
    if (cartItemId.isEmpty) {
      return Result.err(AppFailure.validation('Cart item ID is required'));
    }
    
    if (quantity < 0) {
      return Result.err(AppFailure.validation('Quantity cannot be negative'));
    }
    
    if (quantity == 0) {
      return await _repository.removeFromCart(cartItemId);
    }
    
    return await _repository.updateCartQuantity(cartItemId, quantity);
  }
}
```

---

## 👤 **User Use Cases | حالات استخدام المستخدم**

### **1. User Authentication Use Case**
```dart
class AuthenticateUser {
  final UserRepository _repository;
  final ValidationService _validationService;
  
  AuthenticateUser(this._repository, this._validationService);
  
  Future<Result<User>> call({
    required String email,
    required String password,
  }) async {
    // Validate input
    final validationResult = _validationService.validateLogin(
      email: email,
      password: password,
    );
    
    if (validationResult.isErr) {
      return Result.err(validationResult.err);
    }
    
    // Authenticate user
    return await _repository.authenticate(email, password);
  }
}
```

### **2. Register User Use Case**
```dart
class RegisterUser {
  final UserRepository _repository;
  final ValidationService _validationService;
  
  RegisterUser(this._repository, this._validationService);
  
  Future<Result<User>> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    // Validate input
    final validationResult = _validationService.validateRegistration(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
    
    if (validationResult.isErr) {
      return Result.err(validationResult.err);
    }
    
    // Check if user already exists
    final existingUserResult = await _repository.getUserByEmail(email);
    if (existingUserResult.isOk) {
      return Result.err(AppFailure.business('User already exists'));
    }
    
    // Register user
    return await _repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }
}
```

---

## 🛍️ **Order Use Cases | حالات استخدام الطلبات**

### **1. Create Order Use Case**
```dart
class CreateOrder {
  final OrderRepository _repository;
  final CartRepository _cartRepository;
  final ValidationService _validationService;
  
  CreateOrder(this._repository, this._cartRepository, this._validationService);
  
  Future<Result<Order>> call({
    required String userId,
    required Address shippingAddress,
    required Address billingAddress,
    String? couponCode,
  }) async {
    // Get cart items
    final cartResult = await _cartRepository.getCartItems(userId);
    if (cartResult.isErr) {
      return Result.err(cartResult.err);
    }
    
    final cartItems = cartResult.ok;
    if (cartItems.isEmpty) {
      return Result.err(AppFailure.business('Cart is empty'));
    }
    
    // Validate addresses
    final addressValidation = _validationService.validateAddresses(
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
    );
    
    if (addressValidation.isErr) {
      return Result.err(addressValidation.err);
    }
    
    // Calculate total
    final totalResult = await _calculateOrderTotal(cartItems, couponCode);
    if (totalResult.isErr) {
      return Result.err(totalResult.err);
    }
    
    // Create order
    return await _repository.createOrder(
      userId: userId,
      cartItems: cartItems,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      total: totalResult.ok,
      couponCode: couponCode,
    );
  }
  
  Future<Result<double>> _calculateOrderTotal(
    List<CartItem> cartItems,
    String? couponCode,
  ) async {
    // Implementation for calculating order total
    // including taxes, shipping, discounts, etc.
    return Result.ok(0.0); // Placeholder
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Domain Layer Overview | السابق: نظرة عامة على طبقة المجال](04_Domain_Layer_Overview.md)
[Next: Entities & Models | التالي: الكيانات والنماذج →](04_Entities_Models.md)
[🏠 Home | الرئيسية](../../../index.html)

---
