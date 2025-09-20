# **ملاحظات & تحسينات بنية التطبيق** 

## **0\) (Overview)**

**التدفق العام:**  
Flutter App (UI/State/Cache) → API (Auth/Cart/Orders/Payments/Notifications) → DB/PIM/Services  
**الطرف الثالث:** Firebase/Crashlytics, GA4/BigQuery, Meta Pixel, Google Ads, Sentry (أو بديل)، Codemagic (CI/CD), TestFlight/Play Console  
**المراقبة:** Logs \+ Metrics \+ Traces \+ Alerts  
**الإصدارات:** Feature Flags → QA/Staging → Beta → Prod (تدرّج Rollout%)  
**هرم الاختبارات:** Unit → Widget/Golden → Integration/E2E → Post-release Monitoring

---

## **1\) جداول قياسية لإضافتها (Templates)**

### **1.1 Error Catalog**

| module | http\_status | error\_code | user\_msg\_ar | user\_msg\_en | severity | retry\_action | telemetry\_event | SLO | fallback\_ui | test\_case\_id |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| auth | 401 | AUTH\_EXPIRED | انتهت صلاحية الجلسة… | Session expired… | high | show\_login | auth\_error | \< 0.5% | modal\_login | TC-ERR-001 |

**معايير:** توحيد صياغة الرسائل، backoff \+ jitter، عدم الاعتماد على اللون فقط لبيان الفشل.

---

### **1.2 Cache/TTL Matrix (stale-while-revalidate)**

| screen/data | source | TTL | invalidate\_on | offline\_behavior | TTR\_from\_cache | TTU | test\_ids |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| PLP | /products?cat=… | 10m | price\_change, sale\_start | show\_cached \+ banner\_offline | \<300ms | \<2s | TC-CACHE-PLP-\* |
| PDP | /product/:id | 5m | stock\_change | show\_cached\_basic | \<300ms | \<1.5s | TC-CACHE-PDP-\* |
| Cart | /cart | 0 (live) | add/remove/qty | hard-failover msg | — | \<800ms | TC-CACHE-CART-\* |

---

### **1.3 Deep Link & Notifications Matrix**

| type | route | required\_params | optional | fallback | analytics\_event | expiry | test\_case\_id |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| PDP | /p/:id | id | ref, coupon | open\_home | dl\_open\_pdp | 24h | TC-DL-001 |
| Search | /s | q | sort | open\_search\_empty | dl\_open\_search | — | TC-DL-010 |

---

### **1.4 Accessibility Checklist (WCAG AA)**

| screen | min\_touch\_target(≥48dp) | contrast(AA) | semantics/labels | dynamic\_text(120%) | dark/light | keyboard\_nav |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| Checkout | ✔ | ✔ | ✔ | ✔ | ✔ | N/A |

---

### **1.5 Alerting & SLOs**

| metric | threshold | window | channel | owner | runbook | auto\_stop\_rollout |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| Crash-free sessions | \<98.5% | 1h | Slack/Email | Mobile Lead | RB-CRASH | ✔ |
| Checkout conversion Δ | −15% vs prev | 2h | Slack/Email | PM \+ Eng | RB-CONV | ✔ |
| Start-up P95 | \>3.5s | 1h | Slack | Mobile Lead | RB-STARTUP | ✔ |

---

### **1.6 Device/OS Test Matrix**

| os | version | device class | screen | locale | theme | network |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| iOS | 16/17/18 | mid/high | small/large | ar/en | dark/light | 3G/poor/wifi |
| Android | 10–14 | low/mid/high | small/large | ar/en | dark/light | 3G/poor/wifi |

---

### **1.7 Performance Budgets**

| scenario | P50 | P95 | notes | test\_case\_id |
| ----- | ----- | ----- | ----- | ----- |
| Cold start to first paint | 1.5s | 3.5s | pre-warm cache, defer non-critical | TC-PERF-001 |
| PLP initial render | 0.9s | 2.0s | skeleton \+ SWR | TC-PERF-PLP |
| PDP ready to interact | 1.0s | 2.2s | image lazy-loading | TC-PERF-PDP |

---

### **1.8 CI/CD Pipeline (Codemagic)**

| stage | purpose | gates/outputs |
| ----- | ----- | ----- |
| Lint/Format | التزام بالأسلوب وجودة الكود | فشل عند أخطاء lint |
| Unit/Widget/Golden | جودة منطق وواجهة | تغطية ≥80% للوحدات الحرجة |
| Integration/E2E | رحلات حرجة (login, add2cart, pay) | نجاح 100% |
| Build & Size Budgets | التحقق من الحجم | لو تخطى الميزانية → فشل |
| Sign & Upload | توقيع وإرسال للمتاجر | سجلات إصدار، build id |
| Release Gate | تحقق SLO & تنبيهات | إيقاف تلقائي عند كسر الحدود |

---

### **1.9 Security & Privacy Controls**

| area | control | status | notes |
| ----- | ----- | ----- | ----- |
| Tokens | secure storage (Keychain/Keystore) |  | منع logs |
| API | rate limiting, idempotency keys |  | حماية إعادة الطلب |
| PII | masking in logs |  | التزام Privacy |
| Screenshots | منع على شاشات حساسة (اختياري) |  | Android/iOS flags |
| Permissions | rationale \+ deny paths |  | UX بدائل عند الرفض |

---

### **1.10 Analytics Event Schema (GA4/Firebase)**

| event | params | when | owner | test\_id |
| ----- | ----- | ----- | ----- | ----- |
| view\_item\_list | list\_id, cat\_id | فتح PLP | PM/Mobile | TC-AN-PLP |
| view\_item | item\_id, price | فتح PDP | PM/Mobile | TC-AN-PDP |
| add\_to\_cart | item\_id, qty, price | زر الإضافة | PM/Mobile | TC-AN-ATC |
| begin\_checkout | items\_value | بدء الدفع | PM/Mobile | TC-AN-CHK |
| purchase | tr\_id, value, items | نجاح الدفع | PM/Mobile | TC-AN-PUR |

---

### **1.11 Release & Store Ops**

| item | owner | checklist |
| ----- | ----- | ----- |
| App Store assets | Design | لقطات/أيقونات/Privacy labels |
| Versioning (SemVer) | Eng | bump \+ changelog |
| Beta (TestFlight/Play) | QA | دعاة داخليون \+ feedback |
| Review responses | Support | قوالب ردود رسمية |

---

### **1.12 Runbooks/Playbooks**

| runbook | trigger | steps (مختصر) | owner |
| ----- | ----- | ----- | ----- |
| RB-ROLLBACK | SLO مكسور | freeze rollout → revert → verify | Eng Lead |
| RB-INCIDENT | spike errors | form war-room → assign → comms | On-call |
| RB-HOTFIX | blocker bug | branch hotfix → QA fast → release | Eng |

---

## **2\) معايير تفصيلية لكل بند (قابلة للتنفيذ)**

### **2.1 Error Map**

* **التنفيذ:** مكوّن UI موحّد للأخطاء \+ طبقة ترجمة \+ سياسة retry/backoff.  
* **اختبارات:** Golden لثبات النص/التصميم، محاكاة مهلات/انقطاع/401/409/422.  
* **مقاييس:** معدل ظهور كل error\_code، نسبة نجاح إعادة المحاولة.

### **2.2 Cache/TTL (SWR**

* **التنفيذ:** in-memory \+ disk \+ API cache، invalidation عند تغيّر سعر/مخزون/عروض.  
* **اختبارات:** offline-first لعرض الكاش، قياس TTR/TTU، صحة invalidation.

### **2.3 Deep Links & Notifications**

* **التنفيذ:** مصفوفة روابط \+ فحص المعلمات \+ fallback للصفحة المناسبة \+ events.  
* **اختبارات:** E2E من إشعار حتى الشاشة المستهدفة \+ صلاحية الروابط المنتهية.

### **2.4 Accessibility**

* **التنفيذ:** semantics/labels، حجم لمس 48dp، تباين AA، دعم تكبير الخطّ.  
* **اختبارات:** أدوات الوصول \+ لقطات Golden للوضعين الداكن/الفاتح.

### **2.5 Post-release Monitoring**

* **التنفيذ:** Crashlytics/Sentry \+ لوحات قياس \+ تنبيهات SLO \+ إيقاف rollout تلقائي.  
* **اختبارات:** firing تنبيه تجريبي، مقارنة cohort إصدار جديد بالقديم.

### **2.6 Architecture/Environments**

* **التنفيذ:** Dev/QA/Pre-Prod/Prod، secrets عبر Vault، فصل التحليلات على البيئات.  
* **اختبارات:** ضمان تحميل مفاتيح البيئة الصحيحة، منع مزج بيانات.

### **2.7 Code Quality & Workflow**

* **التنفيذ:** Lint/Format، نمط حالة موحّد (Bloc/Riverpod)، PR rules، SemVer.  
* **اختبارات:** فشل تلقائي عند lint errors/low coverage.

### **2.8 CI/CD (Codemagic)**

* **التنفيذ:** stages أعلاه \+ artifacts (JUnit/Coverage/Size) \+ gates.  
* **اختبارات:** pipeline dry-run، فشل متعمد لقياس الحماية.

### **2.9 Testing Pyramid**

* **التنفيذ:** وحدات، ودجت/Golden، تكامل/E2E لرحلات الشراء.  
* **اختبارات:** Matrix الأجهزة/الشبكات/اللغات/الثيمات.

### **2.10 Performance Budgets**

* **التنفيذ:** قياس start-up/PLP/PDP/Checkout، lazy-load، defer non-critical.  
* **اختبارات:** قياس P50/P95 تلقائي داخل CI، فشل عند تجاوز الحدود.

### **2.11 Security & Privacy**

* **التنفيذ:** secure storage، masking logs، rate-limit، idempotency، سياسات أذونات.  
* **اختبارات:** pentest خفيف للعميل، التحقق من منع لقطات على الشاشات الحساسة (اختياري).

### **2.12 Analytics & Measurement**

* **التنفيذ:** مخطط موحّد للأحداث/المعلمات، ربط BigQuery/لوحات.  
* **اختبارات:** مطابقة عدد الأحداث مع عدد الرحلات، عدم وجود events يتيمة.

### **2.13 Product/UX (Degrade/Offline/Image Policy)**

* **التنفيذ:** سلوك واضح دون اتصال، placeholders/shimmer، سياسة صور (أبعاد/صيَغ/WebP).  
* **اختبارات:** عرض صحيح عند غياب الشبكة/الصور/المخزون.

### **2.14 Release & Store**

* **التنفيذ:** أصول المتاجر، Privacy labels، ردود المراجعات.  
* **اختبارات:** قائمة تحقق قبل الإرسال (pre-submission checklist).

### **2.15 Runbooks**

* **التنفيذ:** وثائق rollback/incident/hotfix، قنوات اتصال محدّدة.  
* **اختبارات:** مناورة (drill) قصيرة ربع سنوية.

---

## **3\) معايير القبول (Definition of Done)**

* **Error Map:** 100% الشاشات تستخدم نفس مكوّن الخطأ \+ Golden ثابت.  
* **Cache/TTL:** PLP/PDP TTR\_from\_cache \< 300ms، TTU ≤ 2s (شبكة جيدة).  
* **Deep Links:** 0% فشل في روابط PDP/PLP/Search الأساسية \+ أحداث تتبّع صحيحة.  
* **Accessibility:** اجتياز AA للعناصر الحرجة \+ لا انكسار عند 120% خط.  
* **Monitoring:** تنبيهات فعّالة \+ auto-stop rollout عند كسر SLO.  
* **CI/CD:** pipeline كامل مع gates فعّالة وتغطية ≥80% للوحدات الحساسة.  
* **Performance:** احترام ميزانيات P50/P95 الموضوعة.  
* **Security/Privacy:** عدم تسريب PII في السجلات \+ rate-limit/idempotency مفعل.  
* **Analytics:** الأحداث الرئيسية تعمل من الفتح حتى الشراء، بلا ازدواجية.

---

## **4\) خطة إغلاق الفجوات (Sprint واحد مقترح)**

1. إضافة الجداول 1.1–1.12 للمستند كـ baseline.  
2. تفعيل Codemagic مع المراحل والبوابات والأثر المرئي (Coverage/Size/Reports).  
3. إعداد Crashlytics/Sentry \+ تنبيهات SLO للقنوات المناسبة.  
4. بناء مجموعة اختبارات: unit/widget/golden/integration \+ Matrix الأجهزة.  
5. نشر Runbooks مختصرة (rollback/incident/hotfix) وتجربة مناورة واحدة.

---

## **5\) ملاحظات تنسيق/إدارة**

* اربط كل صف “test\_case\_id” بحالة اختبار في نظام QA (مثلاً TC-AN-PDP).  
* عيّن “owner” واضح لكل عنصر (PM/Mobile/Backend/QA).  
* حافظ على نسخة عربية/إنجليزية للرسائل الظاهرة للمستخدم.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
