# 8. استراتيجية الاختبار
## 8. Testing Strategy

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

---

## 🎯 **Objective | الهدف**
Implement comprehensive testing strategy to ensure code quality, prevent regressions, and maintain high reliability across all application features.

## 📋 **Rule | القاعدة**
**Arabic**: هرَم اختبارات: Unit (Use-cases, Repos), Widget (Screens), Integration (رحلة شراء)  
**English**: Test pyramid: Unit (Use-cases, Repos), Widget (Screens), Integration (purchase journey)

## 💡 **Benefits | الفوائد**
- **Quality Assurance | ضمان الجودة**: Catch bugs before they reach production
- **Regression Prevention | منع التراجع**: Ensure changes don't break existing functionality
- **Documentation | التوثيق**: Tests serve as living documentation
- **Confidence | الثقة**: Deploy with confidence knowing code works
- **Refactoring Safety | أمان إعادة الهيكلة**: Safe to refactor with test coverage
- **Team Collaboration | تعاون الفريق**: Clear expectations and standards

## 🛠️ **Implementation | التطبيق**
- **Use in**: All features, especially critical business logic
- **How to implement**:
  - Unit tests for business logic (70% coverage)
  - Widget tests for UI components
  - Integration tests for user journeys
  - Golden tests for visual consistency
  - Performance tests for critical paths
- **Result**: Reliable, maintainable codebase with high confidence

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Testing Strategy Specific Criteria:**
- [ ] 70%+ test coverage for business logic
- [ ] All critical user journeys covered by integration tests
- [ ] Golden tests for visual components
- [ ] Performance tests for critical paths
- [ ] CI/CD pipeline runs all tests
- [ ] Zero critical bugs in production

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Testing Strategy Specific Pitfalls:**
- **Avoid**: Testing implementation details instead of behavior
- **Avoid**: Flaky tests that fail randomly
- **Avoid**: Over-mocking that makes tests brittle
- **Avoid**: Missing edge cases and error scenarios
- **Avoid**: Slow tests that slow down development
- **Avoid**: Tests that don't add value or confidence

## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **Testing Strategy Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Production Bugs** | High | Medium | Comprehensive test coverage, CI/CD gates |
| **Flaky Tests** | Medium | High | Deterministic test data, proper mocking |
| **Slow Test Suite** | Medium | Medium | Parallel execution, test optimization |
| **Missing Edge Cases** | High | Medium | Test case reviews, boundary testing |

## 📊 **Testing Scenarios | سيناريوهات الاختبار**

### **Critical User Journeys | الرحلات الحرجة**
1. **Browse → Add to Cart → Checkout (Sanaa)**
   - Expect `cod_standard` and no deposit required
2. **Checkout (Outside Sanaa)**
   - Show deposit modal → accept → complete order
3. **Invalid/Expired Coupon**
   - Correct error message and price unchanged
4. **Out of Stock During Checkout**
   - Show 409 conflict → suggest alternative/return to cart
5. **Change Address Before Payment**
   - Recalculate shipping automatically
6. **Deep Link from Notification**
   - Open correct product/order
7. **Network Disconnection in Cart**
   - Offline queue → network return → sync
8. **Order Status Notification**
   - Open correct order screen (deeplink)
9. **Promo Notification After Purchase**
   - **Don't send** (respect 48h rule)
10. **Token Expiry During Order**
   - Successful refresh → continue; on refresh failure → clean logout

### **Performance Test Scenarios | سيناريوهات اختبار الأداء**
- **Cold start ≤ 2.0s** on 2GB RAM device
- **PDP build ≤ 120ms**
- **Jank < 0.5%** in long lists
- **App size ≤ 40MB** (CI fails if >5% increase)

### **Security Test Scenarios | سيناريوهات اختبار الأمان**
- **Token refresh** works; on failure → clean logout
- **No tokens in SharedPreferences**
- **No sensitive data in logs**
- **Deep link validation** works correctly

---

## 🧪 **Test Pyramid | هرم الاختبارات**

### **1. Unit Tests (70%)**
```dart
// test/unit/domain/usecases/get_product_list_test.dart
void main() {
  group('GetProductList', () {
    late GetProductList useCase;
    late MockCatalogRepository mockRepository;
    
    setUp(() {
      mockRepository = MockCatalogRepository();
      useCase = GetProductList(mockRepository);
    });
    
    test('should return products when repository succeeds', () async {
      // Arrange
      final products = [testProduct1, testProduct2];
      when(mockRepository.getProducts(any, any, any, any, any))
          .thenAnswer((_) async => Result.ok(products));
      
      // Act
      final result = await useCase.call();
      
      // Assert
      expect(result.isSuccess, true);
      expect(result.data, products);
      verify(mockRepository.getProducts(any, any, any, any, any));
    });
    
    test('should return error when repository fails', () async {
      // Arrange
      when(mockRepository.getProducts(any, any, any, any, any))
          .thenAnswer((_) async => Result.err(AppFailure.network()));
      
      // Act
      final result = await useCase.call();
      
      // Assert
      expect(result.isError, true);
      expect(result.failure, isA<NetworkFailure>());
    });
  });
}
```

### **2. Widget Tests (20%)**
```dart
// test/widget/presentation/widgets/product_card_test.dart
void main() {
  group('ProductCard', () {
    testWidgets('should display product information', (tester) async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('100 YER'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
    
    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      bool wasTapped = false;
      final product = testProduct;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(ProductCard));
      
      // Assert
      expect(wasTapped, true);
    });
  });
}
```

### **3. Integration Tests (10%)**
```dart
// integration_test/app_test.dart
void main() {
  group('App Integration Tests', () {
    testWidgets('complete checkout flow', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();
      
      // Act & Assert
      // Navigate to catalog
      await tester.tap(find.text('المنتجات'));
      await tester.pumpAndSettle();
      
      // Add product to cart
      await tester.tap(find.byKey(Key('add_to_cart_1')));
      await tester.pumpAndSettle();
      
      // Go to cart
      await tester.tap(find.byKey(Key('cart_button')));
      await tester.pumpAndSettle();
      
      // Verify cart has item
      expect(find.text('Test Product'), findsOneWidget);
    });
  });
}
```

---

## 🎨 **Golden Tests | اختبارات الصور الذهبية**
<!-- 🔴 ENHANCEMENT: Added from original documents - Visual regression testing -->

```dart
// test/golden/widget_golden_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('Golden Tests', () {
    testGoldens('Product List RTL', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            home: ProductListPage(),
          ),
        ),
      );
      await expectLater(
        find.byType(ProductListPage),
        matchesGoldenFile('product_list_rtl.png'),
      );
    });

    testGoldens('Product Detail LTR', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailPage(productId: 'test-123'),
        ),
      );
      await expectLater(
        find.byType(ProductDetailPage),
        matchesGoldenFile('product_detail_ltr.png'),
      );
    });

    testGoldens('Cart Empty State', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CartPage(),
        ),
      );
      await expectLater(
        find.byType(CartPage),
        matchesGoldenFile('cart_empty_state.png'),
      );
    });

    testGoldens('Error State Network', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorStateWidget(
            errorType: ErrorType.network,
            onRetry: () {},
          ),
        ),
      );
      await expectLater(
        find.byType(ErrorStateWidget),
        matchesGoldenFile('error_network_state.png'),
      );
    });
  });
}
```

---

## ⚡ **Performance Tests | اختبارات الأداء**
<!-- 🔴 ENHANCEMENT: Added from original documents - Performance testing with specific budgets -->

```dart
// test/performance/performance_test.dart
void main() {
  group('Performance Tests', () {
    testWidgets('App Start Performance', (tester) async {
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // Cold start should be ≤ 2.5s
      expect(stopwatch.elapsedMilliseconds, lessThanOrEqualTo(2500));
    });

    testWidgets('Product Detail Load Performance', (tester) async {
      await tester.pumpWidget(MaterialApp(home: ProductDetailPage()));
      
      final stopwatch = Stopwatch()..start();
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      // PDP load should be ≤ 200ms
      expect(stopwatch.elapsedMilliseconds, lessThanOrEqualTo(200));
    });

    testWidgets('Scroll Performance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Test smooth scrolling
      await tester.fling(find.byType(ListView), Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      
      // Should not have jank (tested via DevTools in real scenarios)
    });
  });
}
```

---

## 🌐 **Network Tests | اختبارات الشبكة**
<!-- 🔴 ENHANCEMENT: Added from original documents - Network resilience testing -->

```dart
// test/network/network_test.dart
void main() {
  group('Network Tests', () {
    testWidgets('Offline Mode Handling', (tester) async {
      // Simulate offline mode
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(),
        ),
      );
      
      // Should show offline indicator
      expect(find.text('اتصالك بالإنترنت غير متوفر'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets('Timeout Handling', (tester) async {
      // Mock timeout response
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(),
        ),
      );
      
      // Should show timeout message
      expect(find.text('الخدمة تتأخر بالاستجابة'), findsOneWidget);
    });

    testWidgets('Retry Mechanism', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(),
        ),
      );
      
      // Tap retry button
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();
      
      // Should attempt retry
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## 📊 **Analytics Tests | اختبارات التحليلات**
<!-- 🔴 ENHANCEMENT: Added from original documents - Analytics event validation -->

```dart
// test/analytics/analytics_test.dart
void main() {
  group('Analytics Tests', () {
    test('Purchase Event Tracking', () async {
      final mockAnalytics = MockAnalyticsService();
      
      await EcommerceAnalytics.trackPurchase(
        transactionId: 'test-123',
        value: 100.0,
        currency: 'YER',
        items: [
          CartItem(productId: 'prod-1', name: 'Test Product', price: 100.0, quantity: 1),
        ],
        paymentMethod: 'cod',
        region: 'sanaa',
      );
      
      verify(mockAnalytics.logPurchase(
        transactionId: 'test-123',
        value: 100.0,
        currency: 'YER',
        parameters: anyNamed('parameters'),
      )).called(1);
    });

    test('Screen View Tracking', () async {
      final mockAnalytics = MockAnalyticsService();
      
      await AnalyticsService.trackScreenView('product_detail', {
        'product_id': 'prod-123',
        'category': 'dresses',
      });
      
      verify(mockAnalytics.logEvent(
        name: 'screen_view',
        parameters: {
          'screen_name': 'product_detail',
          'product_id': 'prod-123',
          'category': 'dresses',
        },
      )).called(1);
    });
  });
}
```

---

## 🏗️ **Test Structure | هيكلة مجلدات الاختبار**

```
/test
  /unit/                    # اختبارات الوحدة
    /domain/
      /usecases/
        get_product_list_test.dart
        add_to_cart_test.dart
    /data/
      /repositories/
        catalog_repository_impl_test.dart
    /presentation/
      /controllers/
        catalog_controller_test.dart
  /widget/                  # اختبارات الواجهة
    /presentation/
      /pages/
        catalog_page_test.dart
        product_detail_page_test.dart
      /widgets/
        product_card_test.dart
        loading_widget_test.dart
  /integration/             # اختبارات التكامل
    app_test.dart
    checkout_flow_test.dart
  /golden/                  # اختبارات الصور الذهبية
    product_list_rtl_test.dart
    product_detail_ltr_test.dart
  /performance/             # اختبارات الأداء
    app_start_test.dart
    scroll_performance_test.dart
  /network/                 # اختبارات الشبكة
    offline_test.dart
    timeout_test.dart
  /analytics/               # اختبارات التحليلات
    purchase_tracking_test.dart
    screen_view_test.dart
  /fixtures/                # بيانات الاختبار
    test_products.dart
    test_cart_items.dart
  /mocks/                   # Mock objects
    mock_catalog_repository.dart
    mock_analytics_service.dart
```

---

## 🛠️ **Testing Tools & Setup**

### **1. Dependencies**
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^0.3.0
  golden_toolkit: ^0.15.0
  integration_test:
    sdk: flutter
  test: ^1.21.0
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  freezed: ^2.4.0
```

### **2. Test Configuration**
```yaml
# test/test_config.yaml
test_timeout: 30s
reporter: expanded
coverage:
  include:
    - lib/**
  exclude:
    - lib/**/*.g.dart
    - lib/**/*.freezed.dart
```

### **3. Mock Setup**
```dart
// test/mocks/mock_catalog_repository.dart
class MockCatalogRepository extends Mock implements CatalogRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockCartRepository extends Mock implements CartRepository {}

// Test data
final testProduct = Product(
  id: '1',
  name: 'Test Product',
  price: 100.0,
  imageUrl: 'https://example.com/image.jpg',
);

final testCartItem = CartItem(
  productId: '1',
  name: 'Test Product',
  price: 100.0,
  quantity: 1,
);
```

---

## 📈 **Test Coverage & Metrics**

### **1. Coverage Goals**
- **Unit Tests**: ≥ 80%
- **Widget Tests**: ≥ 70%
- **Integration Tests**: ≥ 50%
- **Overall Coverage**: ≥ 70%

### **2. Coverage Commands**
```bash
# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

### **3. Coverage Configuration**
```yaml
# coverage.yaml
coverage:
  include:
    - lib/**
  exclude:
    - lib/**/*.g.dart
    - lib/**/*.freezed.dart
    - lib/**/main.dart
    - lib/**/injection.dart
```

---

## 🚀 **CI/CD Integration**

### **1. GitHub Actions**
```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run unit tests
      run: flutter test --coverage
      
    - name: Run widget tests
      run: flutter test test/widget/
      
    - name: Run integration tests
      run: flutter test integration_test/
      
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
```

---

## 📊 **Best Practices**

### **1. Test Design**
- [ ] اكتب اختبارات بسيطة وواضحة
- [ ] استخدم AAA pattern (Arrange, Act, Assert)
- [ ] اختبر حالة واحدة في كل اختبار
- [ ] استخدم أسماء وصفية للاختبارات

### **2. Mocking**
- [ ] استخدم mocks للـ dependencies
- [ ] اختبر الحالات الاستثنائية
- [ ] استخدم verify للتحقق من الاستدعاءات
- [ ] استخدم when للتحكم في السلوك

### **3. Coverage**
- [ ] استهدف تغطية عالية للكود المهم
- [ ] اختبر الحالات الاستثنائية
- [ ] استخدم coverage reports للتحليل
- [ ] استخدم quality gates

---

## 🔗 **الروابط ذات الصلة | Related Links**

- [جودة الكود والمعايير](09_Code_Quality_Standards.md)
- [سير عمل Git والفروع](10_Git_Workflow.md)
- [خط أنابيب CI/CD](11_CI_CD_Pipeline.md)
- [تحسين الأداء](12_Performance_Optimization.md)

---

## 📚 **المراجع | References**

- [Flutter Testing](https://docs.flutter.dev/testing)
- [Golden Toolkit](https://pub.dev/packages/golden_toolkit)
- [Mocktail](https://pub.dev/packages/mocktail)

---

**🔴 ENHANCEMENT**: محتوى مأخوذ من الوثائق الأصلية  
**🔵 SUGGESTION**: اقتراحات مبنية على الخبرة التقنية

---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../index.html)

---
