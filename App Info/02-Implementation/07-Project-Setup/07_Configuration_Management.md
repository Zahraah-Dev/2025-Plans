# 7. إدارة التكوين والبيئات
## 7. Configuration Management

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Implement comprehensive configuration management for different environments (dev/staging/prod) with secure handling of API keys and environment-specific settings.

## 📋 **Rule | القاعدة**
**Arabic**: إدارة تكوين شاملة + بيئات متعددة + أمان المفاتيح + إدارة الأسرار  
**English**: Comprehensive configuration management + Multiple environments + Key security + Secrets management

## 💡 **Benefits | الفوائد**
- **Environment Isolation | عزل البيئات**: Clear separation between dev/staging/prod
- **Security | الأمان**: Secure handling of sensitive configuration data
- **Flexibility | المرونة**: Easy switching between different configurations
- **Maintainability | سهولة الصيانة**: Centralized configuration management
- **Team Collaboration | تعاون الفريق**: Consistent configuration across team
- **Deployment Safety | أمان النشر**: Safe deployment with proper configuration

---

## ⚙️ **التكوين | Configuration**

### **1. Environment Configuration**
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

### **2. Build Flavors**
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

### **3. Build Scripts**
```bash
# build_scripts/build_dev.sh
#!/bin/bash
flutter build apk --flavor development --dart-define=ENVIRONMENT=development --dart-define=BASE_URL=https://dev-api.zahraah.com

# build_scripts/build_staging.sh
#!/bin/bash
flutter build apk --flavor staging --dart-define=ENVIRONMENT=staging --dart-define=BASE_URL=https://staging-api.zahraah.com

# build_scripts/build_prod.sh
#!/bin/bash
flutter build apk --flavor production --dart-define=ENVIRONMENT=production --dart-define=BASE_URL=https://api.zahraah.com
```

---

## 🔐 **إدارة الأسرار | Secrets Management**

### **1. Environment Variables**
```bash
# .env.development
BASE_URL=https://dev-api.zahraah.com
API_KEY=dev_api_key_here
ENABLE_LOGGING=true
ENABLE_CRASHLYTICS=false

# .env.staging
BASE_URL=https://staging-api.zahraah.com
API_KEY=staging_api_key_here
ENABLE_LOGGING=true
ENABLE_CRASHLYTICS=true

# .env.production
BASE_URL=https://api.zahraah.com
API_KEY=production_api_key_here
ENABLE_LOGGING=false
ENABLE_CRASHLYTICS=true
```

### **2. Secure Storage**
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

---

## 🌐 **التعدد اللغوي وRTL | Internationalization & RTL**

### **1. L10n Configuration**
```yaml
# pubspec.yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

### **2. RTL Support**
```dart
class AppLocalizations {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];
  
  static const String fallbackLocale = 'en';
  
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ar';
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Project Setup Overview | السابق: نظرة عامة على إعداد المشروع](07_Project_Setup_Overview.md)
[Next: Dependencies & Tools | التالي: التبعيات والأدوات →](07_Dependencies_Tools.md)
[🏠 Home | الرئيسية](../../../index.html)

---
