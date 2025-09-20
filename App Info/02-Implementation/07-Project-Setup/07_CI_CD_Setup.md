# 7. إعداد CI/CD
## 7. CI/CD Setup

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Set up comprehensive CI/CD pipeline for automated testing, building, and deployment of Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: خط أنابيب CI/CD شامل + اختبارات آلية + نشر آمن + مراقبة مستمرة  
**English**: Comprehensive CI/CD pipeline + Automated testing + Safe deployment + Continuous monitoring

## 💡 **Benefits | الفوائد**
- **Automated Testing | اختبارات آلية**: Continuous quality assurance
- **Safe Deployment | نشر آمن**: Automated, reliable deployment process
- **Quality Gates | بوابات الجودة**: Automated quality checks and validation
- **Team Productivity | إنتاجية الفريق**: Faster development and deployment cycles
- **Risk Reduction | تقليل المخاطر**: Automated testing reduces human error
- **Continuous Integration | التكامل المستمر**: Early detection of issues

---

## 🚀 **CI/CD Pipeline | خط أنابيب CI/CD**

### **1. GitHub Actions Workflow**
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

### **2. Build Scripts**
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

## 🧪 **Testing Pipeline | خط أنابيب الاختبار**

### **1. Unit Tests**
```dart
// test/unit/catalog_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('Catalog Tests', () {
    test('should return products when getProducts is called', () async {
      // Test implementation
    });
  });
}
```

### **2. Widget Tests**
```dart
// test/widget/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProductCard displays product information', (tester) async {
    // Widget test implementation
  });
}
```

### **3. Integration Tests**
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete user journey', (tester) async {
      // Integration test implementation
    });
  });
}
```

---

## 📦 **Deployment Pipeline | خط أنابيب النشر**

### **1. Staging Deployment**
```yaml
# .github/workflows/staging.yml
name: Deploy to Staging

on:
  push:
    branches: [ develop ]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      
      - name: Build staging APK
        run: flutter build apk --flavor staging --release
      
      - name: Deploy to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID }}
          token: ${{ secrets.FIREBASE_TOKEN }}
          groups: testers
          file: build/app/outputs/flutter-apk/app-staging-release.apk
```

### **2. Production Deployment**
```yaml
# .github/workflows/production.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy-production:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      
      - name: Build production APK
        run: flutter build apk --flavor production --release
      
      - name: Deploy to Google Play
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.zahraah.app
          releaseFiles: build/app/outputs/flutter-apk/app-production-release.apk
```

---

## 📊 **Monitoring & Analytics | المراقبة والتحليلات**

### **1. Build Monitoring**
```yaml
# .github/workflows/monitor.yml
name: Build Monitoring

on:
  workflow_run:
    workflows: ["CI/CD Pipeline"]
    types: [completed]

jobs:
  monitor:
    runs-on: ubuntu-latest
    steps:
      - name: Check build status
        run: |
          if [ "${{ github.event.workflow_run.conclusion }}" != "success" ]; then
            echo "Build failed, sending notification"
            # Send notification logic
          fi
```

### **2. Quality Metrics**
```bash
#!/bin/bash
# scripts/quality-check.sh

echo "Running quality checks..."

# Code coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Code analysis
flutter analyze

# Performance testing
flutter test integration_test/performance_test.dart

echo "Quality checks completed!"
```

---

## 📋 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **CI/CD Quality Gates:**
- [ ] All tests passing
- [ ] Code coverage >80%
- [ ] No linting errors
- [ ] Build successful
- [ ] Deployment successful
- [ ] Monitoring active

---

## 🔗 **Navigation | التنقل**

[← Previous: Dependencies & Tools | السابق: التبعيات والأدوات](07_Dependencies_Tools.md)
[Next: Testing Strategy | التالي: استراتيجية الاختبار →](../08_Testing_Strategy.md)
[🏠 Home | الرئيسية](../../../index.html)

---
