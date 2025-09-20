# **1\) النمط المعماري داخل التطبيق (Clean Architecture \+ MVVM)**

## **لماذا (الفائدة)**

* فصل صارم بين العرض والمنطق والبيانات → سهولة الصيانة والاختبار.  
* قابلية التوسع وإضافة ميزات بدون كسر الشاشات.  
* تقليل الأخطاء بتحديد اتجاه الاعتماديات (Dependencies) بوضوح.

## **ما المطلوب تنفيذه**

* **الطبقات:**  
  * **Presentation:** `View (Screens/Widgets) → ViewModel (State)`  
  * **Domain:** `UseCases` (قواعد العمل الصافية)  
  * **Data:** `Repository` ← `RemoteDataSource (API)` \+ `LocalDataSource (Cache/Storage)`  
* **إدارة الحالة (State):** تبنّي أسلوب موحّد (مثلاً في Flutter: **Riverpod** أو **Bloc**) مع حالات قياسية: `idle / loading / success / error`.  
* **التنقل (Navigation):** تعريف خريطة صفحات وتوجيه موحّد (Routes \+ Deep Links) مع حارس دخول (Auth Guard).  
* **الأخطاء (Error Handling):** نوع خطأ موحّد (Network / Validation / Auth / Unknown) ورسائل عربية جاهزة.  
* **النتائج (Result Type):** كائن نتيجة موحّد (نجاح/فشل) يصل من الـUseCase للـViewModel.  
* **قواعد التسمية:** snake\_case للحقول، أسماء ملفات/مجلدات ثابتة لكل طبقة.  
* **تعقب الأحداث:** نقاط قياس قياسية ضمن الـViewModel (فتح شاشة، إضافة للسلة…) لإرسالها لـAnalytics لاحقًا.

## **Definition of Done (اعتماد)**

* هيكل مجلدات الطبقات موجود وثابت.  
* شاشة نموذجية تعمل عبر المسار الكامل: View → ViewModel → UseCase → Repository → Remote/Local.  
* حالات `loading/success/error` تظهر بصريًا بشكل موحّد.  
* خريطة Routes \+ Deep Links \+ Auth Guard مُعتمدة.  
* اختبارات وحدة لواحد على الأقل من UseCases وViewModels.  
* توثيق موجز (Readme داخلي) يشرح تدفق البيانات ونقاط القياس.

## **تسليمات**

* قائمة الطبقات والمجلدات المطلوبة.  
* قالب State موحّد جاهز (أسماء الحالات والخصائص).  
* جدول رسائل الخطأ العربية القياسية (لكل نوع خطأ).  
* جدول الأحداث القياسية التي سترسل للتحليلات (فتح شاشة/ضغط زر رئيسي).

## **أخطاء شائعة يجب تجنبها**

* استدعاء API مباشرة من الـView → ممنوع (يجب عبر UseCase/Repository).  
* منطق تجاري داخل الـView → يُنقل إلى UseCase.  
* تعدد أنماط إدارة الحالة بين الشاشات → اعتمد أسلوبًا واحدًا.

# **1\) قائمة الطبقات والمجلدات المطلوبة**

هيكلة مرتبة (مقترحة لفلتر/كوتلن/سويفت بنفس الفكرة). لموبايل Flutter مثلًا:

`lib/`  
  `core/                 # أشياء مشتركة`  
    `errors/            # أنواع الأخطاء والمحوّل`  
    `network/           # http client, interceptors, headers`  
    `utils/             # أدوات عامة (formatters..)`  
    `constants/         # ثوابت (currency، مفاتيح..)`  
    `analytics/         # واجهة تتبع الأحداث`  
    `app_check/         # تكامل App Check إن لزم`  
  `config/`  
    `env.dart           # إعدادات البيئة (dev/stg/prod)`  
    `routes.dart        # خريطة التوجيه + الحراس`  
    `theme.dart         # الألوان والخطوط`  
    `localization/      # الترجمة (ar/en)`  
  `data/                # طبقة البيانات`  
    `models/            # DTOs (from/to JSON)`  
    `repositories/      # الواجهات + التنفيذ`  
    `datasources/`  
      `remote/          # استدعاءات API`  
      `local/           # cache/SharedPrefs/DB`  
    `mappers/           # التحويل DTO <-> Domain`  
  `domain/              # طبقة المجال`  
    `entities/          # نماذج المجال (UI-ready)`  
    `usecases/          # قواعد العمل`  
    `repositories/      # عقود الـRepo (Interfaces)`  
  `presentation/        # طبقة العرض`  
    `common_widgets/    # مكوّنات UI قابلة لإعادة الاستخدام`  
    `state/             # قوالب الحالة العامة`  
    `features/          # كل ميزة في مجلد`  
      `home/`  
        `screens/`  
        `viewmodel/`  
      `catalog/`  
      `product_detail/`  
      `cart/`  
      `checkout/`  
      `orders/`  
      `profile/`  
      `auth/`

الفكرة: **View (screens)** → تتعامل فقط مع **ViewModel (state)** → ينادي **UseCases** → تمر عبر **Repository** → إلى **Remote/Local**.

---

# **2\) قالب State موحّد (أسماء الحالات والخصائص)**

نستخدم نفس القالب في كل شاشة عشان تكون التجربة متسقة:

**أسماء الحالات:**

* `idle` — الواجهة جاهزة بدون بيانات أو قبل أول طلب.  
* `loading` — جاري الجلب/التنفيذ.  
* `success` — نجحت العملية وفيه بيانات.  
* `error` — فشلت العملية وفيه معلومات عن الخطأ.

**الخصائص القياسية داخل الحالة:**

* `data` (اختياري) — البيانات المعروضة عند النجاح.  
* `error_code` — كود منطقي داخلي (مثل `network_offline`, `validation_422`, `auth_401`…).  
* `error_message` — نص عربي جاهز للعرض للمستخدمة.  
* `last_updated_at` — طابع زمني آخر تحديث (يفيد في الإنعاش/الـpull-to-refresh).  
* `is_refreshing` — هل التحديث الآن خلف الكواليس (SWr).

**قواعد استخدام:**

* أي طلب شبكة يبدأ بـ `loading`، ثم يتحول إلى `success` أو `error`.  
* في القوائم: اعرض **skeleton** مع `loading`، و**Empty State** إذا `success` بدون بيانات، و**رسالة خطأ** مع زر إعادة المحاولة عند `error`.  
* لا تُظهر رسائل تقنية؛ استخدم جدول الرسائل الجاهزة أدناه.

---

# **3\) جدول رسائل الخطأ العربية القياسية**

| error\_code | متى يُستخدم | الرسالة العربية (للواجهة) | ملاحظات واجهة |
| ----- | ----- | ----- | ----- |
| `network_offline` | عدم وجود إنترنت / فشل DNS | **اتصالك بالإنترنت غير متوفر.** تأكدي من الشبكة وحاولي مجددًا. | زر “إعادة المحاولة” |
| `timeout` | انقضاء مهلة الطلب | **الخدمة تتأخر بالاستجابة.** حاولي مرة أخرى بعد لحظات. | حاول تقليل المهلة في الخلفية |
| `server_5xx` | خطأ من الخادم (500–599) | **حدث خطأ مؤقت في الخادم.** نعمل على إصلاحه. عاودي لاحقًا. | اعرض “أبلغي عن المشكلة” اختياري |
| `not_found_404` | مورد غير موجود (منتج محذوف مثلًا) | **العنصر غير متاح الآن.** | أعِد التوجيه إلى شاشة مناسبة |
| `validation_422` | إدخال غير صحيح/قواعد عمل (مثال: كمية غير متاحة) | **رجاءً راجعي البيانات المدخلة.** | إن وُجدت تفاصيل، اعرضيها تحت الحقول |
| `auth_401` | غير مصدّق/انتهت الجلسة | **يرجى تسجيل الدخول للمتابعة.** | افتحي مودال تسجيل الدخول |
| `forbidden_403` | صلاحية غير كافية | **لا تملكين إذن تنفيذ هذا الإجراء.** |  |
| `rate_429` | طلبات كثيرة خلال فترة قصيرة | **طلبات متكررة.** حاولي بعد قليل. |  |
| `conflict_409` | تضارب حالة (مثل مخزون نفد أثناء الشراء) | **نفد المخزون لهذا المنتج.** حدّثي الصفحة واختاري بديلًا. | أعرضي بدائل/مقاسات |
| `unknown` | أي خطأ غير مصنّف | **حدث خطأ غير متوقع.** حاولي من جديد. | سجّلي الحدث للتحقيق |

**هدفه:** كل الشاشة تستخدم نفس الرسائل لنفس الحالات، فتكون التجربة موحّدة وواضحة.للمطور: حوِّل أكواد HTTP أو أكواد الخادم (ZH-XXXX) إلى `error_code` أعلاه، وكلها تعرض نصًا موحدًا.

---

# **4\) جدول الأحداث القياسية للتحليلات (GA4)**

**هدفه:** توحيد أسماء الأحداث والمعلمات الأساسية. كل حدث باسم **snake\_case**.

| event\_name | متى يُطلق | أهم المعلمات (params) |
| ----- | ----- | ----- |
| `app_start` | عند فتح التطبيق بنجاح | `app_version`, `platform` |
| `screen_view` | عند فتح أي شاشة | `screen_name`, `previous_screen`, `section` |
| `view_item_list` | عرض قائمة (فئة/بحث/شبكة) | `list_id`, `list_name`, `items_count` |
| `select_item` | ضغط عنصر من القائمة | `item_id`, `item_name`, `list_name`, `index` |
| `view_item` | فتح صفحة منتج | `item_id`, `item_name`, `category`, `price`, `in_stock` |
| `add_to_cart` | إضافة للسلة | `item_id`, `variant_id`, `size`, `color`, `quantity`, `price`, `currency` |
| `begin_checkout` | بدء إجراءات الدفع | `items_count`, `value`, `currency` |
| `add_shipping_info` | إدخال/اختيار عنوان الشحن | `city`, `region`, `value`, `currency` |
| `add_payment_info` | اختيار طريقة الدفع | `payment_type` (cod/prepaid), `value`, `currency` |
| `purchase` | إتمام الطلب | `transaction_id`, `value`, `currency`, `items[]` (id, name, price, qty), `shipping`, `coupon?` |
| `search` | تنفيذ بحث | `search_term`, `results_count` |
| `notification_open` | فتح إشعار | `campaign_id`, `type` (promo/transactional) |
| `login` / `sign_up` | دخول/تسجيل | `method` (phone/email) |

**قواعد عامة:**

* لا نرسل أي بيانات تعريف شخصية (رقم/إيميل).  
* العملة الافتراضية `YER`.  
* `transaction_id` فريد ولا يتكرر.  
* كل شاشة تسجل `screen_view` باسم ثابت (مثل `home`, `product_detail`, `cart`, `checkout_shipping`, `checkout_payment`, `checkout_review`, `orders_list`, `profile`).





---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
