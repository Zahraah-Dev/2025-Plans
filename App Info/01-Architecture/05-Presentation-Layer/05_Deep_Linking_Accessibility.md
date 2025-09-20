# 5. الروابط العميقة وإمكانية الوصول
## 5. Deep Linking & Accessibility

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement comprehensive deep linking support and accessibility features for inclusive user experience in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: دعم الروابط العميقة + إمكانية الوصول + دعم RTL + دعم قارئات الشاشة  
**English**: Deep linking support + Accessibility + RTL support + Screen reader support

## 💡 **Benefits | الفوائد**
- **Seamless UX | تجربة مستخدم سلسة**: Direct access to specific content
- **Inclusive Design | تصميم شامل**: Accessible to all users
- **RTL Support | دعم RTL**: Proper Arabic language support
- **Screen Reader Support | دعم قارئات الشاشة**: Accessible to visually impaired users
- **SEO Benefits | فوائد SEO**: Better search engine visibility
- **Marketing | التسويق**: Direct links for marketing campaigns

---

## 🔗 **Deep Linking | الروابط العميقة**

### **1. Deep Link Configuration**
```dart
// lib/core/navigation/deep_link_handler.dart
class DeepLinkHandler {
  static final Map<String, DeepLinkRoute> _routes = {
    'product': DeepLinkRoute(
      pattern: '/product/:id',
      handler: (params) => '/product/${params['id']}',
    ),
    'order': DeepLinkRoute(
      pattern: '/order/:id',
      handler: (params) => '/order/${params['id']}',
    ),
    'category': DeepLinkRoute(
      pattern: '/category/:id',
      handler: (params) => '/catalog?category=${params['id']}',
    ),
    'search': DeepLinkRoute(
      pattern: '/search',
      handler: (params) => '/catalog?search=${params['q']}',
    ),
  };
  
  static Future<void> handleDeepLink(String link) async {
    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;
    
    if (pathSegments.isEmpty) return;
    
    final routeKey = pathSegments.first;
    final route = _routes[routeKey];
    
    if (route != null) {
      final params = _extractParameters(uri);
      final routePath = route.handler(params);
      await _navigateToRoute(routePath);
    }
  }
  
  static Map<String, String> _extractParameters(Uri uri) {
    final params = <String, String>{};
    
    // Extract path parameters
    final pathSegments = uri.pathSegments;
    if (pathSegments.length > 1) {
      params['id'] = pathSegments[1];
    }
    
    // Extract query parameters
    uri.queryParameters.forEach((key, value) {
      params[key] = value;
    });
    
    return params;
  }
  
  static Future<void> _navigateToRoute(String routePath) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go(routePath);
    }
  }
}

class DeepLinkRoute {
  final String pattern;
  final String Function(Map<String, String>) handler;
  
  const DeepLinkRoute({
    required this.pattern,
    required this.handler,
  });
}
```

### **2. Dynamic Links**
```dart
// lib/core/navigation/dynamic_link_service.dart
class DynamicLinkService {
  static Future<String> createProductLink(String productId) async {
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      DynamicLinkParameters(
        link: Uri.parse('https://zahraah.com/product/$productId'),
        uriPrefix: 'https://zahraah.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.zahraah.app',
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.zahraah.app',
          minimumVersion: '1.0.0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'منتج من زهراء',
          description: 'اكتشف هذا المنتج الرائع',
          imageUrl: Uri.parse('https://zahraah.com/images/product.jpg'),
        ),
      ),
    );
    
    return dynamicLink.toString();
  }
  
  static Future<String> createOrderLink(String orderId) async {
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      DynamicLinkParameters(
        link: Uri.parse('https://zahraah.com/order/$orderId'),
        uriPrefix: 'https://zahraah.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.zahraah.app',
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.zahraah.app',
          minimumVersion: '1.0.0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'طلبك من زهراء',
          description: 'تتبع طلبك',
          imageUrl: Uri.parse('https://zahraah.com/images/order.jpg'),
        ),
      ),
    );
    
    return dynamicLink.toString();
  }
}
```

---

## ♿ **Accessibility | إمكانية الوصول**

### **1. Accessibility Labels**
```dart
// lib/core/accessibility/accessibility_labels.dart
class AccessibilityLabels {
  // Navigation labels
  static const String homeScreen = 'الصفحة الرئيسية';
  static const String catalogScreen = 'صفحة المنتجات';
  static const String cartScreen = 'سلة التسوق';
  static const String profileScreen = 'صفحة الملف الشخصي';
  
  // Product labels
  static const String productCard = 'بطاقة منتج';
  static const String productImage = 'صورة المنتج';
  static const String productName = 'اسم المنتج';
  static const String productPrice = 'سعر المنتج';
  static const String addToCartButton = 'أضف إلى السلة';
  static const String removeFromCartButton = 'احذف من السلة';
  
  // Cart labels
  static const String cartItem = 'عنصر في السلة';
  static const String quantityInput = 'كمية العنصر';
  static const String totalPrice = 'السعر الإجمالي';
  static const String checkoutButton = 'الذهاب للدفع';
  
  // Form labels
  static const String emailInput = 'البريد الإلكتروني';
  static const String passwordInput = 'كلمة المرور';
  static const String searchInput = 'بحث المنتجات';
  static const String filterButton = 'تصفية المنتجات';
  
  // Action labels
  static const String backButton = 'العودة';
  static const String nextButton = 'التالي';
  static const String closeButton = 'إغلاق';
  static const String saveButton = 'حفظ';
  static const String cancelButton = 'إلغاء';
}
```

### **2. Accessible Components**
```dart
// lib/shared/widgets/accessible_button.dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final IconData? icon;
  final ButtonStyle? style;
  
  const AccessibleButton({
    Key? key,
    required this.text,
    this.onPressed,
    required this.semanticLabel,
    this.icon,
    this.style,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: style,
      ),
    );
  }
}

// Usage
AccessibleButton(
  text: 'أضف إلى السلة',
  semanticLabel: AccessibilityLabels.addToCartButton,
  icon: Icons.shopping_cart,
  onPressed: () => _addToCart(),
)
```

### **3. Screen Reader Support**
```dart
// lib/shared/widgets/accessible_image.dart
class AccessibleImage extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;
  final double? width;
  final double? height;
  final BoxFit fit;
  
  const AccessibleImage({
    Key? key,
    required this.imageUrl,
    required this.semanticLabel,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Semantics(
            label: 'صورة غير متاحة',
            child: Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🌐 **RTL Support | دعم RTL**

### **1. RTL Layout Configuration**
```dart
// lib/core/rtl/rtl_config.dart
class RTLConfig {
  static Widget buildRTL({
    required Widget child,
    required String locale,
  }) {
    final isRTL = locale.startsWith('ar');
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
  
  static EdgeInsets getPadding({
    required EdgeInsets padding,
    required String locale,
  }) {
    final isRTL = locale.startsWith('ar');
    
    if (isRTL) {
      return EdgeInsets.only(
        left: padding.right,
        right: padding.left,
        top: padding.top,
        bottom: padding.bottom,
      );
    }
    return padding;
  }
  
  static MainAxisAlignment getMainAxisAlignment({
    required MainAxisAlignment alignment,
    required String locale,
  }) {
    final isRTL = locale.startsWith('ar');
    
    if (isRTL) {
      switch (alignment) {
        case MainAxisAlignment.start:
          return MainAxisAlignment.end;
        case MainAxisAlignment.end:
          return MainAxisAlignment.start;
        default:
          return alignment;
      }
    }
    return alignment;
  }
}
```

### **2. RTL-Aware Components**
```dart
// lib/shared/widgets/rtl_row.dart
class RTLRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String locale;
  
  const RTLRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.locale,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isRTL = locale.startsWith('ar');
    
    return Row(
      mainAxisAlignment: isRTL 
          ? RTLConfig.getMainAxisAlignment(
              alignment: mainAxisAlignment, 
              locale: locale,
            )
          : mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: isRTL ? children.reversed.toList() : children,
    );
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: State Management & UI | السابق: إدارة الحالة والواجهة](05_State_Management_UI.md)
[Next: Design System | التالي: نظام التصميم →](../06_Design_System.md)
[🏠 Home | الرئيسية](../../../index.html)

---
