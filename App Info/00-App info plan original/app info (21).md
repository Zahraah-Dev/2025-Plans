# **Codemagic CI/CD –  Flutter**

## **1\) الهدف (Objectives)**

* أتمتة البناء والاختبارات والتوزيع لإصدارات **Android** و **iOS**.  
* تقليل الأعطال ووقت الإطلاق عبر **بوابات قبول** واضحة (Release Gates).  
* مسارات موحّدة: `develop` → `staging` → `production` مع تتبّع تغييرات واضح.

## **2\) المتطلبات (Prereqs)**

* مستودع Git (GitHub/GitLab/Bitbucket) بفروع: `develop`, `staging`, `main`.  
* **Flavors** في Flutter/Gradle/Xcode: `dev`, `staging`, `prod`.  
  * Android `applicationId`:  
    * `com.zahraah.app.dev`  
    * `com.zahraah.app.staging`  
    * `com.zahraah.app`  
  * iOS **Bundle IDs**:  
    * `com.zahraah.app.dev`  
    * `com.zahraah.app.staging`  
    * `com.zahraah.app`  
* حسابات المتاجر: **Google Play Console** \+ **App Store Connect** (شركة).  
* تفعيل **Crashlytics** و(اختياري لكن مفيد) **Firebase App Distribution**.

## **3\) الأسرار ومتغيرات البيئة (Secrets / ENV)**

تُحفظ في Codemagic ضمن **Groups** (لا تُرفع إلى الريبو).

**android\_keystore**

* `ANDROID_KEYSTORE` (Base64 لملف *.jks* أو ارفعه من Files)  
* `ANDROID_KEYSTORE_PASSWORD`  
* `ANDROID_KEY_ALIAS`  
* `ANDROID_KEY_ALIAS_PASSWORD`

**ios\_connect\_api** (App Store Connect API)

* `ASC_ISSUER_ID`  
* `ASC_KEY_ID`  
* `ASC_PRIVATE_KEY` (النص الخاص للمفتاح)

**play\_console** (Google Play Service Account)

* `PLAY_SERVICE_ACCOUNT_JSON` (محتوى JSON لمستخدم الخدمة بصلاحية Release Manager)

**firebase\_dist** (Firebase App Distribution) – اختياري

* `FIREBASE_TOKEN`  
* `FIREBASE_ANDROID_DEV_APP_ID` / `FIREBASE_IOS_DEV_APP_ID`

**notifiers** (التنبيهات)

* `SLACK_WEBHOOK_URL` (اختياري)

## **4\) سير العمل (Workflows)**

### **develop (داخلي – QA)**

* Trigger: أي Push/PR إلى `develop`.  
* خطوات: `flutter analyze` \+ `flutter test` \+ بناء APK (debug أو release).  
* توزيع: Firebase App Distribution لفريق QA (اختياري).

### **staging (اختبار متجر داخلي)**

* Trigger: دمج إلى `staging` أو Tag باسم `staging-*`.  
* بناء: **AAB** للأندرويد \+ **IPA** للـiOS (Release).  
* نشر: Google Play **Internal track** \+ TestFlight تلقائي.

### **production (إطلاق)**

* Trigger: إنشاء **Tag يبدأ بـ `v`** (مثل `v1.3.0`).  
* نشر: Google Play **Production** (طرح تدريجي 10%) \+ App Store (Submit to App Store، إطلاق يدوي).

## **5\) بوابات القبول (Release Gates)**

* `flutter analyze` بدون أخطاء.  
* نجاح `flutter test --coverage` (هدف أولي ≥ 20%).  
* عدم وجود أعطال حرجة في **Crashlytics** للإصدار المراد إطلاقه.  
* فحص أداء يدوي: TTI \< 3s للشاشات الأساسية على أجهزة متوسطة.

## **6\) تنبيهات (Alerts)**

* عند فشل البناء/النشر: إشعار Slack عبر `SLACK_WEBHOOK_URL`.  
* عند نجاح إطلاق الإنتاج: إشعار بالنسخة والرابط.

## **7\) أفضل ممارسات**

* **Conventional Commits** لتوليد changelog آلي.  
* تفعيل **Gradle/CocoaPods cache** لتسريع البناء.  
* **Staged Rollout** للأندرويد: 10% → 50% → 100%.  
* أسرار **Secrets** دائمًا خارج الكود.

---

## **8\) ملف جاهز: `codemagic.yaml`**

عدّل المسارات والمعرّفات حسب مشروع **Zahraah**.

`workflows:`  
  `develop:`  
    `name: Dev – Internal QA`  
    `max_build_duration: 60`  
    `environment:`  
      `flutter: stable`  
      `vars:`  
        `APP_FLAVOR: dev`  
      `groups:`  
        `- android_keystore`  
        `- firebase_dist`  
        `- notifiers`  
    `scripts:`  
      `- flutter pub get`  
      `- flutter analyze`  
      `- flutter test --coverage`  
      `- flutter build apk --flavor $APP_FLAVOR --debug`  
      `# - |`  
      `#   firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-debug.apk \`  
      `#     --app $FIREBASE_ANDROID_DEV_APP_ID \`  
      `#     --groups "qa"`  
    `artifacts:`  
      `- build/app/outputs/**/*.apk`  
    `publishing:`  
      `scripts:`  
        `- |`  
          `if [ -n "$SLACK_WEBHOOK_URL" ]; then`  
            `curl -X POST -H 'Content-type: application/json' \`  
            `--data '{"text":"✅ Dev build finished: '$CM_COMMIT'"}' $SLACK_WEBHOOK_URL`  
          `fi`

  `staging:`  
    `name: Staging – Stores (Internal)`  
    `max_build_duration: 90`  
    `environment:`  
      `flutter: stable`  
      `vars:`  
        `APP_FLAVOR: staging`  
      `groups:`  
        `- android_keystore`  
        `- ios_connect_api`  
        `- play_console`  
        `- notifiers`  
    `scripts:`  
      `- flutter pub get`  
      `- flutter analyze`  
      `- flutter test --coverage`  
      `- flutter build appbundle --flavor $APP_FLAVOR --release`  
      `- flutter build ipa --flavor $APP_FLAVOR --release`  
    `artifacts:`  
      `- build/app/outputs/**/*.aab`  
      `- build/ios/ipa/*.ipa`  
    `publishing:`  
      `google_play:`  
        `credentials: $PLAY_SERVICE_ACCOUNT_JSON`  
        `track: internal`  
      `app_store_connect:`  
        `issuer_id: $ASC_ISSUER_ID`  
        `key_identifier: $ASC_KEY_ID`  
        `private_key: $ASC_PRIVATE_KEY`  
        `submit_to_testflight: true`  
      `scripts:`  
        `- |`  
          `if [ -n "$SLACK_WEBHOOK_URL" ]; then`  
            `curl -X POST -H 'Content-type: application/json' \`  
            `--data '{"text":"🚀 Staging uploaded to Internal/TestFlight for '$CM_BRANCH'"}' $SLACK_WEBHOOK_URL`  
          `fi`

  `production:`  
    `name: Production – Stores`  
    `max_build_duration: 120`  
    `environment:`  
      `flutter: stable`  
      `vars:`  
        `APP_FLAVOR: prod`  
      `groups:`  
        `- android_keystore`  
        `- ios_connect_api`  
        `- play_console`  
        `- notifiers`  
    `triggering:`  
      `events:`  
        `- tag`  
      `branch_patterns:`  
        `- pattern: 'v*'`  
          `include: true`  
          `source: true`  
    `scripts:`  
      `- flutter pub get`  
      `- flutter analyze`  
      `- flutter test --coverage`  
      `- flutter build appbundle --flavor $APP_FLAVOR --release`  
      `- flutter build ipa --flavor $APP_FLAVOR --release`  
    `artifacts:`  
      `- build/app/outputs/**/*.aab`  
      `- build/ios/ipa/*.ipa`  
    `publishing:`  
      `google_play:`  
        `credentials: $PLAY_SERVICE_ACCOUNT_JSON`  
        `track: production`  
        `rollout:`  
          `fraction: 0.1`  
      `app_store_connect:`  
        `issuer_id: $ASC_ISSUER_ID`  
        `key_identifier: $ASC_KEY_ID`  
        `private_key: $ASC_PRIVATE_KEY`  
        `submit_to_app_store: true`  
        `submit_to_testflight: false`  
      `scripts:`  
        `- |`  
          `if [ -n "$SLACK_WEBHOOK_URL" ]; then`  
            `curl -X POST -H 'Content-type: application/json' \`  
            `--data '{"text":"🎉 Production released tag '$CM_TAG'"}' $SLACK_WEBHOOK_URL`  
          `fi`

---

## **9\) سكربت (اختياري) لزيادة buildNumber تلقائيًا**

أضِفه في بداية قسم `scripts:` قبل البناء.

`#!/usr/bin/env bash`  
`set -e`  
`CURRENT=$(grep '^version:' pubspec.yaml | awk '{print $2}')`  
`BASE=${CURRENT%+*}`  
`BUILD=${CURRENT#*+}`  
`if [[ "$BUILD" == "$CURRENT" ]]; then BUILD=0; fi`  
`NEXT=$((BUILD+1))`  
`sed -i.bak "s/^version: .*/version: $BASE+$NEXT/" pubspec.yaml`  
`head -n 5 pubspec.yaml`

---

## **10\) قائمة ضبط سريعة (Checklist)**

1. اربط مستودع Git في Codemagic وفَعّل **Builds on push**.  
2. أنشئ **Groups** وأضف الأسرار المذكورة.  
3. تأكد من ضبط **Flavors** في Gradle/Xcode (IDs تتطابق مع المتاجر).  
4. فعّل **Gradle/CocoaPods cache** من إعدادات Workflow.  
5. جرّب `develop` → `staging` → اصنع Tag `v1.0.0` لاختبار **production**.

## **11\) مشاكل شائعة**

* **توقيع iOS يفشل**: تأكد من صلاحيات App Store Connect والقيم الصحيحة لـ `ASC_*`.  
* **رفض Google Play**: زِد **Version Code** دائمًا؛ أو استخدم سكربت الرفع التلقائي.  
* **عدم تطابق Bundle IDs/ applicationId** بين Flavors والمتاجر.  
* **حجم IPA/AAB كبير**: فعّل `--split-debug-info` و `--obfuscate` (مع حفظ رموز التفكيك).

## **1\) حدّ أدنى إلزامي “داخل” مستند بنية التطبيق (يبدأ من اليوم الأول)**

هذا جزء من المعايير الأساسية، لأنه يضمن التزام الكود بالمعايير تلقائيًا:

* **تشغيل تلقائي على كل PR**: `analyze` \+ `format check` \+ **Unit tests** \+ **تغطية ≥ 70%**.  
* **بناء Debug** (Android/iOS) للتأكد من أن المشروع قابل للبناء دومًا.  
* **بوابات دمج (Gates)**: فشل أي خطوة يمنع الدمج إلى `main`.  
* **حماية الفروع** \+ مراجعتان للكود \+ CODEOWNERS.  
* **إدارة أسرار آمنة** (API keys, keystore, signing certs) عبر متغيرات Codemagic.  
* **Caching** لحزم Flutter/gradle لتقليل وقت البناء.  
* **إشعارات فشل** للـSlack/البريد.

هذه البنود تُوثّق “سياسة CI” في ملف البِنية، وتُترجم عمليًا إلى ملف `codemagic.yaml` داخل المستودع.

## **2\) توسيع لاحق كمرحلة إصدار (CD) — “ملف منفصل/ملحق عملي”**

هذا يُنفّذ بعد استقرار الأساس، وغالبًا نضع تفاصيله في **ملحق CI/CD** أو README مستقل:

* **توقيع تلقائي** وبناء **Release** لمنصّتَي Android & iOS.  
* **توزيع مرحلي**: Play Console (Internal → Closed) \+ TestFlight، بنسبة 10% → 50% → 100%.  
* **رفع الخرائط**: dSYM/Proguard لـ Crashlytics/Sentry.  
* **رفع التغطية والتقارير**، وتوليد **Changelog** من الـtags/PRs.  
* **مصفوفة بيئات** (dev/stage/prod) \+ تبديل مفاتيح `--dart-define`.  
* **اختبارات تكامل/قبول** تلقائية قبل النشر، مع **Release QA Gates** (مثلاً نجاح Checkout ≥ 95%).  
* **رجوع سريع** (Rollback): تعطيل ميزة عبر Feature Flag أو إرجاع الإصدار السابق.

### **الخلاصة**

* **له علاقة مباشرة بالبنية الأساسية**: الجزء “الحد الأدنى” من Codemagic يجب أن يُوثّق ويُفعّل من اليوم الأول كجزء من مستند البنية (CI كحارس جودة).  
* **والتفاصيل التشغيلية العميقة** (التوقيع، الرفع للمتاجر، التوزيع المرحلي…) تُعامل كـ **مرحلة ثانية** داخل **ملحق CI/CD** أو في `codemagic.yaml`.


---

## 🏠 **Back to Home | العودة للرئيسية**

[← Back to Main Index | العودة للفهرس الرئيسي](../../../index.html)

---
