# 28. دليل الترحيل
## 28. Migration Guide

> **الجزء السادس: الملاحق | Part VI: Appendices**

## 🎯 **Objective | الهدف**
Provide comprehensive migration guide for version upgrades, dependency updates, and breaking changes in Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: دليل شامل للترحيل + خطوات مفصلة + اختبارات التحقق + حلول المشاكل  
**English**: Comprehensive migration guide + detailed steps + verification tests + problem solutions

## 💡 **Benefits | الفوائد**
- **Smooth Upgrades | ترقيات سلسة**: Easy version upgrades without breaking changes
- **Risk Mitigation | تخفيف المخاطر**: Reduce migration risks with proper planning
- **Team Efficiency | كفاءة الفريق**: Clear migration procedures for all team members
- **Quality Assurance | ضمان الجودة**: Thorough testing during migration
- **Documentation | التوثيق**: Centralized migration knowledge
- **Rollback Capability | إمكانية التراجع**: Safe rollback procedures if needed

## 🛠️ **Implementation | التطبيق**
- **Use in**: All version upgrades, dependency updates, and breaking changes
- **How to implement**:
  - Document migration procedures
  - Create verification checklists
  - Add rollback procedures
  - Test migration in staging
  - Monitor migration progress
- **Result**: Reliable, well-documented migration process

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06_Success_Criteria_Template.md) for standard criteria.

### **Migration Guide Specific Criteria:**
- [ ] Comprehensive migration procedures documented
- [ ] Verification checklists created
- [ ] Rollback procedures tested
- [ ] Staging environment migration successful
- [ ] Team training completed
- [ ] Migration monitoring active

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05_Common_Pitfalls_Template.md) for standard pitfalls.

### **Migration Guide Specific Pitfalls:**
- **Avoid**: No migration documentation
- **Avoid**: Missing verification steps
- **Avoid**: No rollback procedures
- **Avoid**: Skipping staging tests
- **Avoid**: No team training
- **Avoid**: Missing migration monitoring

---




## 🚨 **Risk Assessment | تقييم المخاطر**

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Production Issues** | High | Medium | Comprehensive testing, monitoring, rollback plans |
| **Performance Degradation** | Medium | Medium | Performance budgets, monitoring, optimization |
| **Security Vulnerabilities** | High | Low | Security audits, penetration testing, updates |
| **Deployment Failures** | Medium | Medium | Automated testing, staging environment, rollback |

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../../00-Templates/13_Generic_Priority_Framework.md) for priority levels and criteria.

### **Migration Guide Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Basic production setup and essential monitoring
- **🔴 Critical**: Security basics and core migration procedures
- **🟠 High**: Advanced monitoring and performance optimization

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Security hardening and advanced monitoring
- **🟠 High**: Performance optimization and advanced analytics
- **🟡 Medium**: Automation and advanced features

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: Advanced analytics and AI-powered migration
- **🟡 Medium**: Automation and advanced features
- **🟢 Low**: Advanced analytics and AI-powered migration management

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Migration Guide Specific Quality Gates:**
- [ ] Migration scripts tested in staging environment
- [ ] Data backup and recovery procedures validated
- [ ] Rollback plan tested and documented
- [ ] Team trained on migration procedures
- [ ] Migration checklist completed and verified
- [ ] Post-migration validation procedures in place

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../../00-Templates/15_Comprehensive_Metrics_Template.md) for topic-specific metrics.

### **Migration Guide Specific Metrics:**
- **Migration Success Rate**: 99%+ successful migrations, <1% rollback rate
- **System Uptime**: 99.9%+ availability during migration, <1% downtime
- **Performance**: Meet all performance budgets, <5% performance impact
- **Security**: Zero security incidents, 100% security compliance
- **Data Integrity**: 100% data consistency, zero data loss
- **Team Efficiency**: 50% faster migration, 90% first-time success


## 23. Migration Guide

> **الجزء السادس: الملاحق | Part VI: Appendices**

---

## 🔄 **Flutter Version Migration | ترحيل إصدار Flutter**

### **1. Flutter 3.0 to 3.16 Migration**

#### **Step 1: Update Flutter**
```bash
# Update Flutter to latest stable
flutter upgrade

# Check current version
flutter --version
```

#### **Step 2: Update Dependencies**
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  # Update to latest versions
  riverpod: ^2.4.0
  go_router: ^12.0.0
  dio: ^5.3.0
  hive: ^2.2.3
  freezed: ^2.4.0
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  mocktail: ^1.0.0
```

#### **Step 3: Run Migration Commands**
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run code generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for breaking changes
flutter analyze
```

### **2. Null Safety Migration**

#### **Step 1: Enable Null Safety**
```yaml
# pubspec.yaml
environment:
  sdk: '>=2.17.0 <4.0.0'
  flutter: ">=3.0.0"
```

#### **Step 2: Update Code for Null Safety**
```dart
// Before (non-null safety)
String name = user.name; // Could be null

// After (null safety)
String? name = user.name; // Explicitly nullable
String name = user.name ?? 'Unknown'; // Null-aware operator
String name = user.name!; // Null assertion (use carefully)
```

#### **Step 3: Update Widget Constructors**
```dart
// Before
class MyWidget extends StatelessWidget {
  final String title;
  MyWidget({this.title}); // Optional parameter
}

// After
class MyWidget extends StatelessWidget {
  final String title;
  const MyWidget({Key? key, required this.title}) : super(key: key);
}
```

---

## 🏗️ **Architecture Migration | ترحيل المعمارية**

### **1. From Provider to Riverpod**

#### **Step 1: Update Dependencies**
```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^2.4.0
  # Remove provider if using
  # provider: ^6.0.0
```

#### **Step 2: Update Main App**
```dart
// Before (Provider)
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

// After (Riverpod)
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

#### **Step 3: Update Widgets**
```dart
// Before (Provider)
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MyNotifier>(context);
    return Text(state.value);
  }
}

// After (Riverpod)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myNotifierProvider);
    return Text(state.value);
  }
}
```

### **2. From Bloc to Riverpod**

#### **Step 1: Update State Management**
```dart
// Before (Bloc)
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitial()) {
    on<MyEvent>((event, emit) {
      // Handle event
    });
  }
}

// After (Riverpod)
class MyNotifier extends StateNotifier<MyState> {
  MyNotifier() : super(MyInitial());
  
  void handleEvent() {
    state = MyNewState();
  }
}
```

#### **Step 2: Update Providers**
```dart
// Before (Bloc)
final myBlocProvider = BlocProvider<MyBloc>(
  create: (context) => MyBloc(),
);

// After (Riverpod)
final myNotifierProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});
```

---

## 📱 **Platform Migration | ترحيل المنصة**

### **1. Android Migration**

#### **Step 1: Update Android Configuration**
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.10.0'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.7.0'
}
```

#### **Step 2: Update Permissions**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### **2. iOS Migration**

#### **Step 1: Update iOS Configuration**
```ruby
# ios/Podfile
platform :ios, '12.0'
use_frameworks!

target 'Runner' do
  use_frameworks!
  use_modular_headers!
end
```

#### **Step 2: Update Info.plist**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>LSRequiresIPhoneOS</key>
<true/>
```

---

## 🔧 **Dependency Migration | ترحيل التبعيات**

### **1. HTTP Client Migration**

#### **From http to dio**
```dart
// Before (http)
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  return jsonDecode(response.body);
}

// After (dio)
import 'package:dio/dio.dart';

final dio = Dio();

Future<Map<String, dynamic>> fetchData() async {
  final response = await dio.get('https://api.example.com/data');
  return response.data;
}
```

### **2. State Management Migration**

#### **From setState to Riverpod**
```dart
// Before (setState)
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _value = '';
  
  void _updateValue(String newValue) {
    setState(() {
      _value = newValue;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(_value);
  }
}

// After (Riverpod)
final valueProvider = StateProvider<String>((ref) => '');

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(valueProvider);
    
    return Text(value);
  }
}
```

---

## 🧪 **Testing Migration | ترحيل الاختبارات**

### **1. Update Test Dependencies**
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  # Remove mockito if using
  # mockito: ^5.4.0
```

### **2. Update Mock Classes**
```dart
// Before (mockito)
class MockRepository extends Mock implements Repository {}

// After (mocktail)
class MockRepository extends Mock implements Repository {}
```

### **3. Update Test Setup**
```dart
// Before
void main() {
  group('MyTest', () {
    late MockRepository mockRepository;
    
    setUp(() {
      mockRepository = MockRepository();
    });
    
    test('should work', () {
      when(mockRepository.getData()).thenReturn('data');
      // Test logic
    });
  });
}

// After
void main() {
  group('MyTest', () {
    late MockRepository mockRepository;
    
    setUp(() {
      mockRepository = MockRepository();
    });
    
    test('should work', () {
      when(() => mockRepository.getData()).thenReturn('data');
      // Test logic
    });
  });
}
```

---

## 📊 **Data Migration | ترحيل البيانات**

### **1. Database Schema Migration**
```dart
// Hive migration example
class HiveMigration {
  static Future<void> migrate() async {
    final box = await Hive.openBox('myBox');
    
    // Migrate data from old format to new format
    final oldData = box.get('oldKey');
    if (oldData != null) {
      final newData = _convertToNewFormat(oldData);
      box.put('newKey', newData);
      box.delete('oldKey');
    }
  }
  
  static Map<String, dynamic> _convertToNewFormat(dynamic oldData) {
    // Conversion logic
    return {
      'id': oldData['id'],
      'name': oldData['title'], // Field renamed
      'price': oldData['cost'], // Field renamed
    };
  }
}
```

### **2. API Response Migration**
```dart
// Handle API version changes
class ApiClient {
  static const String apiVersion = 'v2';
  
  Future<Map<String, dynamic>> getData() async {
    final response = await dio.get('/api/$apiVersion/data');
    
    // Handle different response formats
    if (response.data is Map<String, dynamic>) {
      return _migrateResponse(response.data);
    }
    
    return response.data;
  }
  
  Map<String, dynamic> _migrateResponse(Map<String, dynamic> data) {
    // Migrate from old API format to new format
    return {
      'id': data['id'],
      'name': data['title'] ?? data['name'],
      'price': data['cost'] ?? data['price'],
    };
  }
}
```

---

## 🚀 **Deployment Migration | ترحيل النشر**

### **1. Build Configuration Update**
```yaml
# pubspec.yaml
version: 2.0.0+2  # Update version number

# Update build numbers
# Android: android/app/build.gradle
# iOS: ios/Runner/Info.plist
```

### **2. App Store Migration**
```bash
# Build new version
flutter build appbundle --release
flutter build ios --release

# Upload to stores
# Google Play Console
# App Store Connect
```

---

## ✅ **Migration Checklist | قائمة مراجعة الترحيل**

### **Pre-Migration**
- [ ] Backup current codebase
- [ ] Document current functionality
- [ ] Test current app thoroughly
- [ ] Check Flutter version compatibility
- [ ] Review breaking changes documentation

### **During Migration**
- [ ] Update Flutter version
- [ ] Update dependencies
- [ ] Fix compilation errors
- [ ] Update deprecated APIs
- [ ] Test on different devices
- [ ] Update documentation

### **Post-Migration**
- [ ] Run full test suite
- [ ] Test on production data
- [ ] Monitor app performance
- [ ] Update user documentation
- [ ] Deploy to staging environment
- [ ] Deploy to production

---

## 🔗 **الروابط ذات الصلة | Related Links**

- [دليل حل المشاكل](27_Troubleshooting.md)
- [قوائم المراجعة والمرجع السريع](29_Checklists_Reference.md)
- [إعداد المشروع والتكوين](02-Implementation/07_Project_Setup_Config.md)

---

## 📚 **المراجع | References**

- [Flutter Migration Guide](https://docs.flutter.dev/release/breaking-changes)
- [Dart Migration Guide](https://dart.dev/null-safety/migration-guide)
- [Flutter Upgrade Guide](https://docs.flutter.dev/development/tools/sdk/upgrading)

---

**🔴 ENHANCEMENT**: محتوى مأخوذ من الوثائق الأصلية  
**🔵 SUGGESTION**: اقتراحات مبنية على الخبرة التقنية

---

## 🔗 **Navigation | التنقل**

[← Previous: Troubleshooting | السابق: دليل حل المشاكل](27_Troubleshooting.md)
[Next: Checklists Reference | التالي: مرجع القوائم المرجعية →](29_Checklists_Reference.md)
[🏠 Home | الرئيسية](../../index.html)

---
