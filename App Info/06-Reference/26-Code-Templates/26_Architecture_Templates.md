# 26. قوالب المعمارية
## 26. Architecture Templates

> **الجزء السادس: المراجع والأدوات | Part VI: References & Tools**

## 🎯 **Objective | الهدف**
Provide comprehensive architecture templates for Clean Architecture implementation in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: قوالب جاهزة للمعمارية + أنماط التصميم + هيكل المشروع  
**English**: Ready-to-use architecture templates + Design patterns + Project structure

## 💡 **Benefits | الفوائد**
- **Development Speed | سرعة التطوير**: Quick project setup with proper architecture
- **Consistency | الاتساق**: Standardized architectural patterns
- **Best Practices | أفضل الممارسات**: Built-in architectural best practices
- **Team Onboarding | إدماج الفريق**: Easy for new team members to follow
- **Code Quality | جودة الكود**: Consistent, maintainable architecture
- **Scalability | قابلية التوسع**: Scalable architecture from the start

---

## 🏗️ **Architecture Templates | قوالب المعمارية**

### **1. Clean Architecture Project Structure**
```bash
# Create new Flutter project with Clean Architecture
flutter create --org com.zahraah zahraah_app
cd zahraah_app

# Create folder structure
mkdir -p lib/{core/{app,domain,data},features/{catalog,cart,checkout}/{presentation,domain,data},shared/{widgets,utils}}

# Create core folders
mkdir -p lib/core/{app/{router,theme,l10n,di,errors,utils},domain/{entities,repositories},data/{datasources/{remote,local},repositories,models}}

# Create feature folders
mkdir -p lib/features/catalog/{presentation/{pages,widgets},domain/{usecases,entities},data/{repositories,datasources}}
```

### **2. Feature Module Template**
```dart
// lib/features/catalog/presentation/pages/catalog_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/product_card.dart';
import '../../domain/entities/product.dart';
import '../controllers/catalog_controller.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('search'),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: catalogState.when(
        data: (products) => _buildProductGrid(products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('خطأ: $error'),
        ),
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
        return ProductCard(product: products[index]);
      },
    );
  }
}
```

---

## 🎯 **Use Case Templates | قوالب حالات الاستخدام**

### **1. Basic Use Case Template**
```dart
// lib/features/catalog/domain/usecases/get_product_list.dart
import 'package:dartz/dartz.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/domain/repositories/catalog_repository.dart';

class GetProductList {
  final CatalogRepository repository;
  
  GetProductList(this.repository);
  
  Future<Either<Failure, List<Product>>> call() async {
    try {
      final products = await repository.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### **2. Complex Use Case Template**
```dart
// lib/features/cart/domain/usecases/add_to_cart.dart
import 'package:dartz/dartz.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:zahraah_app/domain/entities/cart_item.dart';
import 'package:zahraah_app/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;
  
  AddToCart(this.repository);
  
  Future<Either<Failure, CartItem>> call({
    required String productId,
    required int quantity,
    required Map<String, dynamic> options,
  }) async {
    try {
      // Validate input
      if (quantity <= 0) {
        return Left(ValidationFailure('Quantity must be greater than 0'));
      }
      
      // Check product availability
      final availability = await repository.checkProductAvailability(productId);
      if (!availability) {
        return Left(ProductNotAvailableFailure('Product is not available'));
      }
      
      // Add to cart
      final cartItem = await repository.addToCart(
        productId: productId,
        quantity: quantity,
        options: options,
      );
      
      return Right(cartItem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 🏛️ **Repository Templates | قوالب المستودعات**

### **1. Repository Interface Template**
```dart
// lib/features/catalog/domain/repositories/catalog_repository.dart
import 'package:dartz/dartz.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:zahraah_app/domain/entities/product.dart';

abstract class CatalogRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
}
```

### **2. Repository Implementation Template**
```dart
// lib/features/catalog/data/repositories/catalog_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:zahraah_app/core/errors/failures.dart';
import 'package:zahraah_app/domain/entities/product.dart';
import 'package:zahraah_app/domain/repositories/catalog_repository.dart';
import 'package:zahraah_app/data/datasources/catalog_remote_datasource.dart';
import 'package:zahraah_app/data/datasources/catalog_local_datasource.dart';
import 'package:zahraah_app/data/models/product_model.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;
  final CatalogLocalDataSource localDataSource;
  
  CatalogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Try to get from local cache first
      final localProducts = await localDataSource.getProducts();
      if (localProducts.isNotEmpty) {
        return Right(localProducts);
      }
      
      // If no local data, fetch from remote
      final remoteProducts = await remoteDataSource.getProducts();
      
      // Cache the data locally
      await localDataSource.cacheProducts(remoteProducts);
      
      return Right(remoteProducts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      // Try local first
      final localProduct = await localDataSource.getProductById(id);
      if (localProduct != null) {
        return Right(localProduct);
      }
      
      // Fetch from remote
      final remoteProduct = await remoteDataSource.getProductById(id);
      
      // Cache locally
      await localDataSource.cacheProduct(remoteProduct);
      
      return Right(remoteProduct);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Migration Guide | السابق: دليل الهجرة](../28_Migration_Guide.md)
[Next: Testing Templates | التالي: قوالب الاختبار →](26_Testing_Templates.md)
[🏠 Home | الرئيسية](../../../index.html)

---
