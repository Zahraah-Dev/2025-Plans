# 6. دعم RTL وإمكانية الوصول
## 6. RTL & Accessibility Support

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement comprehensive RTL (Right-to-Left) support and accessibility features for Arabic e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: دعم RTL كامل + إمكانية الوصول + دعم قارئات الشاشة  
**English**: Full RTL support + Accessibility + Screen reader support

## 💡 **Benefits | الفوائد**
- **Arabic Language Support | دعم اللغة العربية**: Proper RTL layout for Arabic text
- **Accessibility Compliance | الامتثال لإمكانية الوصول**: Support for users with disabilities
- **Screen Reader Support | دعم قارئات الشاشة**: Proper semantic labels and navigation
- **Inclusive Design | التصميم الشامل**: Accessible to all users
- **Legal Compliance | الامتثال القانوني**: Meet accessibility standards
- **Better UX | تجربة مستخدم أفضل**: Improved usability for all users

---

## 📱 **RTL Support | دعم RTL**

### **1. RTL Configuration**
```dart
class RTLSupport {
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

### **2. RTL Layout Widgets**
```dart
class RTLWidgets {
  static Widget row({
    required List<Widget> children,
    required String locale,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    final isRTL = locale.startsWith('ar');
    
    return Row(
      mainAxisAlignment: isRTL 
          ? RTLSupport.getMainAxisAlignment(
              alignment: mainAxisAlignment, 
              locale: locale
            )
          : mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: isRTL ? children.reversed.toList() : children,
    );
  }
  
  static Widget column({
    required List<Widget> children,
    required String locale,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
```

---

## ♿ **Accessibility | إمكانية الوصول**

### **1. Semantic Labels**
```dart
class AccessibilityLabels {
  static const String homeScreen = 'Home Screen';
  static const String productList = 'Product List';
  static const String productDetails = 'Product Details';
  static const String shoppingCart = 'Shopping Cart';
  static const String checkout = 'Checkout';
  static const String profile = 'User Profile';
  static const String search = 'Search Products';
  static const String filter = 'Filter Products';
  static const String sort = 'Sort Products';
  static const String addToCart = 'Add to Cart';
  static const String removeFromCart = 'Remove from Cart';
  static const String quantity = 'Quantity';
  static const String price = 'Price';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String tax = 'Tax';
  static const String shipping = 'Shipping';
  static const String discount = 'Discount';
  static const String coupon = 'Coupon Code';
  static const String applyCoupon = 'Apply Coupon';
  static const String removeCoupon = 'Remove Coupon';
  static const String proceedToCheckout = 'Proceed to Checkout';
  static const String continueShopping = 'Continue Shopping';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String close = 'Close';
  static const String open = 'Open';
  static const String expand = 'Expand';
  static const String collapse = 'Collapse';
  static const String loading = 'Loading';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Information';
}
```

### **2. Accessible Components**
```dart
class AccessibleWidgets {
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    required String semanticLabel,
    IconData? icon,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
      ),
    );
  }
  
  static Widget image({
    required String imagePath,
    required String semanticLabel,
    double? width,
    double? height,
  }) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
      ),
    );
  }
  
  static Widget textField({
    required String label,
    required String semanticLabel,
    TextEditingController? controller,
  }) {
    return Semantics(
      label: semanticLabel,
      textField: true,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
```

### **3. Focus Management**
```dart
class FocusManagement {
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
  
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  
  static Widget focusable({
    required Widget child,
    required FocusNode focusNode,
    VoidCallback? onFocusChange,
  }) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        onFocusChange?.call();
      },
      child: child,
    );
  }
}
```

---

## 🎯 **Testing | الاختبار**

### **1. RTL Testing**
```dart
class RTLTesting {
  static void testRTLSupport() {
    // Test RTL layout
    testWidgets('RTL layout test', (WidgetTester tester) async {
      await tester.pumpWidget(
        RTLSupport.buildRTL(
          locale: 'ar',
          child: const TestWidget(),
        ),
      );
      
      // Verify RTL layout
      expect(find.byType(TestWidget), findsOneWidget);
    });
  }
}
```

### **2. Accessibility Testing**
```dart
class AccessibilityTesting {
  static void testAccessibility() {
    // Test semantic labels
    testWidgets('Accessibility test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const AccessibleWidgets.button(
          text: 'Test Button',
          onPressed: null,
          semanticLabel: 'Test Button',
        ),
      );
      
      // Verify accessibility
      expect(find.bySemanticsLabel('Test Button'), findsOneWidget);
    });
  }
}
```

---

## 📋 **Best Practices | أفضل الممارسات**

### **1. RTL Best Practices**
- [ ] Always use RTL-aware layout widgets
- [ ] Test with both Arabic and English content
- [ ] Use proper text direction for mixed content
- [ ] Test with different screen sizes
- [ ] Verify icon and image positioning

### **2. Accessibility Best Practices**
- [ ] Add semantic labels to all interactive elements
- [ ] Ensure proper color contrast ratios
- [ ] Test with screen readers
- [ ] Provide alternative text for images
- [ ] Use proper heading hierarchy
- [ ] Ensure keyboard navigation works

### **3. Testing Best Practices**
- [ ] Test RTL layout with real Arabic content
- [ ] Test accessibility with actual screen readers
- [ ] Test with different font sizes
- [ ] Test with high contrast mode
- [ ] Test with reduced motion preferences

---

## 🔗 **Navigation | التنقل**

[← Previous: Components | السابق: المكونات](06_Components.md)
[Next: Architecture Overview | التالي: نظرة عامة على المعمارية →](../01_Architecture_Overview.md)
[🏠 Home | الرئيسية](../../../index.html)

---
