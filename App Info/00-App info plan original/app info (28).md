**التدفق العام:**

المستخدم  
│  
▼  
Flutter App (UI/State/Cache/Networking)  
│ HTTP/GRPC \+ Auth \+ Retry/Backoff \+ DL/Push  
▼  
API Gateway (Rate limit, AuthZ, Observability)  
▼  
Micro/Services (Catalog, Cart, Checkout, Payments, Orders, CMS, RMA, Loyalty)  
▼  
Datastores (SQL/NoSQL, Search, Cache) — CDN/Media — Queue/Events  
▼  
Observability (Logs/Metrics/Traces), CI/CD, Feature Flags, Analytics

**أهداف التصميم:** قابلية التوسّع، الاستقرار، الأداء (P50/P95)، تجربة متسقة، أمان وخصوصية، سهولة التطوير والصيانة.

---

# **1\) تصميم الواجهة في (App Architecture)**

## **1.1 هيكلة المشروع (Modularization)**

* **Feature-first**: `features/<feature>/presentation|domain|data` \+ طبقات مشتركة `core/`.  
* **Layered داخل كل ميزة**:  
  * `presentation`: Widgets, Pages, `go_router`, ViewModels/Bloc.  
  * `domain`: UseCases, Entities, Repositories (interfaces).  
  * `data`: Repositories (impl), DataSources (remote/local), DTOs, Mappers.  
* **core/**: ثوابت، أخطاء، Network, DI, Theming, Localization, Analytics.

## **1.2 إدارة الحالة (State Management)**

* توصية: **Bloc/Cubit** أو **Riverpod** (مع ProviderScope)، مع فصل العرض عن المنطق.  
* عقود واضحة بين `View ↔ ViewModel/Bloc ↔ UseCase`.  
* Events/States قابلة للاختبار \+ عدم تمرير BuildContext داخل الطبقات المنطقية.

## **1.3 التنقّل (Navigation)**

* **go\_router** مع أسماء مسارات ثابتة، ودعم `deep-link` و`state restoration`.  
* رسم **Graph** للرحلات الحرجة (Onboarding → Auth → PLP → PDP → Cart → Checkout → Orders).

## **1.4 DI/Config**

* **get\_it** (أو Riverpod DI) لحقن الاعتماديات.  
* ملفات **flavors**: `dev`, `staging`, `prod` (مع Bundle IDs مختلفة).

## **1.5 الثيم/الوصولية/التعريب**

* Theme موحّد (Light/Dark)، مقاسات تفاعلية ≥48dp، تباين WCAG AA.  
* `intl` للتعريب (AR/EN)، RTL مدعوم، تنسيقات أرقام/عملات.

---

# **2\) طبقة البيانات داخل التطبيق (Data Layer)**

## **2.1 الشبكات (Networking)**

* **Dio** \+ Interceptors: Auth (Bearer/OTP), Retry with exponential backoff \+ jitter, Logging (مراعاة الخصوصية).  
* **Idempotency** لعمليات الشراء/الدفع، **Circuit Breaker** عند الأعطال المتكررة.

## **2.2 التخزين المحلي والكاش (Offline/SWR)**

* محركات: **Isar/Drift/Hive**؛ اختيار واحد حسب الاحتياج.  
* سياسة **stale-while-revalidate**: عرض من الكاش ثم تحديث صامت.  
* **TTL Matrix** لكل نوع بيانات (PLP/PDP/Cart/Configs).

## **2.3 DTOs/Mappers/Errors**

* فصل DTOs عن Entities، توحيد أخطاء المجال: `NetworkError | AuthError | BusinessError | Unknown`.

---

# **3\) تجربة الأخطاء والمرونة (Resilience & Error UX)**

* **Error Catalog** موحّد (HTTP/Business) مع رسائل AR/EN، وإجراءات retry/fallback.  
* مكوّن UI موحّد للأخطاء \+ **Golden tests** لثبات التصاميم.  
* سيناريوهات: ضعف الشبكة/مهلة/401/409/422/نفاد مخزون/رفض دفع.

**قالب جدول Error Catalog**

| module | http\_status | error\_code | user\_msg\_ar | user\_msg\_en | severity | retry | telemetry | fallback\_ui |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| checkout | 402 | PAY\_3DS\_FAIL | فشل التحقق البنكي… | Bank 3DS failed… | high | retry\_once | pay\_3ds\_fail | info\_banner |

---

# **4\) الأداء (Performance)**

* **ميزانيات**: Cold Start P50/P95، PLP render، PDP ready، Checkout step.  
* تتبّع **jank** (raster/build times)، استخدام Isolates للأعمال الثقيلة.  
* صور: `cached_network_image` \+ `precacheImage` \+ WebP/AVIF \+ أحجام مناسبة.  
* قوائم كبيرة: `ListView.builder`, `Slivers`, تجنّب العمل الثقيل في build.

**قالب Performance Budgets**

| السيناريو | P50 | P95 | ملاحظات |
| ----: | ----: | ----: | ----: |
| Cold start (to first paint) | 1.5s | 3.5s | defer non-critical, prewarm |
| PLP initial render | 0.9s | 2.0s | skeleton \+ SWR |
| PDP ready to interact | 1.0s | 2.2s | lazy images |

---

# **5\) الأمان والخصوصية (Security & Privacy)**

* **Secure Storage** للتوكينات (Keychain/Keystore) \+ Masking للـ logs.  
* **TLS** محدث؛ (اختياري) Certificate Pinning بحذر.  
* كشف Root/Jailbreak (تحذير/تقليل صلاحيات)، Play Integrity/App Attest (عند الحاجة).  
* سياسات لقطات الشاشة للشاشات الحساسة (اختياري)، ATT على iOS عند التتبع.

---

# **6\) التحليلات والقياس (Analytics & Event Schema)**

* مخطط أحداث موحّد **GA4/Firebase**: `open → view_item_list → view_item → add_to_cart → begin_checkout → add_payment_info → purchase`.  
* تعيين `user_id` \= معرف العميل، ربط الأجهزة/الشرائح.

**قالب Event Schema**

| event | params | when |
| ----: | ----: | ----: |
| view\_item | item\_id, price, cat\_id | عند فتح PDP |
| add\_to\_cart | item\_id, qty, price | عند إضافة للسلة |
| purchase | tr\_id, value, items | نجاح الدفع |

---

# **7\) الإشعارات والروابط العميقة (Push & Deep Links)**

* **FCM**: إدارة tokens، قنوات Android، foreground/background/terminated.  
* **Dynamic Links/OneLink**: روابط مؤجّلة لفتح PDP/PLP/Cart/Order.

**قالب Deep Link Matrix**

| type | route | required\_params | fallback | analytics |
| ----: | ----: | ----: | ----: | ----: |
| PDP | /p/:id | id | /home | dl\_open\_pdp |

---

# **8\) الرايات والتجارب (Feature Flags & A/B)**

* **Remote Config** لمفاتيح الميزات الحساسة \+ تجارب A/B.  
* توثيق دورة حياة العلم (create → roll → measure → retire).

---

# **9\) إعداد البيئات (Flavors & Config)**

* Flavors: dev/staging/prod، مفاتيح/Endpoints/Analytics منفصلة.  
* رمز/أيقونة/اسم للتطبيق لكل بيئة، ومنع خلط حسابات الإنتاج.

---

# **10\) CI/CD وخط النشر (Codemagic مثال)**

**المراحل:** Lint/Format → Unit/Widget/Golden → Integration/E2E → Build & Size → Sign & Upload → Release Gate.

* **بوابات قبول**: تغطية اختبارية، ميزانيات الأداء، لا أعطال حرجة، موافقة QA.  
* تقارير JUnit/Coverage/Screenshots artifacts، طرح تدريجي (rollout%).

---

# **11\) هرم الاختبارات (Testing Pyramid)**

* **Unit**: المرافق/الفالديشن/UseCases.  
* **Widget/Golden**: ثبات الواجهة وحالات الخطأ.  
* **Integration/E2E**: الرحلات الحرجة (Auth, PLP→PDP→Cart→Pay→Order).  
* **Contract tests** مع API، **Network mocking**، **Screenshot tests** (AR/EN, Light/Dark)، **A11y tests**.

**Matrix الأجهزة/الشبكات**

| os | versions | devices | locales | theme | network |
| ----: | ----: | ----: | ----: | ----: | ----: |
| iOS | 16–18 | small/large | ar/en | dark/light | 3G/poor/wifi |
| Android | 10–14 | low/mid/high | ar/en | dark/light | 3G/poor/wifi |

---

# **12\) المراقبة والتشغيل (Observability & Ops)**

* Crashlytics/Sentry \+ Logs \+ Performance \+ Dashboards.  
* **SLO/Alerts**: Crash-free sessions، Start-up P95، Checkout Conversion.  
* **Runbooks**: Incident, Rollback, Hotfix.

**قالب SLO/Alerting**

| metric | threshold | window | owner | channel | auto\_stop\_rollout |
| ----: | ----: | ----: | ----: | ----: | ----: |
| Crash-free | \<98.5% | 1h | Mobile Lead | Slack/Email | ✔ |
| Checkout Δ | −15% vs prev | 2h | PM \+ Eng | Slack | ✔ |

---

# **13\) المتجر والإصدار (Store & Release)**

* أصول المتاجر (لقطات/أيقونات/Privacy labels)، in\_app\_review، in\_app\_update (Android).  
* سياسة دعم الإصدارات (N-1/N-2)، ردود المراجعات، خطّة الطرح التدريجي.

---

# **14\) قوالب جاهزة للاستخدام**

## **14.1 بنية مجلدات (مثال)**

lib/  
core/  
config/ (env, flavors)  
errors/  
network/ (dio, interceptors)  
di/  
theme/  
l10n/  
analytics/  
features/  
catalog/  
presentation/  
domain/  
data/  
product/  
cart/  
checkout/  
orders/  
account/  
app.dart  
main\_dev.dart  
main\_staging.dart  
main\_prod.dart

## **14.2 قالب README داخلي**

* نظرة عامة  
* إعداد البيئة (flavors, keys)  
* تشغيل الاختبارات  
* أسلوب الكود (lint/format)  
* كيفية إضافة ميزة جديدة (skeleton)  
* مراقبة/لوحات

---

# **15\) مسار التنفيذ (Roadmap مختصر)**

1. Foundation: Network/DI/Flavors/Theme/L10n/Error+Cache policies.  
2. Flows: PLP → PDP → Cart → Checkout → Orders → RMA/Wallet.  
3. 3P: Firebase (Core+Analytics+Crash+Perf+RC+FCM) → Attribution → Payments → Maps/Media.  
4. Hardening: Performance, A11y, Security, Tests, SLO/Alerts.  
5. Launch: Store assets, Beta, Rollout, Support.

هذا الدليل يُستخدم كمرجع سريع \+ قائمة تشغيل (Playbook). عند البدء بكل ميزة، اربطها بجدول: **المدخلات/المخرجات، أخطاء متوقعة، أحداث تحليلية، حالات اختبار، ميزانيات الأداء**.

# **16\) قائمة تحقق نهائية (Definition of Done)**

**الغرض:** تحديد معايير قبول دقيقة وقابلة للقياس قبل الانتقال من مرحلة إلى التي تليها (Foundation → Flows → 3P → Hardening → Launch).

## **\- بوابات القبول العامة (Gates)**

## **\- أدلة الإثبات المطلوب إرفاقها (Artifacts)**

* **تقارير اختبار**: JUnit \+ تغطية \+ لقطات Golden/Screenshot tests.  
* **لوحات قياس**: Firebase DebugView للقناة التجريبية \+ لوحة Crashlytics \+ Firebase Performance.  
* **سجلات E2E**: فيديو قصير (اختياري) لكل رحلة حرجة على iOS/Android.  
* **نتائج أداء**: Export لمقاييس P50/P95 لكل سيناريو (Start/PLP/PDP/Checkout).  
* **أمن/خصوصية**: لقطات تكوين secure storage، فحص repo لعدم وجود أسرار، سياسة ATT/Permissions.  
* **جاهزية المتجر**: رابط داخلي لـ TestFlight/Play Internal \+ قائمة تحقق ما قبل الإرسال.

## **15.3 DoD تفصيلي لكل وحدة رئيسية**

### **\- الشبكات/التهيئة (Networking & Config)**

### **\- الهوية والجلسة (Auth/Session)**

### **\- الكتالوج/PLP**

### **\- صفحة المنتج/الوسائط (PDP/Media)**

### **\- السلة/الكوبونات (Cart/Coupons)**

### **\- الدفع (Checkout/Payments)**

### **\- الطلبات/المرتجعات/المحفظة (Orders/RMA/Wallet)**

### **\- الإشعارات والروابط العميقة (Push & Deep Links)**

### **\- التحليلات والتجارب (Analytics & A/B)**

### **\- الأداء والذاكرة (Performance & Memory)**

### **\- الوصولية والتعريب (A11y & i18n)**

### **\- الأمان والخصوصية (Security & Privacy)**

### **\- CI/CD والإصدار (CI/CD & Release)**

## **15.4 قالب توقيع الاعتماد (Sign‑off Template)**

| البند | المالك | الدور | القرار | التاريخ | ملاحظات |
| ----- | ----- | ----- | ----- | ----- | ----- |
| DoD – المرحلة الحالية | Eng Lead | تقنية | ✅/❌ | YYYY‑MM‑DD |  |
| DoD – QA/UAT | QA Lead | جودة | ✅/❌ | YYYY‑MM‑DD |  |
| DoD – Product | PM | منتج | ✅/❌ | YYYY‑MM‑DD |  |

---

## **15.5 ملاحق تفصيلية (تكملة البنود)**

هذا الملحق يملأ أي عناوين كانت ظاهرًا دون تفاصيل، ويُستخدم كمرجع تنفيذ مباشر.

### **\- Runbooks/Playbooks (مُفصّلة)**

* **RB‑INCIDENT (حوادث Sev1–Sev3):**  
  1. تشكيل غرفة طوارئ (PM+Eng+Ops) خلال ≤10 دقائق.  
  2. تجميد النشر وبدء قياس الأثر (المناطق/الإصدارات/الأجهزة).  
  3. عزل السبب (API vs App vs 3P) عبر اللوحات والسجلات.  
  4. تخفيف الأثر (Feature Flag OFF / Kill‑Switch / Banner تنبيهي داخل التطبيق).  
  5. توثيق Post‑mortem خلال 48 ساعة مع إجراءات منع التكرار.  
* **RB‑ROLLBACK:**  
  1. إيقاف Rollout% الحالي. 2\) إعادة تفعيل الإصدار السابق (N‑1). 3\) التحقق من SLOs. 4\) فتح تذكرة Root‑Cause.  
* **RB‑HOTFIX:**  
  1. فرع hotfix من الإصدار الحالي. 2\) اختبارات سريعة (Unit/Widget/Smoke). 3\) رفع Beta مغلقة. 4\) نشر تدريجي مع مراقبة.

### **\- Store & Release (اكتمال المتجر)**

* **App Store/Play:** لقطات محلية AR/EN، أيقونات، Privacy labels، وصف مختصر/طويل، كلمات مفتاحية.  
* **Beta:** TestFlight/Play Internal مع تعليقات داخلية، صفحة ملاحظات الإصدار.  
* **طرح تدريجي:** 5% → 25% → 50% → 100% مع عتبات إيقاف تلقائي (Crash‑free \<98.5% أو −15% تحويل).  
* **الرد على المراجعات:** نماذج ردود، تحويل الشكاوى إلى تذاكر دعم.

### **\- Feature Flags Lifecycle**

* تعريف العلم: المالك، نطاق التأثير، خطة رجوع.  
* تجزئة الجمهور: نسبة/خصائص (دولة/نسخة/لغة).  
* قياس: أحداث نجاح/فشل، نافذة قياس، معايير إغلاق.  
* تقاعد العلم: تنظيف الكود خلال ≤2 سبوع بعد القرار.

### **\- Security & Privacy (تفصيلي)**

* **Tokens:** تخزين عبر Keychain/Keystore (flutter\_secure\_storage)، منع النسخ الاحتياطي، دوران توكن.  
* **Logs:** حذف/إخفاء PII، تعطيل logging في الإنتاج، حدود حجم السجل.  
* **Permissions/ATT:** شروحات، مسارات بديلة عند الرفض، طلب ATT فقط عند الحاجة.  
* **Network:** TLS حديث، (اختياري) Certificate Pinning بحذر، مهلات معقولة.  
* **Integrity:** Play Integrity/App Attest للعمليات الحرجة (دفع/ولاء).

### **\- Flavors & Config**

* **flavors:** dev/staging/prod مع Bundle Ids مختلفة، اسم/أيقونة مميزة.  
* **Config:** مفاتيح/Endpoints منفصلة، Analytics stream لكل بيئة، منع مزج بيانات الإنتاج.

### **\- Data Layer (خيارات محلية)**

* اختيار **Isar** للكاش السريع وأوفلاين، أو **Drift** لو جداول/علاقات معقدة.  
* سياسة TTL/Invalidation لكل كيان (PLP/PDP/Cart/Config).  
* ترقية المخطط (migrations) موثقة ومختبرة.

### **\- Networking Interceptors**

* **Auth:** إدراج Bearer/OTP، تجديد تلقائي عند 401 (مرة واحدة).  
* **Retry:** Exponential backoff \+ jitter، حظر إعادة محاولات غير idempotent.  
* **Idempotency:** Header/Key لخطوات الدفع.  
* **Logging:** إخفاء الحقول الحساسة، تعطيل أجسام الاستجابات في الإنتاج.

### **\- Analytics Mapping (GA4)**

* `view_item_list(cat_id, list_id)` عند PLP.  
* `view_item(item_id, price, cat_id)` عند PDP.  
* `add_to_cart(item_id, qty, price)` عند الإضافة.  
* `begin_checkout(value)` عند بدء الدفع.  
* `purchase(tr_id, value, items[])` عند نجاح الدفع.

### **\- Deep Links Matrix (أمثلة مكتملة)**

| type | route | required | optional | fallback | analytics |
| ----: | ----: | ----: | ----: | ----: | ----: |
| PDP | /p/:id | id | ref | /home | dl\_open\_pdp |
| PLP | /c/:id | id | sort | /home | dl\_open\_plp |
| Search | /s | q | sort | /s?q= | dl\_open\_search |
| Cart | /cart | — | coupon | /home | dl\_open\_cart |
| Order | /o/:id | id | — | /orders | dl\_open\_order  |

### **\- Performance Budgets (أرقام نهائية)**

* **Cold Start:** P50 ≤ 1.5s، P95 ≤ 3.5s.  
* **PLP:** P50 ≤ 0.9s، P95 ≤ 2.0s.  
* **PDP:** P50 ≤ 1.0s، P95 ≤ 2.2s.  
* **Checkout Step:** P95 ≤ 1.5s لشاشة.

### **\- Testing Matrices**

* **تغطية:** وحدات ≥80% للطبقات الحرجة؛ Golden للشاشات الستة الأساسية.  
* **أجهزة:** iOS (16–18) small/large، Android (10–14) low/mid/high، AR/EN، داكن/فاتح، شبكات 3G/ضعيفة/Wi‑Fi.

### **\- Alerting & SLOs**

* **Crash‑free:** \<98.5% (1h) → تنبيه Critical \+ إيقاف طرح.  
* **Start‑up P95:** \>3.5s (1h) → تنبيه Warning.  
* **Checkout Conversion Δ:** −15% مقابل الإصدار السابق (2h) → Critical.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
