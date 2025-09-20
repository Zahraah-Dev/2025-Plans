# 8. اختبارات الوحدة والواجهة
## 8. Unit & Widget Tests

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Implement comprehensive unit tests for business logic and widget tests for UI components to ensure code quality and prevent regressions.

## 📋 **Rule | القاعدة**
**Arabic**: Unit tests للـ Use-cases والـ Repositories، Widget tests للـ Screens والـ Components  
**English**: Unit tests for Use-cases and Repositories, Widget tests for Screens and Components

## 💡 **Benefits | الفوائد**
- **Fast Feedback | ردود فعل سريعة**: Quick test execution for rapid development
- **Isolated Testing | اختبار معزول**: Test individual components independently
- **Regression Prevention | منع التراجع**: Catch bugs before they reach production
- **Documentation | التوثيق**: Tests serve as living documentation
- **Refactoring Safety | أمان إعادة الهيكلة**: Safe to refactor with test coverage
- **Code Quality | جودة الكود**: Ensure code meets quality standards

---

## 🧪 **Unit Tests | اختبارات الوحدة**

### **1. Use Case Tests**
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
    
    test('should validate input parameters', () async {
      // Arrange
      const invalidPage = -1;
      
      // Act
      final result = await useCase.call(page: invalidPage);
      
      // Assert
      expect(result.isError, true);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(mockRepository.getProducts(any, any, any, any, any));
    });
  });
}
```

### **2. Repository Tests**
```dart
// test/unit/data/repositories/catalog_repository_impl_test.dart
void main() {
  group('CatalogRepositoryImpl', () {
    late CatalogRepositoryImpl repository;
    late MockCatalogRemoteDataSource mockRemoteDataSource;
    late MockCatalogLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;
    
    setUp(() {
      mockRemoteDataSource = MockCatalogRemoteDataSource();
      mockLocalDataSource = MockCatalogLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = CatalogRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    });
    
    group('getProducts', () {
      test('should return remote data when network is available', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProducts(any, any, any, any, any))
            .thenAnswer((_) async => [testProduct1, testProduct2]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct1, testProduct2]);
        verify(mockRemoteDataSource.getProducts(any, any, any, any, any));
        verify(mockLocalDataSource.cacheProducts([testProduct1, testProduct2]));
      });
      
      test('should return local data when network is unavailable', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getProducts(any, any, any, any, any))
            .thenAnswer((_) async => [testProduct1]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct1]);
        verify(mockLocalDataSource.getProducts(any, any, any, any, any));
        verifyNever(mockRemoteDataSource.getProducts(any, any, any, any, any));
      });
    });
  });
}
```

### **3. Entity Tests**
```dart
// test/unit/domain/entities/product_test.dart
void main() {
  group('Product', () {
    test('should create product with required fields', () {
      // Arrange
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        categoryId: 'cat1',
        categoryName: 'Category 1',
      );
      
      // Assert
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, 100.0);
      expect(product.isAvailable, true);
      expect(product.stock, 0);
    });
    
    test('should calculate discounted price correctly', () {
      // Arrange
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        categoryId: 'cat1',
        categoryName: 'Category 1',
        discountPercentage: 20.0,
      );
      
      // Act
      final discountedPrice = product.discountedPrice;
      
      // Assert
      expect(discountedPrice, 80.0);
    });
    
    test('should check stock availability correctly', () {
      // Arrange
      const productInStock = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        categoryId: 'cat1',
        categoryName: 'Category 1',
        stock: 5,
        isAvailable: true,
      );
      
      const productOutOfStock = Product(
        id: '2',
        name: 'Test Product 2',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        categoryId: 'cat1',
        categoryName: 'Category 1',
        stock: 0,
        isAvailable: false,
      );
      
      // Assert
      expect(productInStock.isInStock, true);
      expect(productOutOfStock.isInStock, false);
    });
  });
}
```

---

## 🎨 **Widget Tests | اختبارات الواجهة**

### **1. Component Widget Tests**
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
        categoryId: 'cat1',
        categoryName: 'Category 1',
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
    
    testWidgets('should display discount when product is on sale', (tester) async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        imageUrl: 'https://example.com/image.jpg',
        categoryId: 'cat1',
        categoryName: 'Category 1',
        discountPercentage: 20.0,
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
      expect(find.text('20% OFF'), findsOneWidget);
      expect(find.text('80 YER'), findsOneWidget);
    });
  });
}
```

### **2. Screen Widget Tests**
```dart
// test/widget/presentation/pages/catalog_page_test.dart
void main() {
  group('CatalogPage', () {
    testWidgets('should display loading indicator when loading', (tester) async {
      // Arrange
      when(mockCatalogControllerProvider).thenReturn(
        const AsyncValue<List<Product>>.loading(),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const CatalogPage(),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should display products when loaded', (tester) async {
      // Arrange
      final products = [testProduct1, testProduct2];
      when(mockCatalogControllerProvider).thenReturn(
        AsyncValue.data(products),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const CatalogPage(),
        ),
      );
      
      // Assert
      expect(find.byType(ProductCard), findsNWidgets(2));
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
    });
    
    testWidgets('should display error message when error occurs', (tester) async {
      // Arrange
      when(mockCatalogControllerProvider).thenReturn(
        const AsyncValue<List<Product>>.error('Network error'),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const CatalogPage(),
        ),
      );
      
      // Assert
      expect(find.text('حدث خطأ: Network error'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });
  });
}
```

### **3. Form Widget Tests**
```dart
// test/widget/presentation/widgets/login_form_test.dart
void main() {
  group('LoginForm', () {
    testWidgets('should validate email field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(onLogin: (email, password) {}),
          ),
        ),
      );
      
      // Act
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      
      // Assert
      expect(find.text('البريد الإلكتروني غير صحيح'), findsOneWidget);
    });
    
    testWidgets('should validate password field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(onLogin: (email, password) {}),
          ),
        ),
      );
      
      // Act
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      
      // Assert
      expect(find.text('كلمة المرور قصيرة جداً'), findsOneWidget);
    });
    
    testWidgets('should call onLogin with valid credentials', (tester) async {
      // Arrange
      String? capturedEmail;
      String? capturedPassword;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (email, password) {
                capturedEmail = email;
                capturedPassword = password;
              },
            ),
          ),
        ),
      );
      
      // Act
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      
      // Assert
      expect(capturedEmail, 'test@example.com');
      expect(capturedPassword, 'password123');
    });
  });
}
```

---

## 🔧 **Test Utilities | أدوات الاختبار**

### **1. Test Data Builders**
```dart
// test/helpers/test_data_builders.dart
class ProductBuilder {
  String _id = '1';
  String _name = 'Test Product';
  double _price = 100.0;
  String _imageUrl = 'https://example.com/image.jpg';
  String _categoryId = 'cat1';
  String _categoryName = 'Category 1';
  int _stock = 0;
  bool _isAvailable = true;
  double _discountPercentage = 0.0;
  
  ProductBuilder withId(String id) {
    _id = id;
    return this;
  }
  
  ProductBuilder withName(String name) {
    _name = name;
    return this;
  }
  
  ProductBuilder withPrice(double price) {
    _price = price;
    return this;
  }
  
  ProductBuilder withDiscount(double discountPercentage) {
    _discountPercentage = discountPercentage;
    return this;
  }
  
  ProductBuilder outOfStock() {
    _stock = 0;
    _isAvailable = false;
    return this;
  }
  
  Product build() {
    return Product(
      id: _id,
      name: _name,
      price: _price,
      imageUrl: _imageUrl,
      categoryId: _categoryId,
      categoryName: _categoryName,
      stock: _stock,
      isAvailable: _isAvailable,
      discountPercentage: _discountPercentage,
    );
  }
}

// Usage
final product = ProductBuilder()
    .withName('Special Product')
    .withPrice(200.0)
    .withDiscount(25.0)
    .build();
```

### **2. Mock Helpers**
```dart
// test/helpers/mock_helpers.dart
class MockCatalogRepository extends Mock implements CatalogRepository {}
class MockUserRepository extends Mock implements UserRepository {}
class MockCartRepository extends Mock implements CartRepository {}
class MockOrderRepository extends Mock implements OrderRepository {}

// Mock data
final testProduct1 = ProductBuilder().withId('1').withName('Product 1').build();
final testProduct2 = ProductBuilder().withId('2').withName('Product 2').build();
final testUser = UserBuilder().withId('1').withEmail('test@example.com').build();
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Testing Strategy Overview | السابق: نظرة عامة على استراتيجية الاختبار](08_Testing_Strategy_Overview.md)
[Next: Integration & Performance Tests | التالي: اختبارات التكامل والأداء →](08_Integration_Performance_Tests.md)
[🏠 Home | الرئيسية](../../../index.html)

---
