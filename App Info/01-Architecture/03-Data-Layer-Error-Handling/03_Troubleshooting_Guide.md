# 3. Data Layer Troubleshooting Guide | دليل استكشاف أخطاء طبقة البيانات
## Common Issues & Solutions | المشاكل الشائعة والحلول

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

**Target Application**: زهراء (Zahraah) - Women's Fashion E-commerce App  
**Platform**: Flutter (iOS + Android)  
**Architecture**: Clean Architecture + Feature-first structure  
**Quality Level**: Enterprise-grade, Production-ready

## 🎯 **Objective | الهدف**
Provide comprehensive troubleshooting guide for common data layer issues, debugging strategies, and best practices for maintaining robust data operations.

---

## 🔧 **Common Data Layer Issues | مشاكل طبقة البيانات الشائعة**

### **1. Data Inconsistency | عدم اتساق البيانات**
**Problem**: Data doesn't match between local and remote sources

**Symptoms | الأعراض:**
- Stale data displayed to users
- Sync conflicts between local and remote
- Inconsistent state across app

**Solution | الحل:**
```dart
// Implement proper data validation
class DataValidator {
  static bool isValidProduct(Product product) {
    return product.id.isNotEmpty && 
           product.title.isNotEmpty && 
           product.price > 0;
  }
  
  static List<Product> validateProducts(List<Product> products) {
    return products.where((product) => isValidProduct(product)).toList();
  }
}

// Use transaction management
class TransactionManager {
  static Future<void> syncData() async {
    final batch = Hive.batch();
    try {
      // Perform atomic operations
      await _syncProducts(batch);
      await _syncUsers(batch);
      await batch.commit();
    } catch (e) {
      await batch.rollback();
      throw SyncException('Failed to sync data');
    }
  }
}

// Implement conflict resolution
class ConflictResolver {
  static Product resolveConflict(Product local, Product remote) {
    // Use timestamp-based resolution
    if (remote.updatedAt?.isAfter(local.updatedAt ?? DateTime(0)) == true) {
      return remote;
    }
    return local;
  }
}
```

### **2. Network Failures | فشل الشبكة**
**Problem**: API calls fail frequently or timeout

**Symptoms | الأعراض:**
- Slow or failed API responses
- Timeout errors
- Inconsistent network behavior

**Solution | الحل:**
```dart
// Implement retry mechanism with exponential backoff
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < maxRetries) {
        final delay = Duration(
          milliseconds: baseDelay.inMilliseconds * math.pow(2, retryCount).toInt(),
        );
        
        await Future.delayed(delay);
        
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Continue with retry logic
        }
      }
    }
    
    handler.next(err);
  }
  
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}

// Implement offline support
class OfflineManager {
  static Future<Result<T>> handleOfflineOperation<T>(
    Future<T> Function() onlineOperation,
    Future<T> Function() offlineOperation,
  ) async {
    final networkInfo = GetIt.instance<NetworkInfo>();
    
    if (await networkInfo.isConnected) {
      try {
        final result = await onlineOperation();
        return Result.ok(result);
      } catch (e) {
        // Fallback to offline operation
        try {
          final result = await offlineOperation();
          return Result.ok(result);
        } catch (offlineError) {
          return Result.err(AppFailure.network());
        }
      }
    } else {
      try {
        final result = await offlineOperation();
        return Result.ok(result);
      } catch (e) {
        return Result.err(AppFailure.network());
      }
    }
  }
}
```

### **3. Error Propagation | انتشار الأخطاء**
**Problem**: Exceptions thrown to UI layer

**Symptoms | الأعراض:**
- App crashes due to unhandled exceptions
- Poor error messages for users
- Inconsistent error handling

**Solution | الحل:**
```dart
// Use Result pattern consistently
class ErrorMapper {
  static AppFailure mapException(Exception exception) {
    if (exception is DioException) {
      return _mapDioException(exception);
    } else if (exception is CacheException) {
      return AppFailure.cache();
    } else if (exception is ValidationException) {
      return AppFailure.validation(exception.message);
    } else {
      return AppFailure.unknown(exception.toString());
    }
  }
  
  static AppFailure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return AppFailure.timeout();
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        switch (statusCode) {
          case 401:
            return AppFailure.unauthorized();
          case 403:
            return AppFailure.forbidden();
          case 404:
            return AppFailure.notFound();
          default:
            return AppFailure.server('Server error: $statusCode');
        }
      default:
        return AppFailure.network();
    }
  }
}

// Implement global error handler
class GlobalErrorHandler {
  static void handleError(AppFailure failure) {
    // Log error for debugging
    Logger.error('Data layer error: ${failure.message}');
    
    // Show user-friendly message
    final message = failure.message;
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
```

### **4. Cache Issues | مشاكل التخزين المؤقت**
**Problem**: Stale or corrupted cached data

**Symptoms | الأعراض:**
- Outdated information displayed
- Cache corruption errors
- Performance issues

**Solution | الحل:**
```dart
// Implement proper cache invalidation
class CacheManager {
  static const Duration defaultTTL = Duration(hours: 1);
  
  static Future<void> invalidateCache(String key) async {
    final box = await Hive.openBox('cache');
    await box.delete(key);
  }
  
  static Future<void> invalidateExpiredCache() async {
    final box = await Hive.openBox('cache');
    final keys = box.keys.toList();
    
    for (final key in keys) {
      final cacheData = box.get(key);
      if (cacheData is Map && cacheData.containsKey('timestamp')) {
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
          cacheData['timestamp'],
        );
        
        if (DateTime.now().difference(timestamp) > defaultTTL) {
          await box.delete(key);
        }
      }
    }
  }
  
  static Future<T?> getCachedData<T>(String key) async {
    final box = await Hive.openBox('cache');
    final cacheData = box.get(key);
    
    if (cacheData != null && cacheData is Map) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        cacheData['timestamp'],
      );
      
      if (DateTime.now().difference(timestamp) < defaultTTL) {
        return cacheData['data'] as T?;
      } else {
        await box.delete(key);
      }
    }
    
    return null;
  }
  
  static Future<void> cacheData<T>(String key, T data) async {
    final box = await Hive.openBox('cache');
    await box.put(key, {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
```

---

## 🐛 **Debugging Strategies | استراتيجيات التصحيح**

### **1. Logging Strategy | استراتيجية التسجيل**
```dart
class DataLayerLogger {
  static void logDataOperation(String operation, Map<String, dynamic> data) {
    Logger.info('Data Operation: $operation', {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'platform': Platform.operatingSystem,
    });
  }
  
  static void logError(String operation, dynamic error) {
    Logger.error('Data Operation Error: $operation', {
      'error': error.toString(),
      'stackTrace': StackTrace.current.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static void logPerformance(String operation, Duration duration) {
    Logger.info('Performance: $operation took ${duration.inMilliseconds}ms');
  }
}

// Usage in repository
Future<Result<List<Product>>> getProducts() async {
  final stopwatch = Stopwatch()..start();
  
  try {
    DataLayerLogger.logDataOperation('getProducts', {});
    
    final products = await _dataSource.getProducts();
    
    stopwatch.stop();
    DataLayerLogger.logPerformance('getProducts', stopwatch.elapsed);
    
    return Result.ok(products);
  } catch (e) {
    DataLayerLogger.logError('getProducts', e);
    return Result.err(AppFailure.server(e.toString()));
  }
}
```

### **2. Network Monitoring | مراقبة الشبكة**
```dart
class NetworkMonitor {
  static Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }
  
  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  static void monitorNetworkChanges() {
    connectivityStream.listen((ConnectivityResult result) {
      Logger.info('Network status changed: $result');
      
      if (result == ConnectivityResult.none) {
        // Handle offline mode
        _handleOfflineMode();
      } else {
        // Handle online mode
        _handleOnlineMode();
      }
    });
  }
  
  static void _handleOfflineMode() {
    // Show offline indicator
    // Enable offline functionality
    // Queue operations for later sync
  }
  
  static void _handleOnlineMode() {
    // Hide offline indicator
    // Sync queued operations
    // Refresh data from server
  }
}
```

---

## 📊 **Performance Optimization | تحسين الأداء**

### **1. Data Pagination | ترقيم البيانات**
```dart
class PaginatedRepository {
  static const int defaultPageSize = 20;
  
  Future<Result<PaginatedResponse<Product>>> getProducts({
    int page = 1,
    int limit = defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.getProducts(
        page: page,
        limit: limit,
      );
      
      return Result.ok(PaginatedResponse<Product>(
        data: response.products,
        currentPage: page,
        totalPages: response.totalPages,
        totalItems: response.totalItems,
        hasNextPage: page < response.totalPages,
        hasPreviousPage: page > 1,
      ));
    } catch (e) {
      return Result.err(AppFailure.server(e.toString()));
    }
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;
  
  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
```

### **2. Data Compression | ضغط البيانات**
```dart
class DataCompressor {
  static String compressJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final compressed = gzip.encode(bytes);
    return base64Encode(compressed);
  }
  
  static Map<String, dynamic> decompressJson(String compressedData) {
    final bytes = base64Decode(compressedData);
    final decompressed = gzip.decode(bytes);
    final jsonString = utf8.decode(decompressed);
    return jsonDecode(jsonString);
  }
}
```

---

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Troubleshooting Specific Criteria:**
- [ ] Comprehensive error logging implemented
- [ ] Network monitoring and offline support
- [ ] Cache management and invalidation
- [ ] Performance optimization strategies
- [ ] Data validation and consistency checks
- [ ] User-friendly error messages

---

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Troubleshooting Specific Pitfalls:**
- **Avoid**: Not logging errors properly
- **Avoid**: Generic error messages
- **Avoid**: No offline support
- **Avoid**: Missing cache invalidation
- **Avoid**: Poor performance monitoring
- **Avoid**: Inconsistent error handling

---

## 🔗 **Navigation | التنقل**

[← Previous: Testing Data Layer | السابق: اختبار طبقة البيانات](03_Testing_Data_Layer.md)
[Next: Data Layer Overview | التالي: نظرة عامة على طبقة البيانات →](../03-Data-Layer/03_Data_Layer_Overview.md)
[🏠 Home | الرئيسية](../../../index.html)

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Troubleshooting  
**Status | الحالة**: ✅ Production Ready
