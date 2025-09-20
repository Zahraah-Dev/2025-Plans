# 2. إدارة الحالة وحقن الاعتماديات
## 2. State Management & Dependency Injection

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

---

## 🎯 **Objective | الهدف**
Implement robust state management and dependency injection for predictable, testable, and maintainable Flutter application state.

## 📋 **Rule | القاعدة**
**Arabic**: استخدم Riverpod (أو BLoC—اختر واحدًا وثبّته) + DI عبر Providers  
**English**: Use Riverpod (or BLoC—choose one and stick with it) + DI through Providers

## 💡 **Benefits | الفوائد**
- **Smart Rebuilds | إعادة بناء ذكية**: Only rebuild widgets that need updates, improving performance
- **Easy Testing | اختبار سهل**: State can be tested independently with proper mocking
- **Avoid Singletons | تجنب Singleton**: Better dependency management and testability
- **Performance | الأداء**: Reduced unnecessary rebuilds and memory usage
- **Predictable State | حالة متوقعة**: Clear state flow and easier debugging
- **Team Collaboration | تعاون الفريق**: Consistent patterns across the team

## 🛠️ **Implementation | التطبيق**
- **Use in**: All features requiring state management and data access
- **How to implement**:
  - Set up ProviderScope in main.dart
  - Create StateNotifier for each feature
  - Use Provider for repository interfaces
  - Implement proper disposal and cleanup
  - Use Consumer/ConsumerWidget for UI updates
- **Result**: Predictable state management with better performance and testability

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **State Management Specific Criteria:**
- [ ] One state management solution across entire project
- [ ] No business logic in Widgets
- [ ] Proper resource disposal and cleanup
- [ ] Easy to test state changes and side effects
- [ ] Clear separation between UI and business logic
- [ ] Consistent patterns across all features

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **State Management Specific Pitfalls:**
- **Avoid**: Mixed state management patterns in same project
- **Avoid**: Memory leaks from improper disposal
- **Avoid**: Business logic in UI components
- **Avoid**: No disposal of resources and streams
- **Avoid**: Direct state mutation without proper patterns
- **Avoid**: Over-engineering simple state requirements

---



## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **State Management & DI Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **State Inconsistency** | High | Medium | Immutable state, proper state updates, testing |
| **Memory Leaks** | High | Medium | Proper disposal, weak references, lifecycle management |
| **Provider Overuse** | Medium | High | Provider scoping, selective watching, performance monitoring |
| **Tight Coupling** | Medium | High | Interface segregation, dependency injection |
| **Testing Complexity** | High | Medium | Mock providers, test utilities, isolated testing |
| **Performance Issues** | Medium | Low | Selective rebuilds, provider optimization, state normalization |

## 📊 **Implementation Priority | أولوية التنفيذ**

> **Reference**: See [Implementation Priority Template](../00-Templates/02_Implementation_Priority_Template.md) for standard phases.

### **State Management & DI Specific Priorities:**
- **Phase 1: Foundation (Must Have)**
  - [ ] Riverpod setup and configuration
  - [ ] StateNotifier implementation for features
  - [ ] Provider-based dependency injection
  - [ ] Basic state management patterns
- **Phase 2: Enhancement (Should Have)**
  - [ ] Advanced provider patterns (FutureProvider, StreamProvider)
  - [ ] State persistence and restoration
  - [ ] Provider scoping and optimization
- [ ] Comprehensive testing setup

### **Phase 3: Optimization (Could Have)**
- [ ] Performance monitoring and optimization
- [ ] Advanced state management patterns
- [ ] State management documentation
- [ ] Provider debugging tools

## 📋 **Architecture Decision Record (ADR)**

### **ADR-001: Clean Architecture Pattern**
- **Status**: Accepted
- **Date**: 2025-01-27
- **Context**: Need for maintainable, testable architecture
- **Decision**: Implement Clean Architecture with 4 layers
- **Consequences**: 
  - ✅ Better testability
  - ✅ Clear separation of concerns
  - ⚠️ More initial setup complexity
  - ⚠️ Learning curve for team

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **State Management & DI Specific Quality Gates:**
- [ ] Riverpod properly configured and working
- [ ] No business logic in UI components
- [ ] Proper resource disposal and cleanup
- [ ] State changes are predictable and testable
- [ ] Provider dependencies are properly managed
- [ ] No memory leaks from providers or state

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Success Metrics Template](../00-Templates/04_Success_Metrics_Template.md) for standard metrics.

### **State Management & DI Specific Metrics:**
- **State Consistency**: 100% predictable state updates
- **Memory Management**: Zero memory leaks from state
- **Provider Performance**: <10ms provider resolution time
- **Testability**: 100% of state logic covered by tests
- **Developer Experience**: Easy to understand and maintain state


## 🚀 **التطبيق | Implementation**

### **1. ProviderScope في main.dart**
```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### **2. StateNotifier لكل منطق ميزة**
```dart
class CartController extends StateNotifier<CartState> {
  CartController(this._cartRepo) : super(CartState.initial());
  
  final CartRepository _cartRepo;
  
  Future<void> addItem(Product product) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _cartRepo.addItem(product);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (cart) => state = state.copyWith(
        isLoading: false,
        cart: cart,
      ),
    );
  }
  
  Future<void> removeItem(String productId) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _cartRepo.removeItem(productId);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (cart) => state = state.copyWith(
        isLoading: false,
        cart: cart,
      ),
    );
  }
}
```

### **3. Provider لواجهات Repos**
```dart
// Repository Provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    remoteDataSource: ref.watch(cartRemoteDataSourceProvider),
    localDataSource: ref.watch(cartLocalDataSourceProvider),
  );
});

// Data Source Providers
final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
  );
});

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  return CartLocalDataSourceImpl(
    hive: ref.watch(hiveProvider),
  );
});

// Controller Provider
final cartControllerProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController(ref.watch(cartRepositoryProvider));
});
```

---

## 🏗️ **أنماط State Management**

### **1. StateNotifier Pattern (مُوصى به)**
```dart
// State Class
@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    String? errorMessage,
  }) = _CartState;
}

// Controller
class CartController extends StateNotifier<CartState> {
  CartController(this._cartRepo) : super(const CartState());
  
  final CartRepository _cartRepo;
  
  Future<void> addItem(Product product) async {
    // Implementation
  }
}
```

### **2. FutureProvider للبيانات غير المتغيرة**
```dart
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getProducts();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});
```

### **3. StreamProvider للبيانات المتغيرة**
```dart
final cartStreamProvider = StreamProvider<Cart>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return repository.watchCart();
});
```

---

## 🔧 **Dependency Injection Patterns**

### **1. Constructor Injection**
```dart
class ProductService {
  final ProductRepository _repository;
  final AnalyticsService _analytics;
  
  ProductService({
    required ProductRepository repository,
    required AnalyticsService analytics,
  }) : _repository = repository,
       _analytics = analytics;
}
```

### **2. Provider-based DI**
```dart
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(
    repository: ref.watch(productRepositoryProvider),
    analytics: ref.watch(analyticsServiceProvider),
  );
});
```

### **3. Scoped Providers**
```dart
// Global scope
final globalConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.production();
});

// Feature scope
final catalogFeatureProvider = Provider<CatalogFeature>((ref) {
  return CatalogFeature(
    config: ref.watch(globalConfigProvider),
  );
});
```

---

## 🧪 **Testing State Management**

### **1. Unit Testing Controllers**
```dart
void main() {
  group('CartController', () {
    late CartController controller;
    late MockCartRepository mockRepository;
    
    setUp(() {
      mockRepository = MockCartRepository();
      controller = CartController(mockRepository);
    });
    
    test('should add item to cart', () async {
      // Arrange
      final product = Product(id: '1', name: 'Test', price: 100);
      when(mockRepository.addItem(any))
          .thenAnswer((_) async => Result.ok(Cart(items: [CartItem.fromProduct(product)])));
      
      // Act
      await controller.addItem(product);
      
      // Assert
      expect(controller.state.cart.items.length, 1);
      expect(controller.state.cart.items.first.productId, '1');
    });
  });
}
```

### **2. Widget Testing with Providers**
```dart
void main() {
  group('CartPage', () {
    testWidgets('should display cart items', (tester) async {
      // Arrange
      final mockCart = Cart(items: [
        CartItem(productId: '1', name: 'Test Product', price: 100, quantity: 1),
      ]);
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartControllerProvider.overrideWith((ref) => MockCartController(mockCart)),
          ],
          child: MaterialApp(home: CartPage()),
        ),
      );
      
      // Act
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('100 YER'), findsOneWidget);
    });
  });
}
```

---

## 🔧 **Troubleshooting | استكشاف الأخطاء وإصلاحها**

### **Common State Management Issues:**

#### **1. State Inconsistency**
**Problem**: UI shows different state than expected
**Solution**:
- Use immutable state with freezed
- Implement proper state updates
- Add state validation and testing

#### **2. Memory Leaks**
**Problem**: App memory usage keeps growing
**Solution**:
- Properly dispose of controllers and streams
- Use weak references where appropriate
- Implement proper lifecycle management

#### **3. Provider Overuse**
**Problem**: Too many providers causing performance issues
**Solution**:
- Use provider scoping appropriately
- Implement selective watching
- Monitor provider performance

#### **4. State Not Updating**
**Problem**: UI doesn't reflect state changes
**Solution**:
- Check provider dependencies
- Ensure proper state mutation
- Verify widget is watching the right provider

## 📊 **Best Practices**

### **1. State Design**
- [ ] استخدم immutable state
- [ ] اجعل state بسيط ومركز
- [ ] استخدم freezed للـ state classes
- [ ] تجنب nested state معقد

### **2. Provider Organization**
- [ ] نظم الـ providers حسب الطبقة
- [ ] استخدم أسماء واضحة ومتسقة
- [ ] اجعل الـ providers قابلة للاختبار
- [ ] استخدم scoping عند الحاجة

### **3. Error Handling**
- [ ] تعامل مع الأخطاء في الـ controllers
- [ ] استخدم Result pattern للعمليات
- [ ] اعرض رسائل خطأ واضحة للمستخدم
- [ ] سجل الأخطاء للتحليل

---

## 🔗 **الروابط ذات الصلة | Related Links**

- [نظرة عامة على المعمارية النظيفة](01_Architecture_Overview.md)
- [طبقة البيانات ومعالجة الأخطاء](03_Data_Layer_Error_Handling.md)
- [طبقة المجال](04_Domain_Layer.md)
- [استراتيجية الاختبار](08_Testing_Strategy.md)

---

## 📚 **المراجع | References**

- [Riverpod Documentation](https://riverpod.dev/)
- [State Management in Flutter](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Dependency Injection in Flutter](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)

---

**🔴 ENHANCEMENT**: محتوى مأخوذ من الوثائق الأصلية  
**🔵 SUGGESTION**: اقتراحات مبنية على الخبرة التقنية

---

## 🔗 **Navigation | التنقل**

[← Previous: Architecture Overview | السابق: نظرة عامة على المعمارية](01_Architecture_Overview.md)
[Next: Data Layer Error Handling | التالي: معالجة أخطاء طبقة البيانات →](03_Data_Layer_Error_Handling.md)
[🏠 Home | الرئيسية](../../index.html)

---
