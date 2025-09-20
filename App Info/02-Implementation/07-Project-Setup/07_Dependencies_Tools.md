# 7. التبعيات والأدوات
## 7. Dependencies & Tools

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Set up comprehensive dependency management and development tools for Flutter e-commerce application development.

## 📋 **Rule | القاعدة**
**Arabic**: إدارة التبعيات + أدوات التطوير + إدارة الإصدارات + أدوات الجودة  
**English**: Dependency management + Development tools + Version management + Quality tools

## 💡 **Benefits | الفوائد**
- **Dependency Management | إدارة التبعيات**: Proper version control and conflict resolution
- **Development Tools | أدوات التطوير**: Enhanced development experience
- **Code Quality | جودة الكود**: Automated code quality checks
- **Team Productivity | إنتاجية الفريق**: Consistent development environment
- **Maintainability | سهولة الصيانة**: Easy dependency updates and management
- **Security | الأمان**: Secure dependency management

---

## 📦 **Dependencies | التبعيات**

### **1. Core Dependencies**
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

### **2. Development Dependencies**
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

---

## 🛠️ **Development Tools | أدوات التطوير**

### **1. Code Generation**
```bash
# Generate code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean generated files
flutter packages pub run build_runner clean
```

### **2. Code Quality Tools**
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    - avoid_print
    - avoid_unnecessary_containers
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
```

### **3. Testing Tools**
```dart
// test/setup.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });
}
```

---

## 🔧 **Build Configuration | تكوين البناء**

### **1. Android Configuration**
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    ndkVersion "25.1.8937393"
    
    defaultConfig {
        applicationId "com.zahraah.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### **2. iOS Configuration**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Zahraah</string>
<key>CFBundleIdentifier</key>
<string>com.zahraah.app</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

---

## 📋 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Dependencies Quality Gates:**
- [ ] All dependencies up to date
- [ ] No security vulnerabilities
- [ ] Compatible versions
- [ ] Proper version pinning
- [ ] Clean dependency tree

### **Tools Quality Gates:**
- [ ] Code generation working
- [ ] Linting rules enforced
- [ ] Testing tools configured
- [ ] Build tools functional
- [ ] Documentation tools active

---

## 🔗 **Navigation | التنقل**

[← Previous: Configuration Management | السابق: إدارة التكوين](07_Configuration_Management.md)
[Next: CI/CD Setup | التالي: إعداد CI/CD →](07_CI_CD_Setup.md)
[🏠 Home | الرئيسية](../../../index.html)

---
