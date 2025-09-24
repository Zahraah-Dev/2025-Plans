---
layout: default
title: "29. قوائم المراجعة والمرجع السريع"
description: "Flutter e-commerce development guide"
permalink: /app_info/06-Reference/29-checklists-reference/
---

# 29. قوائم المراجعة والمرجع السريع
## 29. Checklists & Quick Reference

> **الجزء السادس: المراجع والأدوات | Part VI: References & Tools**

## 🎯 **Objective | الهدف**
Provide comprehensive checklists and quick reference guides for all aspects of Flutter e-commerce application development, testing, and deployment.

## 📋 **Rule | القاعدة**
**Arabic**: قوائم مراجعة شاملة لكل مرحلة من مراحل التطوير مع معايير القبول والمخاطر  
**English**: Comprehensive checklists for every development phase with acceptance criteria and pitfalls

## 💡 **Benefits | الفوائد**
- **Quality Assurance | ضمان الجودة**: Ensure nothing is missed in development
- **Team Alignment | محاذاة الفريق**: Consistent standards across team
- **Risk Mitigation | تخفيف المخاطر**: Identify and avoid common pitfalls
- **Efficiency | الكفاءة**: Quick reference for common tasks
- **Onboarding | الإدماج**: Easy for new team members to follow
- **Documentation | التوثيق**: Self-documenting development process

## 🛠️ **Implementation | التطبيق**
- **Use in**: All development phases, code reviews, and quality gates
- **How to implement**:
  - Use checklists during development
  - Reference during code reviews
  - Apply during testing phases
  - Use for deployment verification
  - Follow during maintenance
- **Result**: Consistent, high-quality development process with reduced errors

## ✅ **Success Criteria | معايير النجاح**

> **Reference**: See [Success Criteria Template](../../00-Templates/06-success-criteria-template.md) for standard criteria.

### **Checklists & Quick Reference Specific Criteria:**
- [ ] All checklists comprehensive and up-to-date
- [ ] Team using checklists consistently
- [ ] Quality gates enforced
- [ ] Pitfalls documented and avoided
- [ ] Quick reference guides accessible
- [ ] Regular checklist updates

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**

> **Reference**: See [Common Pitfalls Template](../../00-Templates/05-common-pitfalls-template.md) for standard pitfalls.

### **Checklists & Quick Reference Specific Pitfalls:**
- **Avoid**: Outdated checklists
- **Avoid**: Skipping checklist items
- **Avoid**: No checklist maintenance
- **Avoid**: Missing acceptance criteria
- **Avoid**: No pitfall documentation
- **Avoid**: Inconsistent checklist usage

---



## 🚨 **Risk Assessment | تقييم المخاطر**

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Production Issues** | High | Medium | Comprehensive testing, monitoring, rollback plans |
| **Performance Degradation** | Medium | Medium | Performance budgets, monitoring, optimization |
| **Security Vulnerabilities** | High | Low | Security audits, penetration testing, updates |
| **Deployment Failures** | Medium | Medium | Automated testing, staging environment, rollback |

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../../00-Templates/13-generic-priority-framework.md) for priority levels and criteria.

### **Checklists & Quick Reference Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Basic production setup and essential monitoring
- **🔴 Critical**: Security basics and core checklist procedures
- **🟠 High**: Advanced monitoring and performance optimization

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Security hardening and advanced monitoring
- **🟠 High**: Performance optimization and advanced analytics
- **🟡 Medium**: Automation and advanced features

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: Advanced analytics and AI-powered checklist management
- **🟡 Medium**: Automation and advanced features
- **🟢 Low**: Advanced analytics and AI-powered reference management

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../../00-Templates/03-quality-gates-template.md) for standard quality criteria.

### **Checklists Reference Specific Quality Gates:**
- [ ] All checklists validated and tested
- [ ] Checklist templates updated and current
- [ ] Team adoption of checklists >90%
- [ ] Checklist completion rates tracked
- [ ] Regular review and improvement of checklists
- [ ] Integration with CI/CD pipeline working

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../../00-Templates/15-comprehensive-metrics-template.md) for topic-specific metrics.

### **Checklists Reference Specific Metrics:**
- **Checklist Usage**: 90%+ team adoption, 95% checklist completion rate
- **Process Efficiency**: 60% faster processes, 80% automation rate
- **Quality Improvement**: 70% fewer errors, 90% compliance rate
- **Team Productivity**: 50% faster onboarding, 70% less training time
- **Reference Accuracy**: 100% up-to-date references, <5% outdated content
- **User Satisfaction**: >90% user satisfaction with checklists and references


## 🏗️ **Architecture Checklists | قوائم مراجعة المعمارية**

### **1. Clean Architecture Implementation**

- [ ] **Separate layers**: Presentation / Application / Domain / Data
  - [ ] Repository + DTOs implemented
  - [ ] Error normalization in place
  - [ ] HTTP models hidden from UI
  - [ ] Caching layer added
  - [ ] **Pitfalls avoided**: UI tied to HTTP; no error mapping; stale cache

- [ ] **Feature-first folder structure** (features/catalog, features/cart…)
  - [ ] Layered modules implemented
  - [ ] Clear ownership & boundaries
  - [ ] Minimal public APIs
  - [ ] Architecture review completed
  - [ ] **Pitfalls avoided**: Coupling; circular deps; god classes; shared state

- [ ] **Repositories defined as abstract in Domain, implemented in Data**
  - [ ] Repository pattern properly implemented
  - [ ] DTOs for data transformation
  - [ ] Error normalization
  - [ ] HTTP models abstracted from UI
  - [ ] Caching strategy implemented

- [ ] **No business logic inside Widgets**
  - [ ] Business logic moved to controllers/notifiers
  - [ ] Widgets only handle UI concerns
  - [ ] State management properly implemented
  - [ ] Separation of concerns maintained

- [ ] **Document chosen architecture in ARCHITECTURE.md**
  - [ ] Architecture decisions documented
  - [ ] Layer responsibilities defined
  - [ ] Data flow diagrams included
  - [ ] Review process established

---

## 🔄 **State Management Checklists | قوائم مراجعة إدارة الحالة**

### **1. State Management Implementation**

- [ ] **Use one state management solution** across project (Riverpod or BLoC)
  - [ ] BLoC/Riverpod chosen and consistently used
  - [ ] Logic kept out of Widgets
  - [ ] Resources properly disposed
  - [ ] Unit/widget tests implemented
  - [ ] **Pitfalls avoided**: Mixed patterns; leaks; logic in UI; no disposal

- [ ] **StateNotifier/Controller for each feature** (Cart, Auth…)
  - [ ] Feature-specific state management
  - [ ] Clear state boundaries
  - [ ] Proper state updates
  - [ ] Error handling in state

- [ ] **Dependency Injection via Providers or get_it**
  - [ ] Single DI pattern used
  - [ ] Logic outside UI layer
  - [ ] Proper disposal implemented
  - [ ] Unit tests for DI

---

## 🧭 **Navigation Checklists | قوائم مراجعة التنقل**

### **1. Navigation Implementation**

- [ ] **Use go_router with Guards for protected routes**
  - [ ] Route map defined
  - [ ] Typed parameters implemented
  - [ ] Deep links configured
  - [ ] Back stack policy defined
  - [ ] **Pitfalls avoided**: Duplicate routes; back button bugs

- [ ] **Support Deep Links & Dynamic Links** (iOS/Android)
  - [ ] Route map configured
  - [ ] Typed parameters
  - [ ] Deep links working
  - [ ] Back stack policy

- [ ] **Document navigation flow** for critical features (Checkout, Login)
  - [ ] Central router implementation
  - [ ] Typed routes
  - [ ] Deep/universal links
  - [ ] Back stack rules

---

## 💾 **Data Layer Checklists | قوائم مراجعة طبقة البيانات**

### **1. Network & API Implementation**

- [ ] **Centralized network client** (Dio/Retrofit) with Interceptors/Timeouts
  - [ ] Owner & scope defined
  - [ ] Best practices implemented
  - [ ] Tests added
  - [ ] Verification documented
  - [ ] Acceptance criteria met

- [ ] **Retry policy with Exponential Backoff**
  - [ ] Retry logic implemented
  - [ ] Exponential backoff configured
  - [ ] Maximum retry limits set
  - [ ] Error handling for retries

- [ ] **Repositories for each domain** (Products, Cart, Orders, Auth)
  - [ ] Domain-specific repositories
  - [ ] Abstract interfaces defined
  - [ ] Data source abstraction
  - [ ] Error handling implemented

- [ ] **DTO ↔ Domain Models mapping** via Mappers
  - [ ] Mapper classes implemented
  - [ ] Data transformation logic
  - [ ] Validation in mappers
  - [ ] Error handling for mapping

- [ ] **Local Cache** (Hive/Drift/Isar) with Stale-While-Revalidate policy
  - [ ] Cache implementation
  - [ ] Stale-while-revalidate strategy
  - [ ] Cache invalidation logic
  - [ ] Performance optimization

---

## 🔒 **Security Checklists | قوائم مراجعة الأمان**

### **1. Data Security**

- [ ] **Store sensitive tokens** with flutter_secure_storage (Keychain/Keystore)
  - [ ] Secure storage implemented
  - [ ] HTTPS-only communication
  - [ ] No PII in logs
  - [ ] Session controls
  - [ ] **Pitfalls avoided**: Keys in repo; weak TLS; PII logging

- [ ] **Clear tokens and cache on logout**
  - [ ] Token cleanup implemented
  - [ ] Cache clearing on logout
  - [ ] Session invalidation
  - [ ] Security audit trail

- [ ] **Enable Firebase App Check** and send X-App-Check header
  - [ ] App Check configured
  - [ ] Headers properly set
  - [ ] Verification implemented
  - [ ] Security monitoring

- [ ] **Enforce HTTPS only + optional SSL Pinning**
  - [ ] HTTPS enforcement
  - [ ] SSL pinning configured
  - [ ] Certificate validation
  - [ ] Security headers

- [ ] **No secrets in Git** (use dart-define/CI secrets)
  - [ ] Environment variables used
  - [ ] CI secrets configured
  - [ ] Git hooks for secret detection
  - [ ] Security scanning

- [ ] **Disable backup for sensitive data** (Android allowBackup=false, iOS exclude)
  - [ ] Backup disabled for sensitive data
  - [ ] Platform-specific configuration
  - [ ] Data protection compliance
  - [ ] Security audit

- [ ] **Validate and sanitize Deep Link parameters**
  - [ ] Parameter validation
  - [ ] Input sanitization
  - [ ] Security checks
  - [ ] Error handling

---

## ⚡ **Performance Checklists | قوائم مراجعة الأداء**

### **1. Performance Targets**

- [ ] **Cold start ≤ 2.5s** on mid-range devices
  - [ ] Performance budgets set
  - [ ] Profiling completed
  - [ ] Images optimized
  - [ ] Monitoring implemented
  - [ ] **Pitfalls avoided**: Heavy rebuilds; sync I/O

- [ ] **First frame rendered < 2s**
  - [ ] Budgets & profiling
  - [ ] Heavy work offloaded
  - [ ] Images optimized
  - [ ] Production monitoring

- [ ] **Maintain FPS ≥ 55** in heavy lists
  - [ ] Performance budgets
  - [ ] Profiling completed
  - [ ] Images optimized
  - [ ] Monitoring active

- [ ] **App size ≤ 40MB**
  - [ ] Size budgets set
  - [ ] Profiling completed
  - [ ] Images optimized
  - [ ] Monitoring implemented

### **2. Performance Optimization**

- [ ] **Use const Widgets, split large Widgets**
  - [ ] Const constructors used
  - [ ] Large widgets split
  - [ ] Performance optimized
  - [ ] Monitoring active

- [ ] **Use cached_network_image and optimized assets**
  - [ ] Cached images implemented
  - [ ] Assets optimized
  - [ ] Performance monitored
  - [ ] Memory usage optimized

- [ ] **Regularly check build size** with --analyze-size
  - [ ] Size analysis regular
  - [ ] Budgets monitored
  - [ ] Optimizations applied
  - [ ] CI integration

---

## 🎨 **UI/UX Checklists | قوائم مراجعة واجهة المستخدم**

### **1. Design System Implementation**

- [ ] **Unified Theme and Design System** (Colors, Typography, Spacing, Radius)
  - [ ] Design system implemented
  - [ ] A11y + RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp
  - [ ] **Pitfalls avoided**: Inconsistent components; low contrast; small targets

- [ ] **Central Components Library** used in ≥ 80% of screens
  - [ ] Design tokens defined
  - [ ] A11y & RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp
  - [ ] **Pitfalls avoided**: Inconsistent UI; low contrast; RTL issues

- [ ] **RTL fully supported and tested**
  - [ ] RTL layout implemented
  - [ ] Text direction handling
  - [ ] Icon direction support
  - [ ] Testing completed

- [ ] **Skeleton / Empty / Error states standardized**
  - [ ] Design tokens used
  - [ ] A11y & RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp

- [ ] **Accessibility compliance**: semantics, contrast, touch targets
  - [ ] Design system implemented
  - [ ] A11y + RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp

- [ ] **Text scaling 1.3x, 1.6x works correctly**
  - [ ] Design tokens used
  - [ ] A11y & RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp

---

## 🧪 **Testing Checklists | قوائم مراجعة الاختبار**

### **1. Test Implementation**

- [ ] **Unit Tests for Domain/UseCases and Repositories**
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking
  - [ ] **Pitfalls avoided**: Flaky tests; network in unit tests; no gates

- [ ] **Widget Tests for major screens**
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Golden Tests for core UI components**
  - [ ] Design system testing
  - [ ] A11y + RTL support
  - [ ] Consistent spacing
  - [ ] Tap targets ≥ 48dp

- [ ] **Integration/E2E Tests for Checkout flow**
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Test coverage ≥ 70%**
  - [ ] Coverage targets met
  - [ ] CI integration
  - [ ] Regular monitoring
  - [ ] Quality gates

- [ ] **Performance and Accessibility tests included**
  - [ ] Budgets & profiling
  - [ ] Heavy work offloaded
  - [ ] Images optimized
  - [ ] Production monitoring

---

## 🚀 **CI/CD Checklists | قوائم مراجعة CI/CD**

### **1. CI/CD Implementation**

- [ ] **CI runs**: format, analyze, test, build
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Branch protection for main** (2 reviews + passing CI)
  - [ ] Declarative pipelines
  - [ ] Code signing
  - [ ] Lint/test integration
  - [ ] Artifacts management
  - [ ] **Pitfalls avoided**: Secrets leaked; manual signing

- [ ] **Flavors** (dev/stage/prod) with AppConfig injection
  - [ ] Declarative pipelines
  - [ ] Code signing
  - [ ] Lint/test integration
  - [ ] Artifacts management

- [ ] **Semantic Versioning + build number increment**
  - [ ] Declarative pipelines
  - [ ] Code signing
  - [ ] Lint/test integration
  - [ ] Artifacts management

- [ ] **Release notes documented** in CHANGELOG.md
  - [ ] Pipelines as code
  - [ ] Secure signing
  - [ ] Cache, lint, test
  - [ ] Artifacts & notes

- [ ] **Internal distribution** (Firebase App Distribution / TestFlight)
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Manual QA checklist** before release (RTL, Checkout, Offline)
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

---

## 📊 **Analytics Checklists | قوائم مراجعة التحليلات**

### **1. Analytics Implementation**

- [ ] **Integrate Firebase Analytics + GA4**
  - [ ] Consent gating implemented
  - [ ] Event dictionary maintained
  - [ ] user_id mapping
  - [ ] Purchase reconciliation
  - [ ] **Pitfalls avoided**: Ungated tracking; missing user_id; dup purchases

- [ ] **Maintain analytics_events.md dictionary**
  - [ ] Consent gate implemented
  - [ ] Dictionary maintained
  - [ ] user_id tracking
  - [ ] Reconciliation process

- [ ] **Core events tracked** (screen_view, view_item, add_to_cart, purchase)
  - [ ] Consent gate implemented
  - [ ] Dictionary maintained
  - [ ] user_id tracking
  - [ ] Reconciliation process

- [ ] **Custom events tracked** (coupon_applied, cod_selected)
  - [ ] Consent gate implemented
  - [ ] Dictionary maintained
  - [ ] user_id tracking
  - [ ] Reconciliation process

- [ ] **User Properties set** (user_id, app_version, city, language, payment)
  - [ ] Consent gate implemented
  - [ ] Dictionary maintained
  - [ ] user_id tracking
  - [ ] Reconciliation process

- [ ] **Validate events via DebugView** before release
  - [ ] Pipelines as code
  - [ ] Secure signing
  - [ ] Cache, lint, test
  - [ ] Artifacts & notes

---

## 📈 **Monitoring Checklists | قوائم مراجعة المراقبة**

### **1. Monitoring Implementation**

- [ ] **Crashlytics enabled + crash-free sessions ≥ 99.5%**
  - [ ] Crashlytics enabled
  - [ ] Alerts on thresholds
  - [ ] Structured logs
  - [ ] Incident playbook
  - [ ] **Pitfalls avoided**: Disabled in release; noisy logs; no alerts

- [ ] **Centralized Logger** (debug/info/warn/error)
  - [ ] Crashlytics enabled
  - [ ] Alerts on thresholds
  - [ ] Structured logs
  - [ ] Incident playbook

- [ ] **Global error handling** (runZonedGuarded + FlutterError.onError)
  - [ ] Crash/ANR alerts
  - [ ] Logs implemented
  - [ ] SLOs defined
  - [ ] Postmortems process

- [ ] **Performance Monitoring enabled** (startup, PDP load, scroll)
  - [ ] Budgets & profiling
  - [ ] Heavy work offloaded
  - [ ] Images optimized
  - [ ] Production monitoring

- [ ] **Internal developer-only health dashboard** (optional)
  - [ ] Crash/ANR alerts
  - [ ] Logs implemented
  - [ ] SLOs defined
  - [ ] Postmortems process

---

## 🔧 **Code Quality Checklists | قوائم مراجعة جودة الكود**

### **1. Code Quality Implementation**

- [ ] **Enable very_good_analysis or flutter_lints** with 0 warnings
  - [ ] Lints/format enforced
  - [ ] PR checks implemented
  - [ ] Debt backlog maintained
  - [ ] Refactors scheduled
  - [ ] **Pitfalls avoided**: Disabled lints; ignored warnings

- [ ] **dart format enforced in CI** (no diffs)
  - [ ] Formatter & lints enforced
  - [ ] PR checks implemented
  - [ ] Coverage targets set
  - [ ] Scheduled refactors
  - [ ] **Pitfalls avoided**: Disabled lints; ignored warnings; inconsistent style

- [ ] **Conventional Commits enforced**
  - [ ] Lints/format enforced
  - [ ] PR checks implemented
  - [ ] Debt backlog maintained
  - [ ] Refactors scheduled

- [ ] **PR Template includes checklist** (tests, screenshots, coverage)
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Each feature has README** with decisions and flow
  - [ ] Lints/format enforced
  - [ ] PR checks implemented
  - [ ] Debt backlog maintained
  - [ ] Refactors scheduled

- [ ] **No misc/utils folders**; every code belongs to core or feature
  - [ ] Lints/format enforced
  - [ ] PR checks implemented
  - [ ] Debt backlog maintained
  - [ ] Refactors scheduled

---

## ✅ **Definition of Done Checklists | قوائم مراجعة تعريف الإنجاز**

### **1. Definition of Done Criteria**

- [ ] **flutter analyze passes** with no warnings
  - [ ] Criteria defined
  - [ ] Evidence provided
  - [ ] Sign-off obtained
  - [ ] Gate implemented
  - [ ] **Pitfalls avoided**: No evidence; ambiguous done

- [ ] **Test coverage ≥ 70%** for affected files
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **Integration Test Checkout passes**
  - [ ] Unit→widget→integration strategy
  - [ ] Deterministic fixtures
  - [ ] CI gates implemented
  - [ ] Flakiness tracking

- [ ] **App size within limit** (≤ 40MB)
  - [ ] Criteria defined
  - [ ] Evidence provided
  - [ ] Sign-off obtained
  - [ ] Gate implemented

- [ ] **RTL + text scaling verified**
  - [ ] Criteria defined
  - [ ] Evidence provided
  - [ ] Sign-off obtained
  - [ ] Gate implemented

- [ ] **No secrets committed to repo**
  - [ ] Secure storage implemented
  - [ ] HTTPS-only communication
  - [ ] No PII in logs
  - [ ] Session controls

- [ ] **CI/CD pipeline fully green**
  - [ ] Pipelines as code
  - [ ] Secure signing
  - [ ] Cache, lint, test
  - [ ] Artifacts & notes

---

## 🏪 **Store Compliance Checklists | قوائم مراجعة امتثال المتجر**

### **1. iOS/Android Store Compliance**

- [ ] **App Privacy & Data Safety forms**: Ensure Apple App Privacy and Google Data Safety disclosures match SDK behavior and data flows
  - [ ] **Verification**: Store listing screenshots + SDK data mapping document
  - [ ] **Acceptance**: Legal review approved; store checks pass without warnings
  - [ ] Inventory data flows per SDK
  - [ ] Map data types/purposes to Apple/Google forms
  - [ ] Fill store disclosures; attach SDK matrix
  - [ ] Run pre-submission checks; update on any SDK change
  - [ ] **Pitfalls avoided**: Misreporting data; missing 3P SDKs; forms not updated after SDK change

- [ ] **ATT (iOS) & tracking consent**: Implement the iOS AppTrackingTransparency prompt with a clear value proposition and fallback
  - [ ] **Verification**: Real-device test on iOS; screenshot of prompt flow
  - [ ] **Acceptance**: Prompt appears correctly and is compliant with Apple guidelines
  - [ ] Show pre-prompt with value
  - [ ] Call requestTrackingAuthorization at a natural moment
  - [ ] Gate ad/analytics init on consent state
  - [ ] Log consent in analytics and settings
  - [ ] **Pitfalls avoided**: Prompt too early; SDKs initialized pre-consent; IDFA read before consent

- [ ] **SDK levels & packaging**: Update target/compile SDK; ship Android App Bundle (AAB); configure R8/ProGuard and signing
  - [ ] **Verification**: CI/CD build logs for Debug/Release
  - [ ] **Acceptance**: Builds pass and are eligible for store publishing
  - [ ] Set compile/target SDK to latest stable
  - [ ] Enable R8/ProGuard with reviewed keep rules
  - [ ] Sign AAB/IPA correctly; validate with bundletool/TestFlight
  - [ ] Fix all Play/App Store warnings
  - [ ] **Pitfalls avoided**: Outdated target; missing keep rules; debug signing; ignored warnings

---

## 🔐 **Privacy & Compliance Checklists | قوائم مراجعة الخصوصية والامتثال**

### **1. Privacy Implementation**

- [ ] **Consent screen/settings**: Provide a screen to grant/withdraw consent for analytics/ads collection
  - [ ] **Verification**: Recorded flow + GA4 events reflecting consent state
  - [ ] **Acceptance**: Consent changes propagate immediately to tracking
  - [ ] Build a single consent store (default=deny)
  - [ ] Expose toggles in Settings
  - [ ] Propagate states to GA4/ads/Crashlytics
  - [ ] Persist and audit changes
  - [ ] **Pitfalls avoided**: Default allow; toggles not wired; consent not propagated

- [ ] **Data deletion/export**: Offer in-app request for account data deletion/export with defined SLA
  - [ ] **Verification**: Support ticket trail + end-to-end test
  - [ ] **Acceptance**: User requests fulfilled within SLA
  - [ ] Add in-app request for delete/export
  - [ ] Verify identity, enqueue backend job
  - [ ] Export JSON/CSV; delete across services
  - [ ] Notify user within SLA
  - [ ] **Pitfalls avoided**: Manual-only; partial deletion; no SLA tracking

- [ ] **Privacy Policy & Terms**: Link updated Privacy Policy and Terms both in-app and on store pages
  - [ ] **Verification**: Working links + legal review
  - [ ] **Acceptance**: Same finalized version across app and stores
  - [ ] Host canonical, versioned docs
  - [ ] Link inside app (Settings/Onboarding) and stores
  - [ ] Provide AR/EN versions
  - [ ] Monitor for broken links
  - [ ] **Pitfalls avoided**: Broken links; mismatched versions; missing AR/EN

---

## 📱 **Push Notifications Checklists | قوائم مراجعة الإشعارات**

### **1. Push Notification Implementation**

- [ ] **Device token lifecycle**: Handle token refresh/unsubscribe and topics segmentation
  - [ ] **Verification**: FCM/APNs logs + subscribe/unsubscribe events
  - [ ] **Acceptance**: No message loss when token rotates
  - [ ] Handle token refresh & logout cleanup
  - [ ] Send token+user_id to backend
  - [ ] Manage topics subscribe/unsubscribe
  - [ ] Retry with backoff on failures
  - [ ] **Pitfalls avoided**: Token not refreshed; sent before login; no unsubscribe

- [ ] **Deep links from notifications**: Open precise screens and attribute opens to analytics
  - [ ] **Verification**: Deep-link tests + open event captured
  - [ ] **Acceptance**: 100% navigation to the intended screen
  - [ ] Register URI schemes & universal/app links
  - [ ] Centralize routing
  - [ ] Include campaign params; log open event
  - [ ] Test via adb/xcrun on real devices
  - [ ] **Pitfalls avoided**: Unverified links; wrong route; missing campaign params

---

## 🚩 **Remote Config & Feature Flags Checklists | قوائم مراجعة التكوين عن بُعد**

### **1. Feature Flags Implementation**

- [ ] **Feature flags and kill switch**: Use flags to enable/disable sensitive features without releasing a new build
  - [ ] **Verification**: Stage env toggle test
  - [ ] **Acceptance**: Instant disable/enable verified
  - [ ] Define flags + safe defaults
  - [ ] Evaluate early; guard risky paths
  - [ ] Restrict who can change prod flags
  - [ ] Document owner & rollback plan
  - [ ] **Pitfalls avoided**: No safe defaults; prod flags open; no rollback

---

## 🔄 **Offline & Sync Checklists | قوائم مراجعة العمل دون اتصال**

### **1. Offline Implementation**

- [ ] **Operations queue & idempotency**: Queue requests when offline and replay on reconnect; use idempotency keys for create actions
  - [ ] **Verification**: Network loss tests + duplicate prevention checks
  - [ ] **Acceptance**: No duplicate orders or lost actions
  - [ ] Queue writes offline (WorkManager/BGTasks)
  - [ ] Use idempotency keys for creates
  - [ ] Retry with exponential backoff
  - [ ] Reconcile server responses
  - [ ] **Pitfalls avoided**: Duplicate orders; no backoff; lost queue after kill

- [ ] **Conflict resolution & delta sync**: Implement conflict strategy and incremental (delta) syncing
  - [ ] **Verification**: Multi-user scenarios
  - [ ] **Acceptance**: Eventual consistency after sync
  - [ ] Track versions/updated_at
  - [ ] Use ETag/sync tokens
  - [ ] Send only changed fields
  - [ ] Apply domain-specific merge rules
  - [ ] **Pitfalls avoided**: Blind LWW; no updated_at; heavy full sync

---

## 💳 **Payments & Orders Checklists | قوائم مراجعة المدفوعات والطلبات**

### **1. Payment Implementation (COD)**

- [ ] **Duplicate order prevention**: Guard against multi-taps; enforce idempotent submit on order placement
  - [ ] **Verification**: Button mashing test + order logs
  - [ ] **Acceptance**: Zero duplicate orders
  - [ ] Disable CTA after first tap
  - [ ] Generate client idempotency key
  - [ ] Server returns existing order on repeat
  - [ ] Log duplicates for monitoring
  - [ ] **Pitfalls avoided**: Multi-tap allowed; server not idempotent; no dedupe logs

- [ ] **Local validation (Yemen)**: Validate phone formats, addresses, and cancel/return flows
  - [ ] **Verification**: QA acceptance cases
  - [ ] **Acceptance**: All local cases pass
  - [ ] Validate phone via libphonenumber
  - [ ] Normalize address fields
  - [ ] Implement state machine for cancel/return
  - [ ] Localize error messages
  - [ ] **Pitfalls avoided**: Wrong phone formats; poor errors; no Arabic

- [ ] **Payment gateway abstraction**: Abstract payment layer for future gateways with robust error handling
  - [ ] **Verification**: Fault injection tests
  - [ ] **Acceptance**: Graceful failure and recovery paths
  - [ ] Define PaymentProvider interface
  - [ ] Implement adapters per gateway
  - [ ] Normalize error enums & retries
  - [ ] Add circuit breaker/telemetry
  - [ ] **Pitfalls avoided**: UI holds business logic; no retries; no telemetry

---

## 🌐 **Localization Checklists | قوائم مراجعة التعدد اللغوي**

### **1. Localization Implementation**

- [ ] **ARB files & fallback**: Manage translations with a default fallback language
  - [ ] **Verification**: Build checks + UI spot checks
  - [ ] **Acceptance**: No missing strings at runtime
  - [ ] Keep translations in /lib/l10n
  - [ ] Run flutter gen-l10n
  - [ ] Set default locale & fallbacks
  - [ ] Enforce completeness in CI
  - [ ] **Pitfalls avoided**: Hardcoded strings; missing fallback; untranslated dynamic strings

- [ ] **Pseudo-localization & fonts**: Test text expansion and verify font licenses
  - [ ] **Verification**: RTL/LTR screenshots
  - [ ] **Acceptance**: No truncation or visual collisions
  - [ ] Build with pseudo strings
  - [ ] Inspect UI expansion (RTL/LTR)
  - [ ] Ship fonts with Arabic coverage
  - [ ] Track licenses
  - [ ] **Pitfalls avoided**: No expansion test; fonts without Arabic glyphs

---

## 🔧 **Quick Reference | المرجع السريع**

### **1. Flutter Commands**

```bash
# Project setup
flutter create my_app
flutter pub get
flutter pub upgrade

# Development
flutter run
flutter run --debug
flutter run --release
flutter hot reload (r)
flutter hot restart (R)

# Testing
flutter test
flutter test --coverage
flutter test integration_test/

# Building
flutter build apk
flutter build appbundle
flutter build ios
flutter build web

# Analysis
flutter analyze
flutter format
flutter doctor
```

### **2. Performance Budgets**

- **App Size**: ≤ 40MB
- **Cold Start**: ≤ 2.5s
- **Warm Start**: ≤ 500ms
- **Screen Load**: ≤ 200ms
- **Memory Usage**: ≤ 200MB
- **Jank**: ≤ 0.5%
- **FPS**: ≥ 55 in heavy lists

### **3. Test Coverage Targets**

- **Unit Tests**: ≥ 80%
- **Widget Tests**: ≥ 70%
- **Integration Tests**: ≥ 60%
- **Overall Coverage**: ≥ 70%

---

## 🔗 **الروابط ذات الصلة | Related Links**

- [قوالب الكود والأمثلة](26_Code_Templates.md)
- [دليل حل المشاكل](27_Troubleshooting.md)
- [دليل الترحيل](28_Migration_Guide.md)
- [مسرد المصطلحات والموارد](30_Glossary_Resources.md)

---

## 📚 **المراجع | References**

- [Flutter Best Practices](https://docs.flutter.dev/development/ui/widgets)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design Guidelines](https://m3.material.io/)

---

**🔴 ENHANCEMENT**: محتوى مأخوذ من الوثائق الأصلية
**🔵 SUGGESTION**: اقتراحات مبنية على الخبرة التقنية

---

## 🔗 **Navigation | التنقل**

[← Previous: Migration Guide](28_Migration_Guide.md)
**السابق: دليل الترحيل**
[Next: Glossary & Resources →](30_Glossary_Resources.md)
**التالي: المسرد والموارد**
[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**|[🏠 Home](/2025-Plans/)
**الرئيسية**

---
