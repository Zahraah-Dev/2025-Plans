---
layout: default
title: "7. إعداد المشروع والتكوين"
description: "Flutter e-commerce development guide"
permalink: /app_info/02-Implementation/07-project-setup-config/
---

# 7. إعداد المشروع والتكوين
## 7. Project Setup & Configuration

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Set up complete Flutter e-commerce project with proper configuration, dependencies, and development environment for team collaboration.

## 📋 **Rule | القاعدة**
**Arabic**: Flavors + dart-define، وملف AppConfig يحقن في ProviderScope  
**English**: Flavors + dart-define, and AppConfig file injected in ProviderScope

## 💡 **Benefits | الفوائد**
- **Environment Management | إدارة البيئات**: Easy switching between dev/staging/prod
- **Configuration Centralization | مركزية التكوين**: Single source of truth for app settings
- **Team Collaboration | تعاون الفريق**: Consistent setup across team members
- **Security | الأمان**: Secure handling of API keys and secrets
- **Development Speed | سرعة التطوير**: Quick project setup and onboarding
- **Maintainability | سهولة الصيانة**: Easy to update configurations

## 🛠️ **Implementation | التطبيق**
- **Use in**: Project initialization, environment configuration, and team onboarding
- **How to implement**:
  - Set up Flutter project with proper structure
  - Configure flavors for different environments
  - Implement AppConfig with dependency injection
  - Set up proper dependency management
  - Configure development tools and CI/CD
- **Result**: Production-ready project setup with proper configuration management

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06-success-criteria-template/) for standard criteria.

### **Project Setup Specific Criteria:**
- [ ] Project structure follows clean architecture
- [ ] Flavors configured for all environments
- [ ] AppConfig properly injected via DI
- [ ] All dependencies properly managed
- [ ] Development tools configured
- [ ] Team onboarding documentation complete

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05-common-pitfalls-template/) for standard pitfalls.

### **Project Setup Specific Pitfalls:**
- **Avoid**: Hardcoded configuration values
- **Avoid**: Missing environment-specific settings
- **Avoid**: Inconsistent project structure
- **Avoid**: Missing dependency version management
- **Avoid**: No proper secrets management
- **Avoid**: Incomplete development setup

---

## 📚 **Detailed Implementation | التنفيذ التفصيلي**

### **🚀 Project Setup Overview | نظرة عامة على إعداد المشروع**

#### **1. إنشاء المشروع | Project Creation**
```bash
# إنشاء مشروع Flutter جديد
flutter create zahraah_app

# الانتقال لمجلد المشروع
cd zahraah_app

# إضافة التبعيات المطلوبة
flutter pub add riverpod
flutter pub add go_router
flutter pub add dio
flutter pub add hive
flutter pub add freezed
flutter pub add json_annotation
flutter pub add build_runner
flutter pub add mocktail
flutter pub add golden_toolkit
```

#### **2. هيكل المشروع | Project Structure**
```
/lib
  /core
    /app
      /router
        app_router.dart
      /theme
        app_theme.dart
      /l10n
        app_localizations.dart
      /di
        injection.dart
      /errors
        failures.dart
        exceptions.dart
      /utils
        constants.dart
        extensions.dart
    /domain
      /entities
        product.dart
        cart_item.dart
      /repositories
        catalog_repository.dart
        cart_repository.dart
    /data
      /datasources
        /remote
          catalog_remote_datasource.dart
        /local
          catalog_local_datasource.dart
      /repositories
        catalog_repository_impl.dart
      /models
        product_model.dart
  /features
    /catalog
      /presentation
        /pages
          catalog_page.dart
        /widgets
          product_card.dart
        catalog_controller.dart
      /domain
        /usecases
          get_product_list.dart
      /data
        catalog_repository_impl.dart
    /cart
      /presentation
        /pages
          cart_page.dart
        /widgets
          cart_item_widget.dart
        cart_controller.dart
      /domain
        /usecases
          add_to_cart.dart
          remove_from_cart.dart
      /data
        cart_repository_impl.dart
  /shared
    /widgets
      loading_widget.dart
      error_widget.dart
```

### **⚙️ Configuration Management | إدارة التكوين**

#### **Environment Configuration | تكوين البيئات**
```dart
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.zahraah.com',
  );
  
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'dev_api_key',
  );
  
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  
  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );
  
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
}
```

#### **Build Flavors | نكهات البناء**
```yaml
# android/app/build.gradle
android {
    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "Zahraah Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "Zahraah Staging"
        }
        production {
            dimension "environment"
            resValue "string", "app_name", "Zahraah"
        }
    }
}
```

#### **Secrets Management | إدارة الأسرار**
```dart
class SecureConfig {
  static const String _baseUrlKey = 'base_url';
  static const String _apiKeyKey = 'api_key';
  
  static Future<void> storeConfig({
    required String baseUrl,
    required String apiKey,
  }) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: _baseUrlKey, value: baseUrl);
    await storage.write(key: _apiKeyKey, value: apiKey);
  }
  
  static Future<Map<String, String?>> getConfig() async {
    final storage = FlutterSecureStorage();
    return {
      'baseUrl': await storage.read(key: _baseUrlKey),
      'apiKey': await storage.read(key: _apiKeyKey),
    };
  }
}
```

### **📦 Dependencies & Tools | التبعيات والأدوات**

#### **Core Dependencies | التبعيات الأساسية**
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Navigation
  go_router: ^12.1.3
  
  # Networking
  dio: ^5.4.0
  retrofit: ^4.0.3
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Code Generation
  freezed: ^2.4.6
  json_annotation: ^4.8.1
  
  # UI Components
  flutter_screenutil: ^5.9.0
  cached_network_image: ^3.3.0
  
  # Utilities
  intl: ^0.18.1
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
```

#### **Development Dependencies | تبعيات التطوير**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  
  # Testing
  mocktail: ^1.0.1
  golden_toolkit: ^0.15.0
  integration_test:
    sdk: flutter
  
  # Code Quality
  flutter_lints: ^3.0.1
  very_good_analysis: ^5.1.0
  
  # Documentation
  dartdoc: ^6.2.1
```

### **🚀 CI/CD Setup | إعداد CI/CD**

#### **GitHub Actions Workflow | سير عمل GitHub Actions**
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Run integration tests
        run: flutter test integration_test/
      
      - name: Generate code coverage
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: build/
```

#### **Build Scripts | سكريبتات البناء**
```bash
#!/bin/bash
# scripts/build.sh

set -e

echo "Building Flutter app..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release --no-codesign

echo "Build completed successfully!"
```

---

## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../../00-Templates/01-risk-assessment-template/) for standard risk categories.

### **Project Setup Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Configuration Errors** | High | Medium | Environment validation, testing |
| **Dependency Conflicts** | Medium | Medium | Version pinning, regular updates |
| **Security Vulnerabilities** | High | Low | Security scanning, secure storage |
| **Team Onboarding Issues** | Medium | Medium | Documentation, training |

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../../00-Templates/13-generic-priority-framework/) for priority levels and criteria.

### **Project Setup Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Basic project structure and environment configuration
- **🔴 Critical**: Core dependencies and basic CI/CD setup
- **🟠 High**: Development tools and testing pipeline

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Advanced configuration and development tools
- **🟠 High**: Testing pipeline and documentation setup
- **🟡 Medium**: Monitoring and analytics integration

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: Advanced CI/CD features and automation tools
- **🟡 Medium**: Monitoring and analytics optimization
- **🟢 Low**: AI-assisted development tools and advanced automation
- [ ] Performance optimization

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../00-Templates/03-quality-gates-template/) for standard quality criteria.

### **Project Setup Specific Quality Gates:**
- [ ] Project structure follows clean architecture
- [ ] All environments configured
- [ ] Dependencies properly managed
- [ ] CI/CD pipeline working
- [ ] Documentation complete
- [ ] Team onboarding successful

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../../00-Templates/15-comprehensive-metrics-template/) for topic-specific metrics.

### **Project Setup Specific Metrics:**
- **Setup Time**: <30 minutes for new team members
- **Build Success Rate**: >95% successful builds
- **Deployment Success**: >99% successful deployments
- **Team Productivity**: 50% faster development setup
- **Configuration Accuracy**: 100% correct environment settings

---

## 🔗 **Navigation | التنقل**

[← Previous: Design System](../01-Architecture/06_Design_System.md)
**السابق: نظام التصميم**
[](/2025-Plans/app_info/02-Implementation/08-testing-strategy/)
[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**

---