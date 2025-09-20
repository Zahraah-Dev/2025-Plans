# **لمعرفة مستوئ بنية التطبيق flutter**

# **1\) الهيكل المعماري (Architecture)**

* طبقات واضحة مفصولة: Presentation (UI) / Domain (Use-Cases, Entities) / Data (Repositories, Data-sources).  
* إدارة حالة موحّدة عبر المشروع (Bloc/Cubit أو Riverpod) بدون خلط المنطق داخل الـWidgets.  
* حقن تبعيات (DI) باستخدام get\_it أو Riverpod providers—ولا يوجد new داخل الطبقات العليا.  
* كل ميزة (Feature) داخل Module/Package خاص بها: `features/catalog/…`, `features/cart/…`  
* العقود أولاً: تعريف واجهات Repositories في الـDomain وتنفيذها في الـData.  
  **اختبار سريع:** ابحث عن كلمة `http` و`SharedPreferences`—يجب ألّا تظهر في UI/Bloc بل داخل Data-sources فقط.

# **2\) بنية المشروع والملفات**

مسارات ثابتة:  
`lib/`  
  `core/ (errors, utils, theming, config)`  
  `features/`  
    `auth/`  
      `presentation/`  
      `domain/`  
      `data/`  
    `catalog/`  
    `cart/`  
  `app.dart (root)`  
  `main_[env].dart`

*   
* لا ملفات “عملاقة”: أي ملف \> 300 سطر يحتاج تفكيك.  
* أسماء بديهية، وتعليقات قصيرة للمقاطع المعقّدة فقط.  
  **اختبار سريع:** احسب عدد الطبقات داخل `features/*`—يجب أن تراها الثلاث (presentation/domain/data) لكل ميزة.

# **3\) الجودة الساكنة (Linting & Style)**

* مفعّل: `flutter_lints` أو `very_good_analysis` \+ Formatter افتراضي.  
* لا تحذيرات Lint في CI.  
* كوميتات قصيرة بمعيارية (Conventional Commits).  
  **أوامر:**  
  `flutter analyze` يجب أن يعود صفر أخطاء.  
  `dart format --output=none --set-exit-if-changed .` في CI.

# **4\) الاختبارات والتغطية**

* Unit Tests لطبقة Domain (Use-Cases) و Repositories.  
* Widget Tests للـUI الأساسية (القوائم/التفاصيل/السلة).  
* Integration/E2E (مثل Patrol/Flutter Driver/Integration Test) لتدفق شراء كامل.  
* حد أدنى للتغطية: **≥ 60%** الآن (ارفعه تدريجيًا إلى 80%).  
  **أوامر:**  
  `flutter test --coverage` ثم راجع `lcov.info`.

# **5\) الأداء والقياسات (Performance Budgets)**

* وقت تشغيل أولي (cold start): **\< 2.5s** على أجهزة متوسطة.  
* حجم APK/IPA: **\< 30–40MB** (بدون موارد مفرطة).  
* FPS مستقر في الشاشات الثقيلة (\> 55fps).  
* استهلاك ذاكرة منضبط وعدم تسريبات (راقب عبر DevTools).  
  **أوامر:** استخدم Flutter DevTools (CPU, Memory, Performance) \+ Profile mode.

# **6\) الشبكة والـAPI**

* طبقة Network موحّدة (Dio/Http) مع Interceptors: Auth, Retry, Logging (غير فعّال في الإنتاج).  
* معالجة أخطاء موحّدة (Failure types) ورسائل مستخدم ودّية.  
* Timeouts محددة \+ Retry/backoff.  
* الـModels مولّدة (json\_serializable) وليس “يدوي”.  
  **اختبار سريع:** افصل الإنترنت وتأكد من رسائل الأخطاء وسلوك Retry.

# **7\) الاعتمادات والبيئات (Config & Secrets)**

* ملفات بيئة منفصلة: `main_dev.dart`, `main_prod.dart` \+ `lib/core/config/app_config.dart`.  
* لا أسرار داخل الكود/الـrepo (استخدم مفاتيح من CI/CD أو Firebase Remote Config).  
* Feature Flags لتفعيل/إيقاف ميزات دون إطلاق نسخة جديدة.

# **8\) الاعتمادية والمرونة (Offline & Caching)**

* سياسة Cache واضحة (Hive/Isar/Sqflite) للمنتجات والسلة.  
* Offline-first لصفحات رئيسية (تعامل لطيف مع انقطاع الشبكة).  
* مزامنة مؤجلة (Queued writes) إن لزم.

# **9\) الرصد والأعطال (Observability)**

* Crashlytics مفعّل مع تتبّع الإصدارات (release channel, build number).  
* سجلات (Logs) مضبوطة عبر wrapper مركزي (Info/Warning/Error) وتُغلق بالـrelease.  
* مؤشرات صحة: Crash-free sessions **≥ 99.5%**، ANR منخفضة، أخطاء الشبكة أقل من **2%** من الطلبات.

# **10\) الأمان والخصوصية**

* عدم تسجيل أو عرض أي PII في السجلات.  
* TLS إلزامي، التحقق من الشهادات إن أمكن.  
* حماية مفاتيح الطرف الثالث، ومراجعة أذونات التطبيق (لا تطلب ما لا تحتاجه).  
* حماية الروابط العميقة/المعطيات القادمة من خارج التطبيق (validation).

# **11\) واجهة المستخدم (UX/UI) و i18n/a11y**

* Theme موحّد (Light/Dark) وخامات تصميم ثابتة (Spacing, Radius, Typography).  
* i18n مفعّل (ARB/Intl) دون نصوص صلبة داخل الأكواد.  
* توافق إمكانية الوصول (TextScale, Semantics, Contrast).

# **12\) التحليلات والمنتج (Analytics)**

* تعريف Event Map موحّد (اسم الحدث، المعاملات، متى يُطلق).  
* عدم تكرار الأحداث، واستخدام User Properties مهمة (المدينة/القناة عند احترام الخصوصية).  
* ربط Funnel للشراء: عرض منتج → إضافة للسلة → بدء الدفع → تأكيد الطلب.  
* تحقق دوري من اتساق الأرقام بين Firebase/GA4 وبيانات الخادم.

# **13\) الأتمتة والإطلاق (CI/CD)**

* بايبلاين:  
  1. Format & Lint  
  2. Tests \+ Coverage Gate  
  3. Build (dev/stage/prod)  
  4. Signing/Versioning آلي  
  5. توزيع داخلي (Firebase App Distribution/TestFlight)  
* Changelog تلقائي، وRelease Tags واضحة.  
* فحوصات صحية بعد الإطلاق (Post-release checklist).

# **14\) الوثائق والحَوْكمة**

* README هندسي يشرح التشغيل، البنية، وكيفية إضافة Feature.  
* قرارات معمارية قصيرة (ADR) لكل قرار مهم.  
* دليل مساهمة (CONTRIBUTING) \+ معايير Code Review.  
* خريطة تبعيات خارجية وتبريرها.

---

## **خطة تدقيق عملية (3 أيام عمل)**

**اليوم 1:**

* فحص البنية والطبقات \+ هيكل الملفات \+ Lint/Analyze \+ Secrets/Config.  
  **المخرجات:** تقرير سريع مع 10 ملاحظات ذات أولوية.

**اليوم 2:**

* اختبارات (نِسَب، تغطية)، أداء (DevTools)، شبكة/أخطاء، Offline.  
  **المخرجات:** أرقام (start time، FPS، حجم build، معدل أخطاء API).

**اليوم 3:**

* Observability (Crashlytics)، Analytics map، CI/CD، UX/i18n/a11y.  
  **المخرجات:** قائمة تحسينات \+ حدود قياسية (budgets) \+ جدول تنفيذ.

---

## **معايير قبول مبسطة (OKRs تقنية)**

* **تحذيرات Lint:** صفر في الفرع الرئيسي.  
* **تغطية:** ≥ 60% الآن (خطة للوصول 80%).  
* **Start time:** ≤ 2.5s (Android متوسط).  
* **Crash-free:** ≥ 99.5% آخر 7 أيام.  
* **حجم التطبيق:** ≤ 40MB.  
* **أحداث التحليلات:** تطابق ≥ 95% مع الـBackend.

---

## **اختبار ذاتي سريع (نعم/لا)**

1. هل يمكن استبدال طبقة API دون لمس UI؟  
2. هل أي Widget لا يتجاوز 200-300 سطر؟  
3. هل الأخطاء تُترجم إلى Failures موحّدة برسائل ودّية؟  
4. هل يمكنك تشغيل `flutter test` والحصول على تغطية؟  
5. هل توجد بيئات Dev/Stage/Prod منفصلة؟  
6. هل أي سرّ غير موجود في الكود؟  
7. هل يمكن تعطيل/تمكين ميزة عن بعد؟  
8. هل لديك Dashboard للأعطال والأداء؟  
9. هل Funnel الشراء مضبوط ومُراجع أسبوعيًا؟  
10. هل البيلد يتم بالكامل من CI بدون خطوات يدوية؟


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
