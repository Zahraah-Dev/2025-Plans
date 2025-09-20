## **نقاط إضافية** 

### **1\. إدارة الأكواد (Code Style & Structure)**

* الالتزام بـ **Dart style guide** \+ استخدام Lints موحدة (pedantic أو flutter\_lints).  
* ممنوع ترك TODO/print في الكود عند الدمج.  
* أي كود تجريبي يجب أن يكون في فرع خاص أو ملف `sandbox/`.

### **2\. التسمية (Naming Conventions)**

* أسماء الملفات: `snake_case.dart`.  
* أسماء الـClasses: PascalCase.  
* أسماء المتغيرات: camelCase.  
* يضاف **Suffix واضح** (مثال: `HomeScreen`, `UserRepository`, `CartService`).

### **3\. الصور والموارد (Assets)**

* جميع الصور داخل `assets/images/`، والأيقونات داخل `assets/icons/`.  
* لا يُستخدم رابط URL مباشر لصورة في الكود.  
* يجب ضغط الصور (WebP أو SVG) لتقليل الحجم.

### **4\. الـLocalization (الترجمة)**

* استخدام **arb**/`intl` للترجمات.  
* يمنع كتابة النصوص مباشرة داخل Widgets.  
* التأكد من دعم RTL و LTR دائمًا.

### **5\. الأمن (Security Practices)**

* تخزين التوكنات/المفاتيح في Secure Storage فقط.  
* عدم إدخال أي مفتاح API في الكود (يُستخدم .env أو Secret Manager).  
* عند التعامل مع الطلبات، يجب وجود Timeout \+ Retry policy.

### **6\. الـTesting (الاختبارات)**

* **Unit tests** لكل use-case و Repository.  
* **Widget tests** للشاشات المهمة (Login, Checkout, Product Details).  
* **Golden tests** لكل UI Component أساسي (مع RTL).

### **7\. المراجعة والتوثيق (Reviews & Docs)**

* كل PR يجب أن يحتوي:  
  * وصف للتغييرات.  
  * صور/فيديو قصير إذا التغيير واجهة.  
  * نتائج اختبارات (نجاح CI).  
* تحديث `ARCHITECTURE.md` و `CHANGELOG.md` عند أي إضافة مهمة.

### **8\. الأداء (Performance)**

* يمنع استخدام Widgets كثيفة بدون Virtualization (مثل ListView بدون builder).  
* مراقبة إعادة البناء (rebuilds) عبر Flutter DevTools.  
* استخدام const widgets حيثما أمكن.

### **9\. الـAnalytics**

* توحيد جميع الأحداث (Events) عبر `AnalyticsService`.  
* ممنوع تسجيل الأحداث مباشرة من الـUI.  
* التأكد من وجود **Funnel كامل**: عرض منتج → إضافة للسلة → Checkout → Purchase → COD Confirm.

### **10\. الـError Handling**

* ممنوع رمي Exception خام.  
* استخدام Result/Failure objects.  
* كل خطأ يجب أن يكون له رسالة موحدة للعميل \+ Log داخلي.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
