# 3. Testing Data Layer | اختبار طبقة البيانات
## Comprehensive Testing Strategies for Data Layer | استراتيجيات الاختبار الشاملة لطبقة البيانات

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Quality Level**: Enterprise-grade, Production-ready

## 🎯 **Objective | الهدف**
Implement comprehensive testing strategies for data layer components including repositories, data sources, and error handling scenarios.

---

## 🧪 **Repository Testing | اختبار المستودعات**

### **1. Repository Test Setup**
```dart
void main() {
  group('CatalogRepository', () {
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
      test('should return products from remote when connected', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProducts(any, any, any, any, any))
            .thenAnswer((_) async => [testProduct]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct]);
        verify(mockRemoteDataSource.getProducts(any, any, any, any, any));
        verify(mockLocalDataSource.cacheProducts([testProduct]));
      });
      
      test('should return cached products when offline', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getCachedProducts())
            .thenAnswer((_) async => [testProduct]);
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, [testProduct]);
        verify(mockLocalDataSource.getCachedProducts());
        verifyNever(mockRemoteDataSource.getProducts(any, any, any, any, any));
      });
      
      test('should return error when remote fails', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProducts(any, any, any, any, any))
            .thenThrow(ServerException('Server error'));
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isError, true);
        expect(result.failure, isA<ServerFailure>());
      });
    });
    
    group('getProduct', () {
      test('should return product from remote when connected', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProduct(any))
            .thenAnswer((_) async => testProduct);
        
        // Act
        final result = await repository.getProduct('1');
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.data, testProduct);
        verify(mockRemoteDataSource.getProduct('1'));
        verify(mockLocalDataSource.cacheProduct(testProduct));
      });
    });
  });
}
```

### **2. Mock Classes**
```dart
class MockCatalogRemoteDataSource extends Mock implements CatalogRemoteDataSource {}
class MockCatalogLocalDataSource extends Mock implements CatalogLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

final testProduct = Product(
  id: '1',
  title: 'Test Product',
  price: 99.99,
  imageUrl: 'https://example.com/image.jpg',
  description: 'Test description',
  categories: ['category1'],
  stock: 10,
  isAvailable: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

---

## 🔍 **Data Source Testing | اختبار مصادر البيانات**

### **1. Remote Data Source Testing**
```dart
void main() {
  group('CatalogRemoteDataSource', () {
    late CatalogRemoteDataSourceImpl dataSource;
    late MockDio mockDio;
    
    setUp(() {
      mockDio = MockDio();
      dataSource = CatalogRemoteDataSourceImpl(dio: mockDio);
    });
    
    group('getProducts', () {
      test('should return products when API call is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': [
              {
                'id': '1',
                'title': 'Test Product',
                'price': 99.99,
                'image_url': 'https://example.com/image.jpg',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        );
        
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);
        
        // Act
        final result = await dataSource.getProducts();
        
        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
        expect(result.first.title, 'Test Product');
      });
      
      test('should throw ServerException when API call fails', () async {
        // Arrange
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/products'),
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/products'),
              ),
            ));
        
        // Act & Assert
        expect(
          () => dataSource.getProducts(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}

class MockDio extends Mock implements Dio {}
```

### **2. Local Data Source Testing**
```dart
void main() {
  group('CatalogLocalDataSource', () {
    late CatalogLocalDataSourceImpl dataSource;
    late MockHiveInterface mockHive;
    late MockBox mockBox;
    
    setUp(() {
      mockHive = MockHiveInterface();
      mockBox = MockBox();
      dataSource = CatalogLocalDataSourceImpl(hive: mockHive);
      
      when(mockHive.openBox(any)).thenAnswer((_) async => mockBox);
    });
    
    group('cacheProducts', () {
      test('should cache products successfully', () async {
        // Arrange
        final products = [testProduct];
        when(mockBox.put(any, any)).thenAnswer((_) async {});
        
        // Act
        await dataSource.cacheProducts(products);
        
        // Assert
        verify(mockBox.put('cached_products', any));
      });
    });
    
    group('getCachedProducts', () {
      test('should return cached products when available', () async {
        // Arrange
        final cachedData = [
          {
            'id': '1',
            'title': 'Test Product',
            'price': 99.99,
          }
        ];
        when(mockBox.get('cached_products')).thenReturn(cachedData);
        
        // Act
        final result = await dataSource.getCachedProducts();
        
        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
      });
      
      test('should throw CacheException when no cached data', () async {
        // Arrange
        when(mockBox.get('cached_products')).thenReturn(null);
        
        // Act & Assert
        expect(
          () => dataSource.getCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });
    });
  });
}

class MockHiveInterface extends Mock implements HiveInterface {}
class MockBox extends Mock implements Box {}
```

---

## 🛠️ **Error Handling Testing | اختبار معالجة الأخطاء**

### **1. Error Scenarios Testing**
```dart
void main() {
  group('Error Handling', () {
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
    
    group('Network Errors', () {
      test('should return NetworkFailure when network is unavailable', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getCachedProducts())
            .thenThrow(CacheException('No cached data'));
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isError, true);
        expect(result.failure, isA<CacheFailure>());
      });
    });
    
    group('Server Errors', () {
      test('should return ServerFailure when server returns 500', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProducts(any, any, any, any, any))
            .thenThrow(ServerException('Internal server error'));
        
        // Act
        final result = await repository.getProducts();
        
        // Assert
        expect(result.isError, true);
        expect(result.failure, isA<ServerFailure>());
        expect(result.failure?.message, contains('Internal server error'));
      });
    });
    
    group('Validation Errors', () {
      test('should return ValidationFailure for invalid input', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProduct(''))
            .thenThrow(ValidationException('Invalid product ID'));
        
        // Act
        final result = await repository.getProduct('');
        
        // Assert
        expect(result.isError, true);
        expect(result.failure, isA<ValidationFailure>());
      });
    });
  });
}
```

---

## 📊 **Integration Testing | اختبار التكامل**

### **1. Repository Integration Tests**
```dart
void main() {
  group('CatalogRepository Integration Tests', () {
    late CatalogRepositoryImpl repository;
    late CatalogRemoteDataSourceImpl remoteDataSource;
    late CatalogLocalDataSourceImpl localDataSource;
    late NetworkInfoImpl networkInfo;
    
    setUpAll(() async {
      await Hive.initFlutter();
      Hive.registerAdapter(ProductAdapter());
    });
    
    setUp(() {
      final dio = Dio();
      remoteDataSource = CatalogRemoteDataSourceImpl(dio: dio);
      localDataSource = CatalogLocalDataSourceImpl(hive: Hive);
      networkInfo = NetworkInfoImpl(connectivity: Connectivity());
      
      repository = CatalogRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo,
      );
    });
    
    test('should cache and retrieve products successfully', () async {
      // This test would require a real API endpoint or mock server
      // Skip in unit tests, run in integration tests
    }, skip: true);
  });
}
```

---

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Testing Specific Criteria:**
- [ ] Repository tests with 100% coverage
- [ ] Data source tests with mock implementations
- [ ] Error handling scenario tests
- [ ] Integration tests for end-to-end flows
- [ ] Performance tests for data operations
- [ ] Offline/online scenario tests

---

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Testing Specific Pitfalls:**
- **Avoid**: Not testing error scenarios
- **Avoid**: Testing implementation details instead of behavior
- **Avoid**: Missing integration tests
- **Avoid**: Not testing offline scenarios
- **Avoid**: Hard-coded test data
- **Avoid**: Not mocking external dependencies

---

## 🔧 **Troubleshooting | استكشاف الأخطاء وإصلاحها**

### **Common Testing Issues:**

#### **1. Mock Setup Issues**
**Problem**: Mocks not working as expected
**Solution**:
- Ensure proper mock class inheritance
- Use `when()` and `verify()` correctly
- Reset mocks in `setUp()` methods

#### **2. Async Testing Issues**
**Problem**: Tests failing due to async operations
**Solution**:
- Use `await` for async operations
- Use `expectLater()` for stream testing
- Properly handle `Future` and `Stream` types

#### **3. Integration Test Issues**
**Problem**: Integration tests failing
**Solution**:
- Set up proper test environment
- Use real data sources in integration tests
- Mock only external dependencies

---

## 🔗 **Navigation | التنقل**

[← Previous: Data Sources Implementation | السابق: تنفيذ مصادر البيانات](03_Data_Sources_Implementation.md)
[Next: Troubleshooting Guide | التالي: دليل استكشاف الأخطاء →](03_Troubleshooting_Guide.md)
[🏠 Home | الرئيسية](../../../index.html)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Testing  
**Status | الحالة**: ✅ Production Ready
