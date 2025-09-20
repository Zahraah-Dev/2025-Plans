# **دليل العمل المتكامل لتطبيق Flutter**

(Architecture \+ Testing \+ CI/CD \+ إصدار)

## **1\) نموذج الفروع (Git) والالتزام**

* **Trunk-based بسيط**  
  * `main` محمي. كل تطوير عبر **feature branches**: `feature/<slug>`، إصلاحات حرجة `hotfix/<slug>`.  
  * **Release tag** لكل إصدار: `vX.Y.Z` (semver) مع **build number** لكل منصة.  
* **Conventional Commits**  
  * `feat: ...`, `fix: ...`, `refactor: ...`, `test: ...`, `chore: ...`, `docs: ...`

**PR Template (مختصر)**  
`الملخص: …`  
`قبل/بعد (صور إن لزم): …`  
`تحقق:`  
`[ ] اتّبعتُ الهيكل (presentation/application/domain/data)`  
`[ ] لا منطق أعمال داخل Widgets`  
`[ ] تغطية اختبار ≥ 70% للوحدة المتأثرة`  
`[ ] RTL/حجوم خط كبيرة تعمل`  
`[ ] flutter analyze & format نظيفة`

* 

## **2\) البيئات والتكوين (Flavors)**

* **Flavors:** `dev` / `staging` / `prod` مع `--dart-define=ENV=prod`.  
* **AppConfig** يُحقن عبر DI (baseUrl, featureFlags, logLevel).  
* **نسخ بيانات الاختبار** داخل `dev` فقط.

## **3\) هرم الاختبارات (Testing Pyramid)**

**الهدف:** نكسر أي كسر قبل أن يصل لواجهة المستخدم.

###  **Unit Tests (A (الطبقة المنطقية/الدومين) — كثيرة ورخيصة**

* تغطي **use-cases, repositories (mock)**، المحوّلات **DTO↔Entity**.  
* أدوات: `flutter_test`, `mocktail`, `freezed`, `json_serializable`.

أمر التشغيل:  
`flutter test --coverage`

### **Widget Tests (B (شاشات/Widgets) — مستوى متوسط**

* تتحقق من العرض والسلوك (زر يضيف إلى السلة، رسائل خطأ).  
* استخدم **golden tests** للّقطات البصرية الأساسية (رؤوس/أزرار).  
* أدوات: `golden_toolkit`.  
* قواعد: لقطات منفصلة لـ RTL وحجم خط كبير.

### **Integration / E2E (C (رحلات رئيسية) — قليلة لكنها ذهبية**

* **سيناريو أساسي:** كتالوج → PDP → إضافة للسلة → Checkout (بدون شبكات خارجية؛ mock لطبقة البيانات).  
* أدوات: `integration_test`.

تشغيل على محاكي:  
`# Android على CI مع emulator`  
`flutter test integration_test -d emulator-5554`

### **D) Performance & Accessibility (خفيفة لكن ثابتة)**

* **Performance budgets:**  
  * App start \< **2.5s**،  
  * بناء PDP \< **200ms**،  
  * Scroll سلس (لا jank ملحوظ).  
* **إتاحة:** عناصر مهمة تحمل `Semantics` وعناوين، دعم RTL وحجوم خط كبيرة.

### **E) حدود الجودة (Quality Gates)**

* تغطية إجمالية ≥ **70%** (Unit+Widget).  
* `flutter analyze` صفر أخطاء، `format` إجباري.  
* اختبارات Integration **للرحلات الحرجة** تمرّ على PRs الكبيرة وعلى كل Release.

## **4\) هيكلة المجلدات للاختبارات**

`/test`  
  `/unit/        // use-cases, repos (mocks)`  
  `/widget/      // شاشات وWidgets`  
  `/goldens/     // baseline snapshots`  
  `/integration_test/  // رحلات أساسية`

## **5\) أدوات الـdev\_dependencies (بدون أرقام إصدارات لتفادي التعارض)**

`dev_dependencies:`  
  `flutter_test:`  
    `sdk: flutter`  
  `integration_test:`  
    `sdk: flutter`  
  `mocktail:`  
  `freezed:`  
  `build_runner:`  
  `json_serializable:`  
  `golden_toolkit:`  
  `very_good_analysis:`

## **6\) CI على GitHub Actions (قابل للتكييف)**

يشغّل التحليلات، التنسيق، الاختبارات (Unit/Widget)، ثم Integration على محاكي Android، ويرفع المخرجات.

`name: CI`

`on:`  
  `pull_request:`  
    `branches: [main]`  
  `push:`  
    `branches: [main]`  
  `workflow_dispatch:`

`jobs:`  
  `analyze-test:`  
    `runs-on: ubuntu-latest`  
    `steps:`  
      `- uses: actions/checkout@v4`  
      `- uses: subosito/flutter-action@v2`  
        `with:`  
          `flutter-version: 'stable'`  
      `- run: flutter pub get`  
      `- run: flutter format --set-exit-if-changed .`  
      `- run: flutter analyze`  
      `- run: flutter test --coverage`  
      `- uses: actions/upload-artifact@v4`  
        `with:`  
          `name: coverage`  
          `path: coverage/lcov.info`

  `integration-android:`  
    `runs-on: ubuntu-latest`  
    `needs: analyze-test`  
    `steps:`  
      `- uses: actions/checkout@v4`  
      `- uses: subosito/flutter-action@v2`  
        `with:`  
          `flutter-version: 'stable'`  
      `- uses: reactivecircus/android-emulator-runner@v2`  
        `with:`  
          `api-level: 31`  
          `arch: x86_64`  
          `script: |`  
            `flutter pub get`  
            `flutter test integration_test -d emulator-5554`

يمكن إضافة Job على `macos-latest` لبناء iOS واختبارات Integration على محاكي iOS إن رغبت.

## **7\) بوابات الدمج (Merge Gates) وحماية الفرع**

* تفعيل **Branch protection** على `main`:  
  * مطلوب **نجاح CI** (الوظيفتين أعلاه).  
  * **مراجعتان** على الأقل، و**CODEOWNERS** للمسارات الحساسة.  
  * منع Push مباشر؛ دمج عبر PR فقط.

## **8\) الإصدار (Release) والنسخ**

* **SemVer:** `MAJOR.MINOR.PATCH`، و**Build number** يزيد كل نشر.  
* **Android:**  
  * `versionName` من `pubspec.yaml`، `versionCode` \= build number.  
  * إصدار Release Debug-gable **ممنوع**.  
* **iOS:**  
  * `CFBundleShortVersionString` \= semver، `CFBundleVersion` \= build.  
* **وسم الإصدار** على Git: `vX.Y.Z` \+ Release notes (ما تغيّر/تصحيحات/تحذيرات).

## **9\) التحقق اليدوي قبل الإصدار (Manual QA Smoke)**

* **RTL \+ تكبير خط** على 2–3 شاشات أساسية.  
* **رحلة Checkout** (بدون خدمات خارجية) تعمل على iOS/Android.  
* **الأداء**: فتح التطبيق أول مرة، فتح PDP، تمرير في قائمة طويلة.  
* **الأخطاء**: شبكات مقطوعة ثم عودة (تجربة Offline/Retry لطيفة).

## **10\) مراقبة وتشغيل (بعد الإصدار)**

* **سجلات محلية** مفعّلة بمستوى INFO في الإنتاج، DEBUG في dev فقط.  
* **بوّابات صحّة داخل التطبيق** (feature flags) لإيقاف شاشة/تجربة إن لزم.  
* **تنبيهات داخلية** (اختياري): عدّادات أعطال/أداء تُعرض في صفحة Debug داخل التطبيق (غير مرئية للمستخدمين).

## **11\) معايير الكود والمراجعة**

* **Lints:** `very_good_analysis` أو `flutter_lints` مع قواعد صارمة.  
* **لا منطق أعمال داخل Widgets** — يجب أن يعيش في StateNotifier/Use-case.  
* **التسمية:**  
  * ملفات: `snake_case.dart`  
  * أصناف: `PascalCase`  
  * متغيرات/دوال: `camelCase`  
  * Widgets: `…Page`, `…View`, `…Tile`

## **12\) جاهزية المهمة واكتمالها (DoR / DoD)**

**Definition of Ready**

*  سيناريوهات قبول وحدود واضحة  
*  واجهات APIs/نماذج محدّثة  
*  تأثير الأداء متوقّع (budgets)  
*  لقطات تصميم/نصوص l10n جاهزة

**Definition of Done**

*  اتّباع الهيكل (feature-first \+ clean layers)  
*  اختبارات Unit/Widget مضافة، Integration لرحلات حرجة  
*  تغطية ≥ 70% للوحدة المتأثرة  
*  analyze/format نظيفان، CI أخضر  
*  README صغير داخل الميزة يشرح القرارات

---

## **13\) قوالب سريعة (جاهزة للنسخ)**

### **A) أمر تشغيل Goldens وتحديثها**

`# تشغيل`  
`flutter test --update-goldens=false`  
`# تحديث baselines عند قبول تغيير تصميم مقصود`  
`flutter test --update-goldens`

### **B) مثال Integration Test (مختصر)**

import 'package:integration\_test/integration\_test.dart';  
import 'package:flutter\_test/flutter\_test.dart';  
import 'package:app/main.dart' as app;

void main() {  
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('journey: catalog → pdp → add to cart → checkout', (tester) async {  
    app.main();  
    await tester.pumpAndSettle();

    // افتح PDP  
    await tester.tap(find.byKey(const Key('catalog.item.0')));  
    await tester.pumpAndSettle();

    // أضف للسلة  
    await tester.tap(find.byKey(const Key('pdp.add\_to\_cart')));  
    await tester.pumpAndSettle();

    // إلى السلة ثم الدفع  
    await tester.tap(find.byKey(const Key('cart.go\_checkout')));  
    await tester.pumpAndSettle();

    // تحقّق عنصر موجود  
    expect(find.byKey(const Key('checkout.item.0')), findsOneWidget);  
  });  
}

### **C) أمر CI للتحقق الكامل محليًا**

`flutter clean && flutter pub get`  
`flutter format --set-exit-if-changed .`  
`flutter analyze`  
`flutter test --coverage`  
`flutter test integration_test -d <DEVICE_ID>`

---

* التزموا بـ **Architecture نظيفة \+ هرم اختبارات \+ CI بسيط** و ستحصلون على بنية مرتبة، تغييرات آمنة، وإصدارات بلا مفاجآت.



---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
