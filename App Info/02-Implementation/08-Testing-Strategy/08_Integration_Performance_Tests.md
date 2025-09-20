# 8. اختبارات التكامل والأداء
## 8. Integration & Performance Tests

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Implement comprehensive integration tests for user journeys and performance tests for critical paths to ensure end-to-end functionality and optimal performance.

## 📋 **Rule | القاعدة**
**Arabic**: اختبارات التكامل للرحلات الكاملة، اختبارات الأداء للمسارات الحرجة  
**English**: Integration tests for complete journeys, Performance tests for critical paths

## 💡 **Benefits | الفوائد**
- **End-to-End Validation | التحقق الشامل**: Test complete user journeys
- **Performance Assurance | ضمان الأداء**: Ensure optimal app performance
- **Real-World Testing | اختبار الواقع**: Test with real data and conditions
- **Regression Prevention | منع التراجع**: Catch integration issues early
- **User Experience | تجربة المستخدم**: Ensure smooth user interactions
- **Scalability | قابلية التوسع**: Test app behavior under load

---

## 🔗 **Integration Tests | اختبارات التكامل**

### **1. User Journey Tests**
```dart
// test/integration/user_journeys/shopping_journey_test.dart
void main() {
  group('Shopping Journey', () {
    testWidgets('complete purchase journey', (tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Act & Assert - Browse products
      await tester.tap(find.text('المنتجات'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductCard), findsWidgets);
      
      // Act & Assert - View product details
      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailPage), findsOneWidget);
      
      // Act & Assert - Add to cart
      await tester.tap(find.text('أضف إلى السلة'));
      await tester.pumpAndSettle();
      expect(find.text('تم إضافة المنتج إلى السلة'), findsOneWidget);
      
      // Act & Assert - Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      expect(find.byType(CartPage), findsOneWidget);
      expect(find.byType(CartItemWidget), findsOneWidget);
      
      // Act & Assert - Proceed to checkout
      await tester.tap(find.text('الذهاب للدفع'));
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutPage), findsOneWidget);
      
      // Act & Assert - Fill shipping information
      await tester.enterText(find.byKey(const Key('shipping_name')), 'أحمد محمد');
      await tester.enterText(find.byKey(const Key('shipping_address')), 'شارع الملك فهد');
      await tester.enterText(find.byKey(const Key('shipping_city')), 'الرياض');
      await tester.enterText(find.byKey(const Key('shipping_phone')), '0501234567');
      
      // Act & Assert - Select payment method
      await tester.tap(find.text('الدفع عند الاستلام'));
      await tester.pumpAndSettle();
      
      // Act & Assert - Place order
      await tester.tap(find.text('تأكيد الطلب'));
      await tester.pumpAndSettle();
      expect(find.text('تم تأكيد طلبك بنجاح'), findsOneWidget);
    });
  });
}
```

### **2. Authentication Flow Tests**
```dart
// test/integration/auth/authentication_flow_test.dart
void main() {
  group('Authentication Flow', () {
    testWidgets('user registration and login flow', (tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Act & Assert - Navigate to login
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
      
      // Act & Assert - Switch to registration
      await tester.tap(find.text('إنشاء حساب جديد'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterPage), findsOneWidget);
      
      // Act & Assert - Fill registration form
      await tester.enterText(find.byKey(const Key('first_name')), 'أحمد');
      await tester.enterText(find.byKey(const Key('last_name')), 'محمد');
      await tester.enterText(find.byKey(const Key('email')), 'ahmed@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'password123');
      await tester.enterText(find.byKey(const Key('confirm_password')), 'password123');
      
      // Act & Assert - Submit registration
      await tester.tap(find.text('إنشاء الحساب'));
      await tester.pumpAndSettle();
      expect(find.text('تم إنشاء الحساب بنجاح'), findsOneWidget);
      
      // Act & Assert - Verify email
      await tester.tap(find.text('تحقق من البريد الإلكتروني'));
      await tester.pumpAndSettle();
      expect(find.text('تم إرسال رابط التحقق'), findsOneWidget);
      
      // Act & Assert - Login with new account
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('email')), 'ahmed@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'password123');
      await tester.tap(find.text('دخول'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
```

### **3. API Integration Tests**
```dart
// test/integration/api/catalog_api_test.dart
void main() {
  group('Catalog API Integration', () {
    late MockClient mockClient;
    late CatalogRemoteDataSourceImpl dataSource;
    
    setUp(() {
      mockClient = MockClient();
      dataSource = CatalogRemoteDataSourceImpl(client: mockClient);
    });
    
    test('should fetch products from API successfully', () async {
      // Arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(
                jsonEncode({
                  'products': [
                    {
                      'id': '1',
                      'name': 'Test Product',
                      'price': 100.0,
                      'imageUrl': 'https://example.com/image.jpg',
                    }
                  ]
                }),
                200,
              ));
      
      // Act
      final result = await dataSource.getProducts();
      
      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Product');
    });
    
    test('should handle API errors gracefully', () async {
      // Arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('Server Error', 500));
      
      // Act & Assert
      expect(
        () => dataSource.getProducts(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
```

---

## ⚡ **Performance Tests | اختبارات الأداء**

### **1. Widget Performance Tests**
```dart
// test/performance/widget_performance_test.dart
void main() {
  group('Widget Performance', () {
    testWidgets('product list should render within performance budget', (tester) async {
      // Arrange
      final products = List.generate(100, (index) => ProductBuilder()
          .withId('$index')
          .withName('Product $index')
          .build());
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(products: products),
        ),
      );
      
      // Assert - Check frame timing
      final frameTimings = tester.binding.frameTimings;
      final averageFrameTime = frameTimings
          .map((timing) => timing.totalSpan.inMicroseconds)
          .reduce((a, b) => a + b) / frameTimings.length;
      
      expect(averageFrameTime, lessThan(16667)); // 60 FPS threshold
    });
    
    testWidgets('catalog page should load within 2 seconds', (tester) async {
      // Arrange
      final stopwatch = Stopwatch()..start();
      
      // Act
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('المنتجات'));
      await tester.pumpAndSettle();
      
      // Assert
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });
  });
}
```

### **2. Memory Performance Tests**
```dart
// test/performance/memory_performance_test.dart
void main() {
  group('Memory Performance', () {
    test('app should not leak memory during navigation', () async {
      // Arrange
      final app = MyApp();
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      
      // Act - Navigate through multiple screens
      for (int i = 0; i < 10; i++) {
        await binding.pumpWidget(app);
        await binding.tap(find.text('المنتجات'));
        await binding.pumpAndSettle();
        await binding.tap(find.text('الرئيسية'));
        await binding.pumpAndSettle();
      }
      
      // Assert - Force garbage collection and check memory
      await binding.pumpAndSettle();
      expect(binding.memoryUsage, lessThan(100 * 1024 * 1024)); // 100MB limit
    });
    
    test('image loading should not cause memory spikes', () async {
      // Arrange
      final products = List.generate(50, (index) => ProductBuilder()
          .withImageUrl('https://example.com/large-image-$index.jpg')
          .build());
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductListPage(products: products),
        ),
      );
      await tester.pumpAndSettle();
      
      // Assert
      final memoryUsage = tester.binding.memoryUsage;
      expect(memoryUsage, lessThan(200 * 1024 * 1024)); // 200MB limit
    });
  });
}
```

### **3. Network Performance Tests**
```dart
// test/performance/network_performance_test.dart
void main() {
  group('Network Performance', () {
    test('API calls should complete within timeout', () async {
      // Arrange
      final repository = CatalogRepositoryImpl(
        remoteDataSource: CatalogRemoteDataSourceImpl(client: http.Client()),
        localDataSource: CatalogLocalDataSourceImpl(),
        networkInfo: NetworkInfoImpl(),
      );
      
      // Act
      final stopwatch = Stopwatch()..start();
      final result = await repository.getProducts();
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 second timeout
      expect(result.isSuccess, true);
    });
    
    test('image loading should be optimized', () async {
      // Arrange
      final imageUrl = 'https://example.com/large-image.jpg';
      final stopwatch = Stopwatch()..start();
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImage(imageUrl: imageUrl),
          ),
        ),
      );
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // 3 second limit
    });
  });
}
```

---

## 📊 **Performance Monitoring | مراقبة الأداء**

### **1. Performance Metrics**
```dart
// lib/core/performance/performance_monitor.dart
class PerformanceMonitor {
  static final Map<String, List<int>> _metrics = {};
  
  static void recordMetric(String name, int value) {
    _metrics.putIfAbsent(name, () => []).add(value);
  }
  
  static Map<String, double> getAverageMetrics() {
    return _metrics.map((key, value) => MapEntry(
      key,
      value.reduce((a, b) => a + b) / value.length,
    ));
  }
  
  static void resetMetrics() {
    _metrics.clear();
  }
}

// Usage in tests
testWidgets('should record performance metrics', (tester) async {
  // Act
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
  
  // Record metrics
  PerformanceMonitor.recordMetric('app_startup_time', 1500);
  PerformanceMonitor.recordMetric('first_frame_time', 200);
  
  // Assert
  final metrics = PerformanceMonitor.getAverageMetrics();
  expect(metrics['app_startup_time'], lessThan(2000));
  expect(metrics['first_frame_time'], lessThan(300));
});
```

### **2. Performance Budgets**
```dart
// test/performance/performance_budgets_test.dart
void main() {
  group('Performance Budgets', () {
    test('app startup should be under 2 seconds', () async {
      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });
    
    test('navigation should be under 500ms', () async {
      await tester.pumpWidget(const MyApp());
      
      final stopwatch = Stopwatch()..start();
      await tester.tap(find.text('المنتجات'));
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
    
    test('API calls should be under 3 seconds', () async {
      final stopwatch = Stopwatch()..start();
      final result = await repository.getProducts();
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      expect(result.isSuccess, true);
    });
  });
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Unit & Widget Tests | السابق: اختبارات الوحدة والواجهة](08_Unit_Widget_Tests.md)
[Next: Testing Tools & CI | التالي: أدوات الاختبار و CI/CD →](08_Testing_Tools_CI.md)
[🏠 Home | الرئيسية](../../../index.html)

---
