# Troubleshooting Guide | دليل استكشاف الأخطاء
## Common Issues & Solutions for Architecture | المشاكل الشائعة والحلول للمعمارية

> **Shared Troubleshooting Guide | دليل استكشاف الأخطاء المشترك** - Applied across all Architecture components

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Quality Level**: Enterprise-grade, Production-ready

---

## 🎯 **Troubleshooting Overview | نظرة عامة على استكشاف الأخطاء**

### **Debugging Strategy | استراتيجية التصحيح**
1. **Identify the Problem** - Understand what's not working
2. **Reproduce the Issue** - Create consistent steps to reproduce
3. **Isolate the Cause** - Narrow down to specific component/layer
4. **Apply Solution** - Implement fix and verify
5. **Document Solution** - Update documentation for future reference

---

## 🔧 **Common Architecture Issues | مشاكل المعمارية الشائعة**

### **1. Clean Architecture Violations | انتهاكات المعمارية النظيفة**

#### **Problem**: Dependencies pointing in wrong direction
**Symptoms | الأعراض:**
- Domain layer importing from data layer
- Circular dependencies between layers
- UI layer directly accessing data sources

**Solution | الحل:**
```dart
// ❌ Wrong - Domain importing from Data
import '../data/models/product_model.dart';

// ✅ Correct - Domain defines its own entities
class Product {
  final String id;
  final String title;
  final double price;
  // ...
}

// ✅ Correct - Data layer implements domain interfaces
class ProductModel extends Product {
  // Implementation details
}
```

#### **Problem**: Missing dependency injection
**Symptoms | الأعراض:**
- Hard-coded dependencies in constructors
- Difficult to test components
- Tight coupling between classes

**Solution | الحل:**
```dart
// ❌ Wrong - Hard-coded dependency
class ProductService {
  final ApiClient _apiClient = ApiClient(); // Hard-coded
}

// ✅ Correct - Injected dependency
class ProductService {
  final ApiClient _apiClient;
  
  ProductService({required ApiClient apiClient}) 
      : _apiClient = apiClient;
}
```

### **2. State Management Issues | مشاكل إدارة الحالة**

#### **Problem**: State not updating in UI
**Symptoms | الأعراض:**
- UI shows stale data
- Changes not reflected in interface
- Inconsistent state across screens

**Solution | الحل:**
```dart
// ✅ Correct - Using Riverpod with proper state updates
@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  Future<List<Product>> build() async {
    return await _repository.getProducts();
  }
  
  Future<void> refreshProducts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getProducts());
  }
}
```

#### **Problem**: Memory leaks in state management
**Symptoms | الأعراض:**
- App memory usage increasing over time
- Performance degradation
- App crashes due to memory pressure

**Solution | الحل:**
```dart
// ✅ Correct - Proper disposal of resources
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final StreamSubscription _subscription;
  
  ProductBloc() : super(ProductInitial()) {
    _subscription = _repository.productsStream.listen(
      (products) => add(ProductsUpdated(products)),
    );
  }
  
  @override
  Future<void> close() {
    _subscription.cancel(); // Proper cleanup
    return super.close();
  }
}
```

### **3. Error Handling Issues | مشاكل معالجة الأخطاء**

#### **Problem**: Exceptions not handled properly
**Symptoms | الأعراض:**
- App crashes with unhandled exceptions
- Poor user experience with technical error messages
- Inconsistent error handling across app

**Solution | الحل:**
```dart
// ✅ Correct - Using Result pattern for error handling
Future<Result<List<Product>>> getProducts() async {
  try {
    final products = await _dataSource.getProducts();
    return Result.ok(products);
  } catch (e) {
    return Result.err(AppFailure.server(e.toString()));
  }
}

// ✅ Correct - Handling Result in UI
final result = await repository.getProducts();
result.when(
  ok: (products) => _displayProducts(products),
  err: (failure) => _showError(failure.message),
);
```

### **4. Performance Issues | مشاكل الأداء**

#### **Problem**: Slow screen transitions
**Symptoms | الأعراض:**
- UI freezes during navigation
- Long loading times
- Poor user experience

**Solution | الحل:**
```dart
// ✅ Correct - Lazy loading and pagination
Future<List<Product>> getProducts({
  int page = 1,
  int limit = 20,
}) async {
  return await _dataSource.getProducts(
    page: page,
    limit: limit,
  );
}

// ✅ Correct - Caching for better performance
@riverpod
class CachedProductNotifier extends _$CachedProductNotifier {
  @override
  Future<List<Product>> build() async {
    // Try cache first, then network
    final cachedProducts = await _cache.getProducts();
    if (cachedProducts.isNotEmpty) {
      return cachedProducts;
    }
    
    final networkProducts = await _repository.getProducts();
    await _cache.saveProducts(networkProducts);
    return networkProducts;
  }
}
```

---

## 🐛 **Debugging Tools & Techniques | أدوات وتقنيات التصحيح**

### **1. Logging Strategy | استراتيجية التسجيل**
```dart
class Logger {
  static void logInfo(String message, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      print('INFO: $message ${data ?? ''}');
    }
  }
  
  static void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('ERROR: $message');
      print('Error: $error');
      print('StackTrace: $stackTrace');
    }
  }
}

// Usage in repositories
Future<Result<List<Product>>> getProducts() async {
  Logger.logInfo('Fetching products');
  try {
    final products = await _dataSource.getProducts();
    Logger.logInfo('Products fetched successfully', data: {'count': products.length});
    return Result.ok(products);
  } catch (e, stackTrace) {
    Logger.logError('Failed to fetch products', error: e, stackTrace: stackTrace);
    return Result.err(AppFailure.server(e.toString()));
  }
}
```

### **2. Performance Monitoring | مراقبة الأداء**
```dart
class PerformanceMonitor {
  static Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      Logger.logInfo('Performance: $operationName took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      Logger.logError('Performance: $operationName failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }
}
```

### **3. State Inspection | فحص الحالة**
```dart
// Debug widget for inspecting state
class StateInspector extends StatelessWidget {
  final Widget child;
  
  const StateInspector({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return kDebugMode
        ? Stack(
            children: [
              child,
              Positioned(
                top: 50,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final products = ref.watch(productNotifierProvider);
                      return Text(
                        'Products: ${products.value?.length ?? 0}',
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        : child;
  }
}
```

---

## 🚨 **Emergency Procedures | الإجراءات الطارئة**

### **1. App Crashes | تعطل التطبيق**
1. **Check logs** for error messages
2. **Identify crash location** using stack trace
3. **Reproduce issue** in development environment
4. **Apply hotfix** if critical
5. **Deploy update** following release process

### **2. Performance Issues | مشاكل الأداء**
1. **Monitor metrics** (CPU, memory, network)
2. **Identify bottlenecks** using profiling tools
3. **Optimize critical paths** first
4. **Test performance improvements**
5. **Deploy optimization** update

### **3. Data Issues | مشاكل البيانات**
1. **Verify data integrity** in database
2. **Check API responses** for errors
3. **Validate data models** and parsing
4. **Implement data validation** if missing
5. **Fix data corruption** issues

---

## 📊 **Monitoring & Alerting | المراقبة والتنبيه**

### **Key Metrics to Monitor | المقاييس الرئيسية للمراقبة**
- **Crash Rate**: <1% of sessions
- **Performance**: <500ms average response time
- **Error Rate**: <5% of operations
- **User Engagement**: Track key user actions
- **API Health**: Monitor external service status

### **Alerting Thresholds | عتبات التنبيه**
- **Critical**: Crash rate >5% or performance >2s
- **Warning**: Error rate >10% or performance >1s
- **Info**: New feature adoption rates

---

## 🔗 **Navigation | التنقل**

[🏠 Home | الرئيسية](../../index.html)

### **Related Files | الملفات ذات الصلة**
- [Quality Standards | معايير الجودة](Quality_Standards.md)
- [Testing Strategy | استراتيجية الاختبار](Testing_Strategy.md)
- [Best Practices | أفضل الممارسات](Best_Practices.md)
- [Data Layer Error Handling | معالجة أخطاء طبقة البيانات](03_Data_Layer_Error_Handling.md)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Shared Troubleshooting Guide  
**Status | الحالة**: ✅ Production Ready
