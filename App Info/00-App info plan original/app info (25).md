# **Redis Standards** 

## **0\) النطاق**

* **الغرض:** تسريع القراءة، الحماية (rate limiting)، الأقفال الموزعة، والجلسات الخفيفة.  
* **ليس مصدر حقيقة:** لا تُخزَّن بيانات الأعمال الحساسة كمصدر نهائي.

---

## **1\) التوزيع والتشغيل (Topology)**

* بيئات منفصلة: `dev`, `staging`, `prod`.  
* مثيلان (مستحسن):  
  * **cache** (بدون AOF، سياسة إخلاء `allkeys-lru`).  
  * **state** (AOF=on للأمان للجلسات/القيود/الأقفال).  
* **التوفّر العالي:**  
* Managed (ElastiCache/Redis Cloud/Upstash) أو Self-Hosted مع Sentinel (Master \+ Replica).

---

## **2\) التسمية المعيارية للمفاتيح (Key Naming)**

{app}:{env}:{domain}:{entity}:{id}:{sub}  
مثال: zahraah:prod:product:12345

* قوائم بفلاتر/ترتيب/صفحة ضمن المفتاح: `zahraah:prod:category:{cid}:list:p{n}:sort:{s}`

---

## **3\) سياسة TTL**

* كل مفتاح **له TTL** مناسب لاستخدامه، مع **Jitter ±10–20%** لتجنب انتهاء جماعي.  
* مرجع سريع:  
  * المنتج: 5–15 دقيقة  
  * قوائم الفئات: 1–5 دقائق  
  * الصفحة الرئيسية: 30–60 ثانية  
  * قواعد الشحن/التسعير: 5–30 دقيقة  
  * الكوبونات: 2–10 دقائق

## **4\) نمط Cache-Aside القياسي**

**قراءة:**

1. Get → إذا Hit أعد القيمة.  
2. إذا Miss: استعلم MySQL → Set مع TTL → أعد القيمة.

**كتابة:**

* نفّذ المعاملة في MySQL.  
* بعد **نجاح commit**: إبطل (DEL) المفاتيح ذات الصلة، وانشر حدث `cache:invalidate` (Pub/Sub) مع قائمة المفاتيح/الأنماط.  
* احمِ من **Cache Stampede** عبر Lock (SET NX \+ TTL قصير).

---

## **5\) خرائط الإبطال (تُنسَّق مع فريق DB)**

* **product/variant:**  
  * DEL `zahraah:prod:product:{product_id}`  
  * DEL `zahraah:prod:category:{cid}:list:*` ذات الصلة  
* **category:**  
  * DEL `zahraah:prod:category:{cid}:list:*`  
  * DEL `zahraah:prod:home`  
* **pricing/shipping:**  
  * DEL `zahraah:prod:shipping:city:*`  
* **coupon:**  
  * DEL `zahraah:prod:coupon:{code}`  
* **inventory:**  
  * DEL `zahraah:prod:product:{product_id}` (+ قوائم ذات صلة)


المصدر الموازي موجود في ملف «معايير قاعدة البيانات» — حافظوا على تطابق التسمية.

---

## **6\) القيود والحماية**

* **Rate Limiting (OTP/Login):** مفاتيح نافذة منزلقة (Sliding Window) لكل رقم أو IP.  
* **Locks:**  
  * عمليات حساسة (كوبونات، إنشاء الطلب) عبر `SET key value NX EX {ttl_s}`.  
  * إعادة المحاولة مع backoff بسيط عند فشل الحصول على القفل.  
* **Sessions/Tokens:** إن لم تكن JWT كاملة، خزن الحد الأدنى بTTL مناسب.

---

## **7\) الإعداد والتهيئة (Config)**

* قراءة الإعداد من متغيرات البيئة: `REDIS_URL`, `REDIS_TLS`, `REDIS_DB_CACHE`, `REDIS_DB_STATE`.  
* مهلة أوامر افتراضية 50–200ms، وإلغاء (timeout) عند التجاوز.  
* اقتبس القيم الثنائية/JSON بسلاسل UTF-8.

---

## **8\) المراقبة (Observability)**

* **مؤشرات أساسية:** Hit Ratio (\>0.9 هدف للكاش الشائع)، Latency، Evictions، Memory Fragmentation.  
* **Slowlog:** مفعّل وتحليل دوري.  
* **لوحة مراقبة:** أعلى المفاتيح وصولًا/حجمًا \+ أخطاء الاتصال.

---

## **9\) الأمن**

* شبكة خاصة فقط (VPC/VNet) \+ TLS عند العبور بين الشبكات.  
* كلمات مرور قوية \+ ACL، وتعطيل أو تقييد أوامر حساسة (`FLUSHALL`, `CONFIG`).

---

## **10\) أمثلة شبه-كود (Pseudocode)**

**قراءة منتج:**

val \= redis.get(key)  
if (\!val) {  
  val \= db.fetchProduct(id)  
  redis.set(key, val, TTL+Jitter)  
}  
return val

**تحديث منتج:**

transaction {  
  db.updateProduct(p)  
}  
redis.del(productKey)  
redis.publish('cache:invalidate', \[productKey, relatedCategoryListPattern\])

**قفل كوبون:**

if (redis.set(lockKey, reqId, NX, EX=20)) {  
  // safely redeem  
  try { redeem(); }  
  finally { if (redis.get(lockKey)==reqId) redis.del(lockKey) }  
} else {  
  throw BusyError  
}

---

## **11\) معايير القبول (App)**

1. التزام التسمية والـTTL والجِتر.  
2. مسارات الكتابة تُبطِل المفاتيح بعد commit فقط.  
3. حماية Stampede بالقفل.  
4. مراقبة Hit Ratio/Evictions/Latency متاحة للفريق.  
5. اختبارات تكامل تُثبت الإبطال لقوائم وفرديات المنتج والكوبونات والشحن.

## **12\) خطة طوارئ مختصرة (Runbook)**

* ارتفاع evictions: راجع TTL/السعة أو وسّع الذاكرة.  
* Hit Ratio منخفض: تأكد من التسمية/التخزين؛ راجع عدم وجود Miss متكرر بسبب Jitter مفرط.  
* Latency مرتفع: تحقق من الشبكة، CPU، Slowlog، وحجم القيم.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
