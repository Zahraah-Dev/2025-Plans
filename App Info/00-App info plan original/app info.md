# **1\) تقسيم طبقات نظيف (Clean Layers)**

**القاعدة:** افصل بين **Presentation** (UI), **Application** (State/Use-cases), **Domain** (Entities), **Data** (Repos & Sources).  
**الفائدة:** سهولة الاختبار، تقليل الترابط، تبديل المصادر أو التصميم بدون تكسير.  
**التطبيق السريع:**

`/lib`  
  `/features`  
    `/catalog/ (UI + controllers + repo + models لهذه الميزة فقط)`  
    `/cart/`  
    `/checkout/`  
  `/core`  
    `/domain/ (entities, value_objects)`  
    `/data/   (http_client, local_db, cache)`  
    `/app/    (router, theme, l10n, di, errors, result)`

# **2\) إدارة الحالة وحقن الاعتماديات (State & DI)**

**القاعدة:** استخدم **Riverpod** (أو Bloc—اختر واحدًا وثبّته) \+ DI عبر Providers.  
**الفائدة:** إعادة بناء Widgets بذكاء، اختبارات سهلة، وتجنّب Singleton العشوائي.  
**التطبيق:**

* `ProviderScope` في `main.dart`.  
* `StateNotifier` لكل منطق ميزة (CartController, AuthController…).  
* `Provider` لواجهات Repos، و`Provider` لعملاء الشبكة/التخزين.

# **3\) نماذج غير قابلة للتغيير (Immutable Models)**

**القاعدة:** استخدم **freezed** \+ **json\_serializable** للكيانات ونتائج API.  
**الفائدة:** كود أقل \+ أمان أكبر \+ مساواة وقيم منسوخة (`copyWith`).  
**التطبيق:** `@freezed` للـEntities (`Product`, `CartItem`, `User`) \+ توليد `fromJson/toJson`.

# **4\) طبقة المجال (Domain) أولًا**

**القاعدة:** كل ميزة لها **Use-cases** (دوال/كلاسات) تعمل على **Entities** وواجهة **Repository**.  
**الفائدة:** واجهة واضحة للـUI؛ تغيّر الـAPI لا يلمس الواجهة.  
**التطبيق:**

* `GetProductList()`, `AddToCart()`, `PlaceOrder()`…  
* `abstract class CatalogRepo { Future<Result<List<Product>>> getProducts(...); }`

# **5\) طبقة البيانات (Data) مع Result/Failure**

**القاعدة:** لا ترمي Exceptions للأعلى؛ أرجِع `Result<Success, Failure>`.  
**الفائدة:** تعامل موحّد مع الأخطاء في UI (شبكة/سيرفر/تحقق/ذاكرة).  
**التطبيق:**

* `sealed class AppFailure { Network(); Server(msg); Cache(); Auth(); Validation(msg); }`  
* `typedef Result<T> = Either<AppFailure, T>;`

# **6\) التوجيه (Routing) والوحدات**

**القاعدة:** استخدم **go\_router** مع حراس (Guards) مبسّطة، وسمِّ المسارات بوضوح.  
**الفائدة:** Deep-link داخلي بسيط، أكواد أقل، تنقّل يمكن اختباره.  
**التطبيق:**

* `/`, `/catalog`, `/product/:id`, `/cart`, `/checkout`, `/orders`.  
* Guard خفيف للتحقق من تسجيل الدخول قبل `/checkout`.

# **7\) تصميم نظام (Design System) موحّد**

**القاعدة:** Theme واحد \+ Tokens (ألوان/هوامش/زوايا/Typography) \+ Widgets مشتركة (Buttons, Cards…).  
**الفائدة:** شكل ثابت وسهل التغيير، تقليل التكرار.  
**التطبيق:**

* `AppTheme`: light/dark، أحجام خط متدرجة، مكوّنات جاهزة.  
* `Spacing.xs/s/m/l/xl`, `Radius.s/m/l`, `Elevation.s/m/l`.

# **8\) التعدد اللغوي وRTL**

**القاعدة:** فعّل **l10n** بملفات `.arb`، وادعم RTL افتراضيًا (العربية).  
**الفائدة:** نصوص منظّمة، سهولة ترجمة، تجربة عربية سليمة.  
**التطبيق:**

* `flutter gen-l10n`, مفاتيح مثل `product_title`, `add_to_cart`.  
* اختبر تكبير الخط و`TextDirection.rtl`.

# **9\) التخزين المحلي وCache**

**القاعدة:** افصل **Cache** عن **State**؛ استخدم **Hive/Drift** أو SharedPreferences للخفيف.  
**الفائدة:** فتح سريع دون شبكة \+ عمل أوفلاين أساسي.  
**التطبيق:**

* Cache للـcatalog لمدة N دقائق، وسلة محليّة دائمة.  
* سياسة: Stale-While-Revalidate (اعرض القديم ثم حدّث بصمت).

# **10\) الشبكة والمرونة**

**القاعدة:** عميل واحد (مثلاً **Dio**) مع Interceptors، وإعادة محاولة **Exponential Backoff**.  
**الفائدة:** قِوة ضد مشاكل الشبكة وشفافية سجلات.  
**التطبيق:**

* Timeout موحّد، توحيد رؤوس الطلبات (Headers)، فحص اتصال `connectivity_plus`.  
* صف انتظار للطلبات الحرِجة (Queue) عند فقد الشبكة ثم إرسال لاحقًا (idempotency key).

# **11\) معالجة الأخطاء وتجربة المستخدم**

**القاعدة:** شاشة أخطاء ودية \+ Snackbars مخصّصة لكل خطأ Domain.  
**الفائدة:** فهم المستخدم للمشكلة دون ضياع.  
**التطبيق:**

* Global `FlutterError.onError` \+ `runZonedGuarded` مع تسجيل.  
* خرائط: `Network → “تأكد من الشبكة”`, `Auth → “سجّل دخولك”`, `Validation → رسائل حقول`.

# **12\) الأداء**

**القاعدة:** استخدم `const` حيثما أمكن، قسّم Widgets، تجنّب العمل الثقيل على الـUI thread.  
**الفائدة:** سلاسة (FPS ثابت) واستهلاك أقل.  
**التطبيق:**

* قوائم كبيرة: `ListView.builder/Slivers`, `AutomaticKeepAlive` للمهمات.  
* صور: `cached_network_image` \+ أحجام مناسبة.  
* Debounce للبحث، Throttle للنقرات.

# **13\) التهيئة والتكوين (Config)**

**القاعدة:** `flavors` \+ `dart-define`، وملف `AppConfig` يحقن في `ProviderScope`.  
**الفائدة:** تبديل بيئات ومفاتيح بسهولة بدون لمس الكود.  
**التطبيق:**

* `--dart-define=ENV=prod` → `AppConfig(baseUrl, featureFlags, logLevel)`.

# **14\) الأمان**

**القاعدة:** خزّن الرموز في **flutter\_secure\_storage**، لا تسجّل بيانات حسّاسة، وفكّر في **TLS pinning**.  
**الفائدة:** حماية جلسات المستخدم وتقليل المخاطر.  
**التطبيق:**

* Token في Keystore/Keychain، تنظيفه عند تسجيل الخروج.  
* تنقيح السجلات (لا تطبع Headers/Body الحسّاسة).

# **15\) الاختبارات (Test Pyramid)**

**القاعدة:** هرَم اختبارات: **Unit** (Use-cases, Repos), **Widget** (Screens), **Integration** (رحلة شراء).  
**الفائدة:** ثقة بالتغييرات \+ بُقع أعطال أقل.  
**التطبيق:**

* Mocktail لواجهات Repos، Golden tests للـUI الأساسية، سيناريو Checkout كامل.

# **16\) السجلّات والمراقبة (محليًا)**

**القاعدة:** Logger مركزي بمستويات (debug/info/warn/error) \+ مفاتيح إطفاء.  
**الفائدة:** تتبّع أعطالك محليًا بسرعة أثناء التطوير.  
**التطبيق:**

* `logger` مع Prefix للميزة، طباعة مختصرة في الإنتاج (أو تعطيل).

# **17\) قواعد الترميز والمراجعة**

**القاعدة:** lints صارمة (`flutter_lints`/`very_good_analysis`) \+ `dart format` \+ PR template.  
**الفائدة:** اتساق الكود وسهولة المراجعة.  
**التطبيق:**

* CI بسيط: `analyze`, `test`, `format --set-exit-if-changed`.

---

## **مثال هيكل ميزة (Feature) — “Catalog”**

`/features/catalog`  
  `/presentation`  
    `/pages/ catalog_page.dart`  
    `/widgets/ product_tile.dart`  
    `catalog_controller.dart (StateNotifier)`  
  `/domain`  
    `product.dart  (freezed)`  
    `catalog_repo.dart (abstract)`  
    `usecases/`  
      `get_product_list.dart`  
  `/data`  
    `catalog_repo_impl.dart`  
    `catalog_remote_ds.dart`  
    `catalog_local_ds.dart`

## **نموذج Result/Failure مختصر**

`sealed class AppFailure {`  
  `const AppFailure();`  
  `factory AppFailure.network() = NetworkFailure;`  
  `factory AppFailure.server(String msg) = ServerFailure;`  
  `factory AppFailure.cache() = CacheFailure;`  
  `factory AppFailure.auth() = AuthFailure;`  
  `factory AppFailure.validation(String msg) = ValidationFailure;`  
`}`

`class Result<T> {`  
  `final T? ok;`  
  `final AppFailure? err;`  
  `const Result.ok(this.ok) : err = null;`  
  `const Result.err(this.err) : ok = null;`  
  `bool get isOk => err == null;`  
`}`

## **قائمة “جاهزية الإطلاق” (داخل التطبيق فقط)**

*  الطبقات منفصلة (Presentation/Application/Domain/Data).  
*  Riverpod/Bloc موحّد في كل المزايا \+ DI عبر Providers.  
*  نماذج `freezed` \+ `json_serializable` مفعّلة.  
*  Routing بـ go\_router \+ حراس الدخول.  
*  Cache محلي \+ سياسة Stale-While-Revalidate.  
*  Result/Failure موحّد، بدون Exceptions طافية للـUI.  
*  شاشة أخطاء وSnackbars موحّدة الرسائل.  
*  أداء: const، قوائم مبنية، صور مُخزّنة، بحث مُخفَّض (debounce).  
*  Config عبر flavors و`dart-define`.  
*  أمان: secure storage، سجلات منقّحة.  
*  اختبارات: Unit/Widget/Integration لرحلة Checkout.  
*  Lints \+ CI تحليل/اختبارات.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
