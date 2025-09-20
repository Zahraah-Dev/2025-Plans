# 5. إدارة الحالة والواجهة
## 5. State Management & UI

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement comprehensive state management and UI components using Riverpod with proper separation of concerns and reactive programming.

## 📋 **Rule | القاعدة**
**Arabic**: استخدم Riverpod لإدارة الحالة + StateNotifier للتحكم + Consumer للواجهة  
**English**: Use Riverpod for state management + StateNotifier for control + Consumer for UI

## 💡 **Benefits | الفوائد**
- **Reactive UI | واجهة تفاعلية**: Automatic UI updates when state changes
- **Separation of Concerns | فصل الاهتمامات**: Clear separation between UI and business logic
- **Testability | قابلية الاختبار**: Easy to test state management logic
- **Performance | الأداء**: Efficient state updates and rebuilds
- **Maintainability | سهولة الصيانة**: Clean, organized state management
- **Scalability | قابلية التوسع**: Easy to add new features and states

---

## 🔄 **State Management | إدارة الحالة**

### **1. StateNotifier Pattern**
```dart
// lib/features/catalog/presentation/controllers/catalog_controller.dart
class CatalogController extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProductList _getProductList;
  final SearchProducts _searchProducts;
  
  CatalogController(
    this._getProductList,
    this._searchProducts,
  ) : super(const AsyncValue.loading());
  
  Future<void> loadProducts({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _getProductList(
      category: category,
      page: page,
      limit: limit,
    );
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (products) => state = AsyncValue.data(products),
    );
  }
  
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadProducts();
      return;
    }
    
    state = const AsyncValue.loading();
    
    final result = await _searchProducts(query);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (products) => state = AsyncValue.data(products),
    );
  }
  
  void clearSearch() {
    loadProducts();
  }
}

// Provider definition
final catalogControllerProvider = StateNotifierProvider<CatalogController, AsyncValue<List<Product>>>(
  (ref) => CatalogController(
    ref.read(getProductListProvider),
    ref.read(searchProductsProvider),
  ),
);
```

### **2. AsyncNotifier Pattern**
```dart
// lib/features/cart/presentation/controllers/cart_controller.dart
class CartController extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    final userId = ref.read(authControllerProvider).value?.id;
    if (userId == null) return [];
    
    final result = await ref.read(getCartItemsProvider(userId).future);
    return result.fold(
      (failure) => throw failure,
      (items) => items,
    );
  }
  
  Future<void> addToCart({
    required String productId,
    required int quantity,
    Map<String, dynamic>? options,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(addToCartProvider({
      'productId': productId,
      'quantity': quantity,
      'options': options ?? {},
    }).future);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (cartItem) => state = AsyncValue.data([...state.value!, cartItem]),
    );
  }
  
  Future<void> removeFromCart(String cartItemId) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(removeFromCartProvider(cartItemId).future);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(
        state.value!.where((item) => item.id != cartItemId).toList(),
      ),
    );
  }
}

// Provider definition
final cartControllerProvider = AsyncNotifierProvider<CartController, List<CartItem>>(
  () => CartController(),
);
```

---

## 🎨 **UI Components | مكونات الواجهة**

### **1. Consumer Widget Pattern**
```dart
// lib/features/catalog/presentation/pages/catalog_page.dart
class CatalogPage extends ConsumerWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        actions: [
          IconButton(
            onPressed: () => _showSearch(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: catalogState.when(
        data: (products) => _buildProductGrid(products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(context, error),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () => _navigateToProduct(context, products[index]),
          onAddToCart: () => _addToCart(context, products[index]),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('حدث خطأ: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(catalogControllerProvider.notifier).loadProducts(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
```

### **2. Stateful Consumer Widget**
```dart
// lib/features/cart/presentation/pages/cart_page.dart
class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    // Load cart items when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartControllerProvider.notifier).loadCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        actions: [
          if (cartState.value?.isNotEmpty == true)
            TextButton(
              onPressed: () => _clearCart(),
              child: const Text('مسح الكل'),
            ),
        ],
      ),
      body: cartState.when(
        data: (items) => items.isEmpty
            ? _buildEmptyCart()
            : _buildCartItems(items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(context, error),
      ),
      bottomNavigationBar: cartState.value?.isNotEmpty == true
          ? _buildCheckoutButton()
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('سلة التسوق فارغة'),
          SizedBox(height: 8),
          Text('أضف بعض المنتجات لتبدأ التسوق'),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          item: items[index],
          onQuantityChanged: (quantity) => _updateQuantity(items[index], quantity),
          onRemove: () => _removeItem(items[index]),
        );
      },
    );
  }
}
```

---

## 🔄 **State Synchronization | مزامنة الحالة**

### **1. Cross-Feature State Updates**
```dart
// lib/features/cart/presentation/controllers/cart_controller.dart
class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);
  
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    // Add to cart logic
    final result = await _addToCartUseCase(productId, quantity);
    
    result.fold(
      (failure) => _handleError(failure),
      (cartItem) {
        state = [...state, cartItem];
        // Notify other features
        ref.read(cartCountProvider.notifier).update((count) => count + 1);
        ref.read(cartTotalProvider.notifier).update((total) => total + cartItem.totalPrice);
      },
    );
  }
}
```

### **2. Global State Management**
```dart
// lib/core/state/app_state.dart
class AppState {
  final User? user;
  final bool isAuthenticated;
  final String? currentRoute;
  final Map<String, dynamic> preferences;
  
  const AppState({
    this.user,
    this.isAuthenticated = false,
    this.currentRoute,
    this.preferences = const {},
  });
  
  AppState copyWith({
    User? user,
    bool? isAuthenticated,
    String? currentRoute,
    Map<String, dynamic>? preferences,
  }) {
    return AppState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentRoute: currentRoute ?? this.currentRoute,
      preferences: preferences ?? this.preferences,
    );
  }
}

// Global app state provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Navigation & Routing | السابق: التوجيه والتوجيه](05_Navigation_Routing.md)
[Next: Deep Linking & Accessibility | التالي: الروابط العميقة وإمكانية الوصول →](05_Deep_Linking_Accessibility.md)
[🏠 Home | الرئيسية](../../../index.html)

---
