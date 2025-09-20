# 5. التوجيه والتوجيه
## 5. Navigation & Routing

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement comprehensive navigation and routing system using GoRouter with deep linking, route guards, and type-safe navigation.

## 📋 **Rule | القاعدة**
**Arabic**: استخدم go_router مع Guards للطرق المحمية، وادعم Deep Links & Dynamic Links  
**English**: Use go_router with Guards for protected routes, and support Deep Links & Dynamic Links

## 💡 **Benefits | الفوائد**
- **Type Safety | أمان الأنواع**: Compile-time route validation
- **Deep Linking | الروابط العميقة**: Seamless external link handling
- **Route Protection | حماية المسارات**: Secure access control
- **Centralized Routing | التوجيه المركزي**: Single source of truth for navigation
- **Testing | الاختبار**: Easy to test navigation flows
- **Maintainability | سهولة الصيانة**: Clear navigation structure

---

## 🧭 **التوجيه | Navigation**

### **1. Go Router Configuration**
```dart
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/catalog',
      name: 'catalog',
      builder: (context, state) => const CatalogPage(),
      routes: [
        GoRoute(
          path: '/product/:id',
          name: 'product-detail',
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return ProductDetailPage(productId: productId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
  ],
);
```

### **2. Route Guards**
```dart
class AuthGuard extends GoRoute {
  AuthGuard({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) : super(
          path: path,
          name: name,
          builder: (context, state) {
            final authState = context.read(authControllerProvider);
            
            if (authState.isAuthenticated) {
              return builder(context, state);
            } else {
              return const LoginPage();
            }
          },
        );
}

// Usage
GoRoute(
  path: '/profile',
  name: 'profile',
  builder: (context, state) => const ProfilePage(),
  redirect: (context, state) {
    final authState = context.read(authControllerProvider);
    return authState.isAuthenticated ? null : '/login';
  },
)
```

### **3. Nested Navigation**
```dart
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/catalog',
          name: 'catalog',
          builder: (context, state) => const CatalogPage(),
          routes: [
            GoRoute(
              path: '/product/:id',
              name: 'product-detail',
              builder: (context, state) {
                final productId = state.pathParameters['id']!;
                return ProductDetailPage(productId: productId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
```

---

## 🔗 **Deep Linking | الروابط العميقة**

### **1. Deep Link Configuration**
```dart
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/product/:id',
      name: 'product-detail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/order/:id',
      name: 'order-detail',
      builder: (context, state) {
        final orderId = state.pathParameters['id']!;
        return OrderDetailPage(orderId: orderId);
      },
    ),
  ],
);
```

### **2. Dynamic Links**
```dart
class DeepLinkService {
  static Future<void> handleDynamicLink(String link) async {
    final uri = Uri.parse(link);
    
    switch (uri.pathSegments.first) {
      case 'product':
        final productId = uri.pathSegments[1];
        await _navigateToProduct(productId);
        break;
      case 'order':
        final orderId = uri.pathSegments[1];
        await _navigateToOrder(orderId);
        break;
      default:
        await _navigateToHome();
    }
  }
  
  static Future<void> _navigateToProduct(String productId) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/product/$productId');
    }
  }
  
  static Future<void> _navigateToOrder(String orderId) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/order/$orderId');
    }
  }
}
```

### **3. URL Generation**
```dart
class AppUrls {
  static String product(String productId) => '/product/$productId';
  static String order(String orderId) => '/order/$orderId';
  static String category(String categoryId) => '/catalog?category=$categoryId';
  static String search(String query) => '/catalog?search=$query';
}

// Usage
context.go(AppUrls.product('123'));
context.go(AppUrls.order('456'));
```

---

## 🛡️ **Route Protection | حماية المسارات**

### **1. Authentication Guard**
```dart
class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authState = context.read(authControllerProvider);
    final isAuthenticated = authState.isAuthenticated;
    final isLoggingIn = state.matchedLocation == '/login';
    
    if (!isAuthenticated && !isLoggingIn) {
      return '/login';
    }
    
    if (isAuthenticated && isLoggingIn) {
      return '/home';
    }
    
    return null;
  }
}
```

### **2. Role-Based Access**
```dart
class RoleGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final user = context.read(userControllerProvider).value;
    final requiredRole = state.extra as String?;
    
    if (requiredRole != null && user?.role != requiredRole) {
      return '/unauthorized';
    }
    
    return null;
  }
}

// Usage
GoRoute(
  path: '/admin',
  name: 'admin',
  builder: (context, state) => const AdminPage(),
  redirect: (context, state) => RoleGuard.redirect(context, state, 'admin'),
)
```

### **3. Feature Flag Guard**
```dart
class FeatureFlagGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final featureFlags = context.read(featureFlagsControllerProvider);
    final requiredFeature = state.extra as String?;
    
    if (requiredFeature != null && !featureFlags.isEnabled(requiredFeature)) {
      return '/feature-unavailable';
    }
    
    return null;
  }
}
```

---

## 🧪 **Navigation Testing | اختبار التوجيه**

### **1. Navigation Test Template**
```dart
// test/navigation/app_router_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zahraah_app/core/router/app_router.dart';

void main() {
  group('App Router', () {
    testWidgets('navigates to product detail page', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: appRouter,
        ),
      );
      
      // Navigate to product detail
      context.go('/product/123');
      await tester.pumpAndSettle();
      
      // Verify product detail page is displayed
      expect(find.byType(ProductDetailPage), findsOneWidget);
    });
    
    testWidgets('redirects to login when not authenticated', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: appRouter,
        ),
      );
      
      // Try to navigate to protected route
      context.go('/profile');
      await tester.pumpAndSettle();
      
      // Verify redirect to login
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
```

### **2. Deep Link Test**
```dart
testWidgets('handles deep link correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: appRouter,
    ),
  );
  
  // Simulate deep link
  await DeepLinkService.handleDynamicLink('https://app.zahraah.com/product/123');
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.byType(ProductDetailPage), findsOneWidget);
});
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Presentation Layer Overview | السابق: نظرة عامة على طبقة العرض](05_Presentation_Layer_Overview.md)
[Next: State Management & UI | التالي: إدارة الحالة والواجهة →](05_State_Management_UI.md)
[🏠 Home | الرئيسية](../../../index.html)

---
