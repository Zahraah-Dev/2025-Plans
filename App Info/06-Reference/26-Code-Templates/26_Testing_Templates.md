# 26. قوالب الاختبار
## 26. Testing Templates

> **الجزء السادس: المراجع والأدوات | Part VI: References & Tools**

## 🎯 **Objective | الهدف**
Provide comprehensive testing templates for unit tests, widget tests, and integration tests in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: قوالب جاهزة للاختبار + اختبارات الوحدة + اختبارات الواجهة + اختبارات التكامل  
**English**: Ready-to-use testing templates + Unit tests + Widget tests + Integration tests

## 💡 **Benefits | الفوائد**
- **Test Coverage | تغطية الاختبارات**: Comprehensive test coverage
- **Quality Assurance | ضمان الجودة**: Automated quality checks
- **Regression Prevention | منع التراجع**: Prevent code regressions
- **Documentation | التوثيق**: Tests serve as living documentation
- **Confidence | الثقة**: Deploy with confidence
- **Maintainability | سهولة الصيانة**: Easier to maintain and refactor

---

## 🧪 **Testing Templates | قوالب الاختبار**

### **1. Unit Test Template**
```dart
// test/unit/domain/usecases/get_product_list_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zahraah_app/domain/usecases/get_product_list.dart';
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/domain/repositories/catalog_repository.dart';
import 'package:zahraah_app/core/errors/failures.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late GetProductList usecase;
  late MockCatalogRepository mockRepository;

  setUp(() {
    mockRepository = MockCatalogRepository();
    usecase = GetProductList(mockRepository);
  });

  group('GetProductList', () {
    test('should return products when repository call is successful', () async {
      // Arrange
      final products = [
        Product(id: '1', name: 'Product 1', price: 100.0),
        Product(id: '2', name: 'Product 2', price: 200.0),
      ];
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Right(products));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(products));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(ServerFailure('Server error')));
      verify(() => mockRepository.getProducts()).called(1);
    });
  });
}
```

### **2. Widget Test Template**
```dart
// test/widget/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zahraah_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:zahraah_app/domain/entities/product.dart';

void main() {
  group('ProductCard', () {
    testWidgets('displays product information correctly', (tester) async {
      // Arrange
      const product = Product(
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
      expect(find.text('\$100.00'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      // Arrange
      const product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
      );
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
```

### **3. Integration Test Template**
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zahraah_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete user journey from catalog to cart', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify catalog page is displayed
      expect(find.text('المنتجات'), findsOneWidget);

      // Tap on first product
      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();

      // Verify product details page
      expect(find.text('تفاصيل المنتج'), findsOneWidget);

      // Add to cart
      await tester.tap(find.text('أضف إلى السلة'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Verify cart page
      expect(find.text('سلة التسوق'), findsOneWidget);
      expect(find.byType(CartItem), findsOneWidget);
    });
  });
}
```

---

## 🎯 **Mock Templates | قوالب المحاكاة**

### **1. Repository Mock Template**
```dart
// test/mocks/mock_catalog_repository.dart
import 'package:mocktail/mocktail.dart';
import 'package:zahraah_app/domain/repositories/catalog_repository.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

// Register fallback values for complex types
void registerFallbackValues() {
  registerFallbackValue(FakeProduct());
  registerFallbackValue(FakeFailure());
}

class FakeProduct extends Fake implements Product {}
class FakeFailure extends Fake implements Failure {}
```

### **2. Data Source Mock Template**
```dart
// test/mocks/mock_catalog_remote_datasource.dart
import 'package:mocktail/mocktail.dart';
import 'package:zahraah_app/data/datasources/catalog_remote_datasource.dart';

class MockCatalogRemoteDataSource extends Mock implements CatalogRemoteDataSource {}
```

---

## 📊 **Test Utilities | أدوات الاختبار**

### **1. Test Helper Functions**
```dart
// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zahraah_app/domain/entities/product.dart';

Product createTestProduct({
  String id = '1',
  String name = 'Test Product',
  double price = 100.0,
  String imageUrl = 'https://example.com/image.jpg',
}) {
  return Product(
    id: id,
    name: name,
    price: price,
    imageUrl: imageUrl,
  );
}

Widget createTestApp({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
    localizationsDelegates: const [
      // Add localization delegates
    ],
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ar', 'SA'),
    ],
  );
}

Future<void> pumpAndSettleWithDelay(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await Future.delayed(const Duration(milliseconds: 100));
}
```

### **2. Golden Test Template**
```dart
// test/golden/product_card_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:zahraah_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:zahraah_app/domain/entities/product.dart';

void main() {
  group('ProductCard Golden Tests', () {
    testGoldens('renders product card correctly', (tester) async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
      );

      await tester.pumpWidgetBuilder(
        ProductCard(product: product),
        wrapper: materialAppWrapper(),
        surfaceSize: const Size(200, 300),
      );

      await screenMatchesGolden(tester, 'product_card');
    });
  });
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Architecture Templates | السابق: قوالب المعمارية](26_Architecture_Templates.md)
[Next: UI Component Templates | التالي: قوالب مكونات الواجهة →](26_UI_Component_Templates.md)
[🏠 Home | الرئيسية](../../../index.html)

---
