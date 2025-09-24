# Best Practices | أفضل الممارسات
## Architecture Best Practices & Guidelines | أفضل ممارسات وإرشادات المعمارية

> **Shared Best Practices | أفضل الممارسات المشتركة** - Applied across all Architecture components

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Language Support**: Arabic (RTL) + English (LTR)  
**Quality Level**: Enterprise-grade, Production-ready

---

## 🎯 **Best Practices Overview | نظرة عامة على أفضل الممارسات**

### **Core Principles | المبادئ الأساسية**
1. **Separation of Concerns** - Each layer has a single responsibility
2. **Dependency Inversion** - Depend on abstractions, not concretions
3. **Single Responsibility** - Each class/module has one reason to change
4. **Open/Closed Principle** - Open for extension, closed for modification
5. **DRY (Don't Repeat Yourself)** - Avoid code duplication

---

## 🏗️ **Clean Architecture Best Practices | أفضل ممارسات المعمارية النظيفة**

### **1. Layer Separation | فصل الطبقات**

#### **✅ Do:**
```dart
// Domain layer - Pure business logic
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

// Data layer - Implements domain interface
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;
  
  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;
  
  @override
  Future<List<Product>> getProducts() async {
    // Implementation details
  }
}
```

#### **❌ Don't:**
```dart
// Violating layer separation
class ProductUseCase {
  final ApiClient _apiClient; // Data layer dependency in domain
  
  ProductUseCase({required ApiClient apiClient}) : _apiClient = apiClient;
}
```

### **2. Dependency Injection | حقن التبعية**

#### **✅ Do:**
```dart
// Using GetIt for dependency injection
final getIt = GetIt.instance;

void setupDependencies() {
  // Data sources
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: getIt()),
  );
}
```

#### **❌ Don't:**
```dart
// Hard-coded dependencies
class ProductService {
  final ApiClient _apiClient = ApiClient(); // Hard-coded
  final Database _database = Database(); // Hard-coded
}
```

---

## 🔄 **State Management Best Practices | أفضل ممارسات إدارة الحالة**

### **1. Riverpod State Management | إدارة الحالة مع Riverpod**

#### **✅ Do:**
```dart
// Provider for data
@riverpod
class ProductNotifier extends _$ProductNotifier {
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
  
  Future<void> addProduct(Product product) async {
    state = await AsyncValue.guard(() async {
      await ref.read(productRepositoryProvider).addProduct(product);
      return await ref.read(productRepositoryProvider).getProducts();
    });
  }
}

// Provider for repository
@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.read(productRemoteDataSourceProvider),
    localDataSource: ref.read(productLocalDataSourceProvider),
  );
}
```

#### **❌ Don't:**
```dart
// Global state without proper management
class GlobalProductState {
  static List<Product> products = [];
  static bool isLoading = false;
  
  static void setProducts(List<Product> newProducts) {
    products = newProducts; // Not reactive, no error handling
  }
}
```

### **2. BLoC State Management | إدارة الحالة مع BLoC**

#### **✅ Do:**
```dart
// BLoC with proper state management
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  
  ProductBloc({required GetProductsUseCase getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }
  
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await _getProductsUseCase();
    
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
```

---

## 🛡️ **Error Handling Best Practices | أفضل ممارسات معالجة الأخطاء**

### **1. Result Pattern Implementation | تنفيذ نمط النتيجة**

#### **✅ Do:**
```dart
// Result pattern for error handling
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppFailure failure) = Failure<T>;
}

// Usage in repositories
Future<Result<List<Product>>> getProducts() async {
  try {
    final products = await _dataSource.getProducts();
    return Result.success(products);
  } catch (e) {
    return Result.failure(AppFailure.server(e.toString()));
  }
}

// Usage in use cases
Future<Result<List<Product>>> execute() async {
  final result = await _repository.getProducts();
  return result.fold(
    (failure) => Result.failure(failure),
    (products) => Result.success(products),
  );
}
```

#### **❌ Don't:**
```dart
// Throwing exceptions to UI layer
Future<List<Product>> getProducts() async {
  try {
    return await _dataSource.getProducts();
  } catch (e) {
    throw Exception('Failed to load products'); // Don't throw to UI
  }
}
```

### **2. Error Recovery | استعادة الأخطاء**

#### **✅ Do:**
```dart
// Error recovery with retry logic
Future<Result<T>> executeWithRetry<T>(
  Future<Result<T>> Function() operation,
  {int maxRetries = 3}
) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final result = await operation();
    
    if (result.isSuccess) {
      return result;
    }
    
    if (attempt < maxRetries) {
      await Future.delayed(Duration(seconds: attempt));
    }
  }
  
  return Result.failure(AppFailure.network());
}
```

---

## 🎨 **UI/UX Best Practices | أفضل ممارسات واجهة المستخدم**

### **1. RTL Support | دعم النص من اليمين لليسار**

#### **✅ Do:**
```dart
// RTL-aware layout
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

### **2. Accessibility | إمكانية الوصول**

#### **✅ Do:**
```dart
// Accessible widget
class AccessibleProductButton extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  
  const AccessibleProductButton({
    required this.product,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Add ${product.title} to cart for ${product.price} SAR',
      hint: 'Double tap to add to cart',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Text(product.title),
        ),
      ),
    );
  }
}
```

---

## 🚀 **Performance Best Practices | أفضل ممارسات الأداء**

### **1. Efficient Data Loading | تحميل البيانات بكفاءة**

#### **✅ Do:**
```dart
// Lazy loading with pagination
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productNotifierProvider);
    
    return productsAsync.when(
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          // Load more when reaching end
          if (index == products.length - 1) {
            ref.read(productNotifierProvider.notifier).loadMore();
          }
          return ProductCard(product: products[index]);
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### **2. Image Optimization | تحسين الصور**

#### **✅ Do:**
```dart
// Optimized image loading
class OptimizedProductImage extends StatelessWidget {
  final String imageUrl;
  
  const OptimizedProductImage({required this.imageUrl});
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      ),
      fit: BoxFit.cover,
      memCacheWidth: 200, // Optimize memory usage
      memCacheHeight: 200,
    );
  }
}
```

---

## 🔒 **Security Best Practices | أفضل ممارسات الأمان**

### **1. Data Validation | التحقق من البيانات**

#### **✅ Do:**
```dart
// Input validation
class ProductValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Title is required';
    }
    if (title.length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (title.length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }
  
  static String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      return 'Price is required';
    }
    final parsedPrice = double.tryParse(price);
    if (parsedPrice == null || parsedPrice <= 0) {
      return 'Price must be a positive number';
    }
    return null;
  }
}
```

### **2. Secure Storage | التخزين الآمن**

#### **✅ Do:**
```dart
// Secure storage for sensitive data
class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

---

## 🔗 **Navigation | التنقل**

[🏠 Home | الرئيسية](../../index.html)

### **Related Files | الملفات ذات الصلة**
- [Quality Standards | معايير الجودة](Quality_Standards.md)
- [Testing Strategy | استراتيجية الاختبار](Testing_Strategy.md)
- [Troubleshooting Guide | دليل استكشاف الأخطاء](Troubleshooting_Guide.md)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Shared Best Practices  
**Status | الحالة**: ✅ Production Ready
