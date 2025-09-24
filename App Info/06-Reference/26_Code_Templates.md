# 26. قوالب الكود والأدوات
## 26. Code Templates & Tools

> **الجزء السادس: المراجع والأدوات | Part VI: References & Tools**

## 🎯 **Objective | الهدف**
Implement Code Templates for robust, maintainable Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: قوالب جاهزة للنسخ والاستخدام في المشروع  
**English**: Ready-to-use templates for copying and using in the project

## 💡 **Benefits | الفوائد**
- **Development Speed | سرعة التطوير**: Quick code generation
- **Consistency | الاتساق**: Standardized code patterns
- **Best Practices | أفضل الممارسات**: Built-in best practices
- **Team Onboarding | إدماج الفريق**: Easy for new team members
- **Code Quality | جودة الكود**: Consistent, high-quality code
- **Time Saving | توفير الوقت**: Reduce repetitive coding

## 🛠️ **Implementation | التطبيق**
- **Use in**: All development activities and code generation
- **How to implement**:
  - Create comprehensive template library
  - Document template usage
  - Provide examples and best practices
  - Keep templates updated
  - Add IDE integration
- **Result**: Efficient development with consistent code quality

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Code Templates Specific Criteria:**
- [ ] Comprehensive template library
- [ ] Clear documentation
- [ ] Easy to use
- [ ] Regularly updated
- [ ] IDE integration
- [ ] Team adoption

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Code Templates Specific Pitfalls:**
- **Avoid**: Outdated templates
- **Avoid**: No documentation
- **Avoid**: Complex templates
- **Avoid**: No examples
- **Avoid**: Missing best practices
- **Avoid**: No maintenance

---

## 📚 **Detailed Templates | القوالب التفصيلية**

### **🏗️ Architecture Templates | قوالب المعمارية**

#### **Clean Architecture Project Structure | هيكل مشروع Clean Architecture**
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

#### **Feature Module Template | قالب وحدة الميزة**
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

### **🧪 Testing Templates | قوالب الاختبار**

#### **Unit Test Template | قالب اختبار الوحدة**
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
  });
}
```

### **🎨 UI Component Templates | قوالب مكونات الواجهة**

#### **Button Components | مكونات الأزرار**
```dart
// lib/shared/widgets/buttons/app_button.dart
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton(context);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context);
      case AppButtonType.outline:
        return _buildOutlineButton(context);
      case AppButtonType.text:
        return _buildTextButton(context);
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

enum AppButtonType { primary, secondary, outline, text }
```

### **📊 Data Layer Templates | قوالب طبقة البيانات**

#### **API Client Template | قالب عميل API**
```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:zahraah_app/core/config/app_config.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }
}
```

---

## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **Code Templates Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Outdated Templates** | Medium | High | Regular updates, version control |
| **Template Complexity** | Medium | Medium | Clear documentation, examples |
| **Team Adoption** | High | Medium | Training, documentation, support |
| **Maintenance Overhead** | Medium | High | Automated updates, clear ownership |

## 📊 **Implementation Priority | أولوية التنفيذ**

> **Reference**: See [Implementation Priority Template](../../00-Templates/02_Implementation_Priority_Template.md) for standard phases.

### **Code Templates Specific Priorities:**
### **Phase 1: Foundation (Must Have)**
- [ ] Core architecture templates
- [ ] Basic UI component templates
- [ ] Essential data layer templates
- [ ] Basic testing templates

### **Phase 2: Enhancement (Should Have)**
- [ ] Advanced component templates
- [ ] Complex testing scenarios
- [ ] Performance optimization templates
- [ ] Documentation templates

### **Phase 3: Optimization (Could Have)**
- [ ] IDE integration
- [ ] Automated template generation
- [ ] Advanced patterns
- [ ] Custom template creation

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Code Templates Specific Quality Gates:**
- [ ] All templates tested and working
- [ ] Documentation complete and clear
- [ ] Examples provided for each template
- [ ] Templates follow best practices
- [ ] Regular updates and maintenance
- [ ] Team adoption and usage

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Success Metrics Template](../../00-Templates/04_Success_Metrics_Template.md) for standard metrics.

### **Code Templates Specific Metrics:**
- **Template Usage**: 80%+ of new code uses templates
- **Development Speed**: 50% faster feature development
- **Code Consistency**: 95%+ code follows templates
- **Team Productivity**: Faster onboarding and development
- **Quality Improvement**: 70% fewer code review issues

---

## 🔗 **Navigation | التنقل**

[← Previous: Migration Guide | السابق: دليل الهجرة](28_Migration_Guide.md)
[Next: Troubleshooting | التالي: حل المشاكل →](27_Troubleshooting.md)
[🏠 Home | الرئيسية](../../index.html)

---