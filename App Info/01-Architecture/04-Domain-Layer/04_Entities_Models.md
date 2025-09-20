# 4. الكيانات والنماذج
## 4. Entities & Models

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Define comprehensive domain entities and models using freezed and json_serializable for type-safe, immutable data structures.

## 📋 **Rule | القاعدة**
**Arabic**: Entities مع freezed + json_serializable + immutability + type safety  
**English**: Entities with freezed + json_serializable + immutability + type safety

## 💡 **Benefits | الفوائد**
- **Type Safety | أمان الأنواع**: Compile-time type checking
- **Immutability | عدم القابلية للتغيير**: Thread-safe, predictable data
- **Serialization | التسلسل**: Easy JSON serialization/deserialization
- **Code Generation | توليد الكود**: Automatic boilerplate code generation
- **Validation | التحقق**: Built-in validation capabilities
- **Performance | الأداء**: Efficient data handling

---

## 🏗️ **Entity Templates | قوالب الكيانات**

### **1. Product Entity**
```dart
// lib/domain/entities/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String categoryId,
    required String categoryName,
    @Default(0) int stock,
    @Default(true) bool isAvailable,
    @Default([]) List<String> tags,
    @Default([]) List<String> imageUrls,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(0.0) double discountPercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

// Extension methods for business logic
extension ProductX on Product {
  bool get isInStock => stock > 0 && isAvailable;
  
  bool get isOnSale => discountPercentage > 0;
  
  double get discountedPrice => price * (1 - discountPercentage / 100);
  
  bool get hasImages => imageUrls.isNotEmpty;
  
  String get displayPrice => isOnSale 
      ? '\$${discountedPrice.toStringAsFixed(2)}'
      : '\$${price.toStringAsFixed(2)}';
}
```

### **2. Cart Item Entity**
```dart
// lib/domain/entities/cart_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String productId,
    required String productName,
    required String productImageUrl,
    required double unitPrice,
    required int quantity,
    @Default({}) Map<String, dynamic> options,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}

extension CartItemX on CartItem {
  double get totalPrice => unitPrice * quantity;
  
  String get displayTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';
  
  String get displayUnitPrice => '\$${unitPrice.toStringAsFixed(2)}';
  
  bool get hasOptions => options.isNotEmpty;
  
  String get optionsDisplay {
    if (options.isEmpty) return '';
    return options.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }
}
```

### **3. User Entity**
```dart
// lib/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? profileImageUrl,
    @Default([]) List<Address> addresses,
    @Default([]) List<String> preferences,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    required String street,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    String? apartment,
    String? landmark,
    @Default(false) bool isDefault,
    @Default('home') String type,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

extension UserX on User {
  String get fullName => '$firstName $lastName';
  
  String get displayName => fullName;
  
  bool get hasAddresses => addresses.isNotEmpty;
  
  Address? get defaultAddress => addresses.firstWhere(
    (address) => address.isDefault,
    orElse: () => addresses.isNotEmpty ? addresses.first : null,
  );
  
  bool get isVerified => isEmailVerified && isPhoneVerified;
}
```

---

## 🛍️ **Order Entities | كيانات الطلبات**

### **1. Order Entity**
```dart
// lib/domain/entities/order.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required List<OrderItem> items,
    required Address shippingAddress,
    required Address billingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double discount,
    required double total,
    required OrderStatus status,
    String? couponCode,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String productId,
    required String productName,
    required String productImageUrl,
    required double unitPrice,
    required int quantity,
    @Default({}) Map<String, dynamic> options,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

extension OrderX on Order {
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  String get statusDisplay {
    switch (status) {
      case OrderStatus.pending:
        return 'معلق';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.returned:
        return 'مرتجع';
    }
  }
  
  bool get canBeCancelled => status == OrderStatus.pending || status == OrderStatus.confirmed;
  
  bool get isCompleted => status == OrderStatus.delivered;
  
  String get displayTotal => '\$${total.toStringAsFixed(2)}';
}
```

---

## 🏷️ **Category Entity | كيان الفئة**

### **1. Category Entity**
```dart
// lib/domain/entities/category.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    String? parentId,
    @Default([]) List<String> subcategoryIds,
    @Default(0) int productCount,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

extension CategoryX on Category {
  bool get isParent => subcategoryIds.isNotEmpty;
  
  bool get isSubcategory => parentId != null;
  
  String get displayName => name;
  
  bool get hasProducts => productCount > 0;
}
```

---

## 🔧 **Code Generation Setup | إعداد توليد الكود**

### **1. Build Runner Configuration**
```yaml
# pubspec.yaml
dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1

dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
```

### **2. Build Scripts**
```bash
# Generate code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean generated files
flutter packages pub run build_runner clean
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Use Cases Templates | السابق: قوالب حالات الاستخدام](04_Use_Cases_Templates.md)
[Next: Repository Interfaces | التالي: واجهات المستودعات →](04_Repository_Interfaces.md)
[🏠 Home | الرئيسية](../../../index.html)

---
