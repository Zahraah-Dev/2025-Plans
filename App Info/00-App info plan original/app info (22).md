# **الإضافات**

## **1\. المنصّات (Android / iOS)**

* **Android**  
  * Notification permission (Android 13+)، إعداد قنوات إشعارات.  
  * Backup rules، Network Security config، App Links.  
  * targetSdk / minSdk وحدود حجم الـ AAB.  
* **iOS**  
  * Push capabilities (APS)، Background modes (الضرورية فقط).  
  * App Transport Security (ATS) وسياسة الشبكة.  
  * Privacy Manifest \+ App Tracking Transparency (ATT).  
  * Universal Links وإعدادات الـ App Store.

---

## **2\. إدارة الأسرار والأمان**

* إدارة الأسرار عبر GitHub Encrypted Secrets / CodeMagic variables.  
* حظر التسرّب عبر secret-scanner step في CI.  
* google-services.json / .plist لكل Flavor \+ حقن تلقائي في CI.  
* سياسة تدوير المفاتيح (API Keys).  
* دعم TLS Pinning للاتصالات الحرجة (اختياري).

---

## **3\. التحليلات والمراقبة (Observability)**

* إلزام Crashlytics \+ Firebase Performance Monitoring.  
* ربط الإصدار (release/channel/buildNumber) بالتحليلات.  
* لوحة مؤشرات إلزامية:  
  * Crash-free ≥ 99.5%  
  * ANR \< X%  
  * Error Rate API \< 2%  
* ملف **analytics\_events.md** يدوّن جميع الأحداث والمعاملات ويُعتبر جزءًا من Definition of Done.

---

## **4\. الجودة والأداء داخل CI/CD**

* تفعيل `flutter build appbundle --analyze-size` ورفع التقرير كـ artifact.  
* فشل الـPR إذا زاد حجم الـAPK/AAB بنسبة \> N%.  
* Device Matrix لاختبارات Integration (شاشات/نسخ Android مختلفة).  
* دعم اختبار iOS على macOS runner (عند توفره).  
* تفعيل pre-commit hooks: (dart format, analyze).  
* دليل Code Review: يحدد متى نرفض PR ومتى نطلب Goldens إضافية.

---

## **5\. النشر عبر CodeMagic (CD Pipeline)**

* بيئات متعددة (dev/stage/prod).  
* Build \+ Test \+ Sign \+ Deploy تلقائي إلى:  
  * Firebase App Distribution  
  * TestFlight  
  * Play Console  
* استخدام بيئات ومتغيرات آمنة (Environment Variables).  
* تقارير ما بعد البناء: حجم التطبيق، اختبارات الأداء.

---

## **6\. الترجمة والدعم العربي (RTL)**

* استخدام ملفات `.arb` موحّدة (snake\_case).  
* دعم قواعد plural/select.  
* إلزام Goldens RTL \+ تكبير خط 1.3× / 1.6× في CI.  
* شرط فحص تلقائي للـRTL والـLocalization ضمن الـPR.

---

## **7\. الشبكة والكاش**

* توحيد عقود Pagination / Sorting / Filtering.  
* Idempotency keys للعمليات الحرجة (checkout).  
* سياسة Offline Queue: ما يُخزّن محليًا ويُعاد إرساله عند عودة الإنترنت.

---

## **8\. Definition of Done (موسع)**

أي Feature جديدة تعتبر “مكتملة” فقط إذا شملت:

1. الأحداث (Events) مربوطة ومُختبرة في DebugView.  
2. Crashlytics يلتقط userId / session.  
3. تقرير حجم التطبيق مرفق.  
4. اختبار RTL \+ Golden مرفق.  
5. استيفاء Checklist أصول المتجر (Store Assets Checklist).


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
