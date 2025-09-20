# 8. أدوات الاختبار و CI/CD
## 8. Testing Tools & CI

> **الجزء الثاني: سير العمل والتطوير | Part II: Development Workflow**

## 🎯 **Objective | الهدف**
Implement comprehensive testing tools and CI/CD integration to automate testing, ensure code quality, and enable continuous delivery.

## 📋 **Rule | القاعدة**
**Arabic**: أدوات اختبار متقدمة + تكامل CI/CD + تقارير شاملة + مراقبة الجودة  
**English**: Advanced testing tools + CI/CD integration + Comprehensive reports + Quality monitoring

## 💡 **Benefits | الفوائد**
- **Automation | الأتمتة**: Automated testing on every commit
- **Quality Gates | بوابات الجودة**: Prevent low-quality code from reaching production
- **Continuous Feedback | ردود فعل مستمرة**: Immediate feedback on code changes
- **Team Collaboration | تعاون الفريق**: Shared testing standards and practices
- **Deployment Confidence | ثقة النشر**: Deploy with confidence knowing tests pass
- **Performance Monitoring | مراقبة الأداء**: Track performance metrics over time

---

## 🛠️ **Testing Tools | أدوات الاختبار**

### **1. Test Dependencies**
```yaml
# pubspec.yaml
dev_dependencies:
  # Core testing
  flutter_test:
    sdk: flutter
  
  # Unit testing
  mockito: ^5.4.2
  build_runner: ^2.4.7
  
  # Widget testing
  integration_test:
    sdk: flutter
  
  # Golden tests
  golden_toolkit: ^0.15.0
  
  # Performance testing
  vm_service: ^11.0.0
  
  # Code coverage
  coverage: ^1.6.0
  
  # Test utilities
  fake_async: ^1.3.1
  clock: ^1.1.1
```

### **2. Test Configuration**
```yaml
# test/test_config.yaml
test_config:
  timeout: 30s
  concurrency: 4
  retry: 2
  
coverage:
  include:
    - lib/**
  exclude:
    - lib/**/*.g.dart
    - lib/**/*.freezed.dart
    - lib/**/*.mocks.dart
    - lib/main.dart
    - lib/core/di/**
  
golden_toolkit:
  enable_goldens: true
  skip_goldens: false
```

### **3. Test Utilities**
```dart
// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class TestHelpers {
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    Locale? locale,
  }) {
    return MaterialApp(
      home: child,
      theme: theme,
      locale: locale,
      localizationsDelegates: const [
        // Add your localization delegates
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
    );
  }
  
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await tester.pumpAndSettle(timeout);
  }
  
  static Future<void> loadGoldenFile(
    String fileName,
    Widget widget, {
    ThemeData? theme,
    Locale? locale,
  }) async {
    await loadAppFonts();
    await tester.pumpWidget(
      createTestApp(
        child: widget,
        theme: theme,
        locale: locale,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('goldens/$fileName.png'),
    );
  }
}
```

---

## 🔄 **CI/CD Integration | تكامل CI/CD**

### **1. GitHub Actions Workflow**
```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
    
    - name: Run unit tests
      run: flutter test --coverage
    
    - name: Run widget tests
      run: flutter test test/widget/
    
    - name: Run integration tests
      run: flutter test integration_test/
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        flags: unittests
        name: codecov-umbrella
```

### **2. Multi-Platform Testing**
```yaml
# .github/workflows/multi_platform_test.yml
name: Multi-Platform Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    
    runs-on: ${{ matrix.os }}
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
```

### **3. Performance Testing Pipeline**
```yaml
# .github/workflows/performance_test.yml
name: Performance Test

on:
  push:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM

jobs:
  performance_test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run performance tests
      run: flutter test test/performance/
    
    - name: Generate performance report
      run: |
        flutter test test/performance/ --reporter=json > performance_report.json
    
    - name: Upload performance report
      uses: actions/upload-artifact@v3
      with:
        name: performance-report
        path: performance_report.json
```

---

## 📊 **Test Reporting | تقارير الاختبار**

### **1. Coverage Reports**
```yaml
# .github/workflows/coverage.yml
name: Coverage Report

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  coverage:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests with coverage
      run: flutter test --coverage
    
    - name: Generate coverage report
      run: |
        genhtml coverage/lcov.info -o coverage/html
        lcov --summary coverage/lcov.info
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        flags: unittests
        name: codecov-umbrella
```

### **2. Test Results Dashboard**
```dart
// test/reporting/test_dashboard.dart
class TestDashboard {
  static void generateReport() {
    final report = TestReport(
      timestamp: DateTime.now(),
      totalTests: 0,
      passedTests: 0,
      failedTests: 0,
      skippedTests: 0,
      coverage: 0.0,
      performance: PerformanceMetrics(),
    );
    
    // Generate HTML report
    final htmlReport = _generateHtmlReport(report);
    File('test_reports/dashboard.html').writeAsStringSync(htmlReport);
  }
  
  static String _generateHtmlReport(TestReport report) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Test Dashboard</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            .metric { display: inline-block; margin: 10px; padding: 10px; border: 1px solid #ccc; }
            .passed { background-color: #d4edda; }
            .failed { background-color: #f8d7da; }
            .coverage { background-color: #d1ecf1; }
        </style>
    </head>
    <body>
        <h1>Test Dashboard</h1>
        <div class="metric passed">
            <h3>Passed Tests</h3>
            <p>${report.passedTests}</p>
        </div>
        <div class="metric failed">
            <h3>Failed Tests</h3>
            <p>${report.failedTests}</p>
        </div>
        <div class="metric coverage">
            <h3>Coverage</h3>
            <p>${(report.coverage * 100).toStringAsFixed(1)}%</p>
        </div>
    </body>
    </html>
    ''';
  }
}
```

---

## 🔧 **Test Automation | أتمتة الاختبار**

### **1. Test Scripts**
```bash
#!/bin/bash
# scripts/run_tests.sh

echo "Running Flutter Tests..."

# Unit tests
echo "Running unit tests..."
flutter test test/unit/ --coverage

# Widget tests
echo "Running widget tests..."
flutter test test/widget/ --coverage

# Integration tests
echo "Running integration tests..."
flutter test integration_test/

# Performance tests
echo "Running performance tests..."
flutter test test/performance/

# Generate coverage report
echo "Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "Tests completed successfully!"
```

### **2. Pre-commit Hooks**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-test
        name: Flutter Tests
        entry: flutter test
        language: system
        pass_filenames: false
        always_run: true
      
      - id: flutter-format
        name: Flutter Format
        entry: flutter format --set-exit-if-changed
        language: system
        pass_filenames: false
        always_run: true
      
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
        always_run: true
```

### **3. Test Data Management**
```dart
// test/helpers/test_data_manager.dart
class TestDataManager {
  static final Map<String, dynamic> _testData = {};
  
  static void loadTestData() {
    _testData['products'] = _loadProducts();
    _testData['users'] = _loadUsers();
    _testData['orders'] = _loadOrders();
  }
  
  static List<Product> getProducts() => _testData['products'] ?? [];
  static List<User> getUsers() => _testData['users'] ?? [];
  static List<Order> getOrders() => _testData['orders'] ?? [];
  
  static void resetTestData() {
    _testData.clear();
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Integration & Performance Tests | السابق: اختبارات التكامل والأداء](08_Integration_Performance_Tests.md)
[Next: Code Quality Standards | التالي: معايير جودة الكود →](../09_Code_Quality_Standards.md)
[🏠 Home | الرئيسية](../../../index.html)

---
