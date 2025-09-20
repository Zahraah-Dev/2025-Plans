**1\. الحواجز البنيوية (Architectural Guards)**

\* يمنع الاستيراد المباشر بين Features.  
\* التواصل فقط عبر Domain Interfaces.  
\* التحقق الآلي عبر أدوات lint/CI: أي استيراد مخالف يفشل البناء.

**2\. معايير Checkout / COD**

\* استخدام Idempotency-Key لكل طلب شراء.  
\* Queue للطلبات عند انقطاع الشبكة لمنع التكرار.  
\* معالجة فشل التسليم (رسائل عربية موحدة \+ إعادة المحاولة).  
\* Analytics: حدث \`add\_payment\_info(payment\_type=cod)\` \+ حدث \`cod\_failed\_reason\` لتسجيل أسباب فشل الدفع.

**3\. Budgets الأداء (Performance Budgets)**

\* زمن تشغيل أولي (Cold Start) ≤ 2.5 ثانية.  
\* معدل Jank \< 1% في صفحات (PLP/PDP).  
\* حجم ملف AAB ≤ 40MB.  
\* CI يحتوي مهمة فحص الحجم (\`--analyze-size\`) ويمنع الدمج عند التجاوز.

**4\. Golden RTL Gates**

\* لقطات ذهبية إلزامية لكل مكون أساسي باللغتين (RTL/LTR).  
\* تُختبر مع تكبير خط 1.3× و 1.6×.  
\* شرط أساسي قبل الدمج في PR template.

**5\. Observability ومعايير التشغيل**

\* معدل Crash-free ≥ 99.5%.  
\* معدل فشل API \< 2%.  
\* لوحة متابعة أسبوعية لمسار الشراء (عرض → سلة → دفع → شراء).

**6\. تعزيز الأمن (Security)**

\* تفعيل SSL Pinning للاتصالات.  
\* استثناء البيانات الحساسة من النسخ الاحتياطي.  
\* تنظيف شامل للـ Cache والبيانات الحساسة عند تسجيل الخروج.

**7\. Attribution (First/Last Touch)**

\* تخزين خصائص المستخدم: \`first\_source/medium/campaign\` و \`last\_source/medium/campaign\`.  
\* إرسال القيم مع حدث \`purchase\` لتقييم فعالية الحملات التسويقية بدقة.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
