# 5. طبقة العرض
## 5. Presentation Layer

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement clean presentation layer with proper navigation, state management, and UI components following clean architecture principles.

## 📋 **Rule | القاعدة**
**Arabic**: استخدم go_router مع Guards للطرق المحمية، وادعم Deep Links & Dynamic Links  
**English**: Use go_router with Guards for protected routes, and support Deep Links & Dynamic Links

## 💡 **Benefits | الفوائد**
- **Clean Navigation | تنقل نظيف**: Centralized routing with type safety
- **Deep Linking | الروابط العميقة**: Seamless user experience with external links
- **Route Protection | حماية المسارات**: Secure access to protected screens
- **State Management | إدارة الحالة**: Proper separation of UI and business logic
- **Testing | الاختبار**: Easy to test UI components and navigation
- **Maintainability | سهولة الصيانة**: Clear separation of concerns

## 🛠️ **Implementation | التطبيق**
- **Use in**: All UI screens, navigation flows, and user interactions
- **How to implement**:
  - Set up GoRouter with centralized route configuration
  - Implement route guards for authentication and authorization
  - Add deep linking support for product and order pages
  - Use StateNotifier for UI state management
  - Implement proper error handling and loading states
- **Result**: Clean, maintainable presentation layer with excellent UX

## ✅ **Quality Standards & Success Criteria | معايير الجودة ومعايير النجاح**

> **Reference**: See [Quality Standards | معايير الجودة](Quality_Standards.md) for comprehensive quality requirements.

> **Reference**: See [Success Criteria | معايير النجاح](Success_Criteria.md) for detailed success metrics and validation criteria.

### **Presentation Layer Specific Requirements:**
- **Routing**: All routes properly configured with GoRouter
- **Deep Linking**: Deep linking works for products and orders
- **Security**: Route guards implemented for protected screens
- **State Management**: UI state properly managed with StateNotifier
- **Error Handling**: Error states and loading states handled
- **Documentation**: Navigation flow documented and tested

## ⚠️ **Common Pitfalls & Best Practices | الأخطاء الشائعة وأفضل الممارسات**

> **Reference**: See [Best Practices | أفضل الممارسات](Best_Practices.md) for comprehensive best practices and common pitfalls.

### **Presentation Layer Specific Pitfalls:**
- **Avoid**: Business logic in UI components
- **Avoid**: Direct API calls from widgets
- **Avoid**: Missing error handling in UI
- **Avoid**: Inconsistent navigation patterns
- **Avoid**: No deep linking support

---

## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **Presentation Layer Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Navigation Complexity** | Medium | Medium | Clear route structure, documentation |
| **State Management Issues** | High | Medium | Proper state management patterns, testing |
| **Performance Problems** | High | Medium | Performance monitoring, optimization |
| **Accessibility Issues** | Medium | High | Accessibility testing, guidelines |

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../../00-Templates/13_Generic_Priority_Framework.md) for priority levels and criteria.

### **Presentation Layer Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Basic navigation setup and core UI components
- **🔴 Critical**: State management implementation and error handling
- **🟠 High**: Deep linking support and accessibility features

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Advanced UI components and performance optimization
- **🟠 High**: Accessibility features and responsive design
- **🟡 Medium**: Advanced navigation features and complex UI patterns

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: Advanced accessibility and performance monitoring
- **🟡 Medium**: Complex UI patterns and advanced navigation
- **🟢 Low**: AI-assisted UI generation and advanced analytics

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Presentation Layer Specific Quality Gates:**
- [ ] All routes properly configured with GoRouter
- [ ] Deep linking works for products and orders
- [ ] Route guards implemented for protected screens
- [ ] UI state properly managed with StateNotifier
- [ ] Error states and loading states handled
- [ ] RTL support working correctly
- [ ] Accessibility compliance met

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../../00-Templates/15_Comprehensive_Metrics_Template.md) for topic-specific metrics.

### **Presentation Layer Specific Metrics:**
- **Navigation Success**: 100% of routes working correctly
- **Deep Link Success**: 95%+ deep link success rate
- **UI Performance**: >55 FPS in all screens
- **RTL Support**: 100% of screens RTL-compliant
- **Accessibility**: 100% accessibility compliance
- **User Experience**: <2s screen transition time

---

## 🏗️ **Presentation Layer Architecture | معمارية طبقة العرض**

### **1. Layer Structure | هيكل الطبقة**
```
lib/features/
├── catalog/
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── catalog_page.dart
│   │   │   └── product_detail_page.dart
│   │   ├── widgets/
│   │   │   ├── product_card.dart
│   │   │   └── product_list.dart
│   │   └── controllers/
│   │       └── catalog_controller.dart
│   └── domain/
│       └── entities/
├── cart/
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── cart_page.dart
│   │   ├── widgets/
│   │   │   └── cart_item_widget.dart
│   │   └── controllers/
│   │       └── cart_controller.dart
│   └── domain/
│       └── entities/
└── shared/
    ├── widgets/
    │   ├── loading_widget.dart
    │   └── error_widget.dart
    └── controllers/
        └── app_controller.dart
```

### **2. Presentation Layer Principles | مبادئ طبقة العرض**
- **Single Responsibility**: Each widget has one clear purpose
- **Separation of Concerns**: UI logic separate from business logic
- **State Management**: Centralized state management with Riverpod
- **Navigation**: Centralized routing with GoRouter
- **Error Handling**: Consistent error handling across all screens
- **Accessibility**: Built-in accessibility support

## 🎨 **UI Component Architecture | معمارية مكونات الواجهة**

### **1. Component Hierarchy | تسلسل المكونات**
```
App
├── Router (GoRouter)
├── Theme (MaterialApp)
├── Localization (AppLocalizations)
├── State Management (Riverpod)
├── Features
│   ├── Catalog
│   ├── Cart
│   ├── Orders
│   └── Profile
└── Shared Components
    ├── Loading Widgets
    ├── Error Widgets
    └── Navigation Components
```

### **2. Widget Organization | تنظيم الودجت**
- **Pages**: Top-level screens and routes
- **Widgets**: Reusable UI components
- **Controllers**: State management and business logic
- **Models**: UI-specific data models

## 🔄 **State Management & UI | إدارة الحالة والواجهة**

### **1. Riverpod State Management | إدارة الحالة مع Riverpod**
```dart
@riverpod
class CatalogNotifier extends _$CatalogNotifier {
  @override
  Future<List<Product>> build() async {
    return await ref.read(productRepositoryProvider).getProducts();
  }
  
  Future<void> refreshProducts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(productRepositoryProvider).getProducts()
    );
  }
  
  Future<void> addToWishlist(String productId) async {
    await ref.read(productRepositoryProvider).addToWishlist(productId);
    // Refresh the list to show updated wishlist status
    refreshProducts();
  }
}
```

### **2. UI State Handling | معالجة حالة الواجهة**
```dart
class CatalogPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(catalogNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: productsAsync.when(
        data: (products) => ProductList(products: products),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(
          error: error,
          onRetry: () => ref.read(catalogNotifierProvider.notifier).refreshProducts(),
        ),
      ),
    );
  }
}
```

## 🧭 **Navigation & Routing | التنقل والتوجيه**

### **1. GoRouter Configuration | إعداد GoRouter**
```dart
final router = GoRouter(
  initialLocation: '/catalog',
  routes: [
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogPage(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
  ],
);
```

### **2. Deep Linking Support | دعم الروابط العميقة**
```dart
// Handle deep links
class DeepLinkHandler {
  static void handleDeepLink(String link) {
    if (link.contains('/product/')) {
      final productId = link.split('/product/')[1];
      GoRouter.of(context).go('/product/$productId');
    }
  }
}
```

## ♿ **Accessibility & RTL | إمكانية الوصول والنص من اليمين لليسار**

### **1. Accessibility Implementation | تنفيذ إمكانية الوصول**
```dart
class AccessibleProductCard extends StatelessWidget {
  final Product product;
  
  const AccessibleProductCard({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Product: ${product.title}, Price: ${product.displayPrice}',
      hint: 'Double tap to view product details',
      button: true,
      child: Card(
        child: InkWell(
          onTap: () => _navigateToProduct(context),
          child: Column(
            children: [
              Image.network(product.imageUrl ?? ''),
              Text(product.title),
              Text(product.displayPrice),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **2. RTL Support | دعم النص من اليمين لليسار**
```dart
class RTLProductCard extends StatelessWidget {
  final Product product;
  
  const RTLProductCard({required this.product});
  
  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Card(
      child: Row(
        children: [
          if (isRTL) ...[
            Expanded(child: _buildProductInfo()),
            _buildProductImage(),
          ] else ...[
            _buildProductImage(),
            Expanded(child: _buildProductInfo()),
          ],
        ],
      ),
    );
  }
}
```

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Presentation Layer  
**Status | الحالة**: ✅ Production Ready

---

## 🔗 **Navigation | التنقل**

[← Previous: Domain Layer | السابق: طبقة المجال](04_Domain_Layer.md)
[Next: Design System | التالي: نظام التصميم →](06_Design_System.md)
[🏠 Home | الرئيسية](../../index.html)

### **Quick Navigation | التنقل السريع**
- [Presentation Layer Architecture | معمارية طبقة العرض](#-presentation-layer-architecture--معمارية-طبقة-العرض)
- [UI Component Architecture | معمارية مكونات الواجهة](#-ui-component-architecture--معمارية-مكونات-الواجهة)
- [State Management & UI | إدارة الحالة والواجهة](#-state-management--ui--إدارة-الحالة-والواجهة)
- [Navigation & Routing | التنقل والتوجيه](#-navigation--routing--التنقل-والتوجيه)
- [Accessibility & RTL | إمكانية الوصول والنص من اليمين لليسار](#-accessibility--rtl--إمكانية-الوصول-والنص-من-اليمين-ليسار)

### **Related Files | الملفات ذات الصلة**
- [Domain Layer | طبقة المجال](04_Domain_Layer.md)
- [Design System | نظام التصميم](06_Design_System.md)
- [State Management & DI | إدارة الحالة وحقن التبعية](02_State_Management_DI.md)

### **Shared Architecture Resources | موارد المعمارية المشتركة**
- [Quality Standards | معايير الجودة](Quality_Standards.md)
- [Testing Strategy | استراتيجية الاختبار](Testing_Strategy.md)
- [Troubleshooting Guide | دليل استكشاف الأخطاء](Troubleshooting_Guide.md)
- [Best Practices | أفضل الممارسات](Best_Practices.md)
- [Success Criteria | معايير النجاح](Success_Criteria.md)

---