# 6. نظام التصميم والثيمات
## 6. Design System & Theming

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Implement unified design system with consistent theming, reusable components, and full RTL support for Arabic e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: Theme واحد + Tokens (ألوان/هوامش/زوايا/Typography) + Widgets مشتركة (Buttons, Cards…)  
**English**: One Theme + Tokens (Colors/Spacing/Radius/Typography) + Shared Widgets (Buttons, Cards…)

## 💡 **Benefits | الفوائد**
- **Consistency | الاتساق**: Uniform look and feel across entire application
- **Maintainability | سهولة الصيانة**: Easy to update design globally with single change
- **Development Speed | سرعة التطوير**: Reusable components reduce development time
- **Brand Identity | الهوية التجارية**: Consistent brand representation and recognition
- **User Experience | تجربة المستخدم**: Familiar patterns and intuitive interface
- **Accessibility | إمكانية الوصول**: Built-in accessibility features and RTL support

## 🛠️ **Implementation | التطبيق**
- **Use in**: All UI components, screens, and user interactions
- **How to implement**:
  - Create centralized theme configuration
  - Define design tokens (colors, spacing, typography, radius)
  - Build reusable component library
  - Implement comprehensive RTL support
  - Add accessibility features
  - Create component documentation
- **Result**: Consistent, maintainable, and accessible UI system

## ✅ **Success Criteria | معايير النجاح**
- [ ] 80%+ screens use shared components
- [ ] Consistent spacing and typography across app
- [ ] RTL support working correctly in all screens
- [ ] Easy to update design globally
- [ ] Accessibility compliance (screen readers, contrast)
- [ ] Component library documented and maintained

## ⚠️ **Common Pitfalls | الأخطاء الشائعة**
- **Avoid**: Inconsistent component usage across screens
- **Avoid**: Hardcoded colors, spacing, and typography
- **Avoid**: RTL layout issues and text direction problems
- **Avoid**: Duplicate component creation instead of reusing
- **Avoid**: Missing accessibility features
- **Avoid**: Inconsistent component APIs and props

---

---

## 🚨 **Risk Assessment | تقييم المخاطر**

> **Reference**: See [Risk Assessment Template](../00-Templates/01_Risk_Assessment_Template.md) for standard risk categories.

### **Design System Specific Risks:**
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|-------------------|
| **Design Inconsistency** | High | Medium | Design system enforcement, component library |
| **RTL Layout Issues** | High | Medium | RTL testing, proper layout direction |
| **Accessibility Problems** | Medium | High | Accessibility testing, screen reader support |
| **Performance Issues** | Medium | High | Component optimization, lazy loading |
| **Maintenance Overhead** | Medium | High | Component documentation, versioning |
| **Brand Inconsistency** | High | Low | Brand guidelines, design review process |

## 🎯 **Specific Priorities | الأولويات المحددة**

> **Framework**: See [Generic Priority Framework](../00-Templates/13_Generic_Priority_Framework.md) for priority levels and criteria.

### **Design System Specific Priorities:**
#### **Phase 1: Foundation | المرحلة الأولى: الأساس**
- **🔴 Critical**: Design tokens definition (colors, spacing, typography)
- **🔴 Critical**: Basic component library creation and theme configuration
- **🟠 High**: RTL support implementation and accessibility features

#### **Phase 2: Enhancement | المرحلة الثانية: التحسين**
- **🟠 High**: Advanced component library and component documentation
- **🟠 High**: Design system testing and accessibility compliance
- **🟡 Medium**: Performance optimization and advanced theming features

#### **Phase 3: Optimization | المرحلة الثالثة: التحسين**
- **🟡 Medium**: Design system automation and component analytics
- **🟡 Medium**: Advanced theming features and performance optimization
- **🟢 Low**: AI-assisted design generation and advanced analytics

## 🚪 **Quality Gates | بوابات الجودة**

> **Reference**: See [Quality Gates Template](../00-Templates/03_Quality_Gates_Template.md) for standard quality criteria.

### **Design System Specific Quality Gates:**
- [ ] 80%+ screens use shared components
- [ ] Consistent spacing and typography across app
- [ ] RTL support working correctly in all screens
- [ ] Easy to update design globally
- [ ] Accessibility compliance (screen readers, contrast)
- [ ] Component library documented and maintained
- [ ] Design tokens properly implemented

## 📈 **Success Metrics | مؤشرات النجاح**

> **Reference**: See [Comprehensive Metrics Template](../00-Templates/15_Comprehensive_Metrics_Template.md) for topic-specific metrics.

### **Design System Specific Metrics:**
- **Component Reuse**: 80%+ of screens use shared components
- **Design Consistency**: 100% adherence to design tokens
- **RTL Support**: 100% of screens RTL-compliant
- **Accessibility**: 100% accessibility compliance
- **Maintainability**: <1 hour to update design globally
- **Developer Experience**: Easy component discovery and usage

---

## 🏗️ **Design System Architecture | معمارية نظام التصميم**

### **1. Design System Structure | هيكل نظام التصميم**
```
lib/design_system/
├── tokens/
│   ├── colors.dart
│   ├── typography.dart
│   ├── spacing.dart
│   └── borders.dart
├── components/
│   ├── buttons/
│   ├── inputs/
│   ├── cards/
│   └── navigation/
├── themes/
│   ├── light_theme.dart
│   ├── dark_theme.dart
│   └── rtl_theme.dart
└── utilities/
    ├── responsive.dart
    ├── accessibility.dart
    └── animations.dart
```

### **2. Design System Principles | مبادئ نظام التصميم**
- **Consistency**: Uniform design language across all screens
- **Reusability**: Components used consistently throughout app
- **Scalability**: Easy to extend and maintain
- **Accessibility**: Built-in accessibility features
- **RTL Support**: Full right-to-left layout support
- **Performance**: Optimized for mobile devices

## 🎨 **Color & Typography | الألوان والطباعة**

### **1. Color System | نظام الألوان**
```dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFEC4899);
  static const Color secondaryDark = Color(0xFFDB2777);
  static const Color secondaryLight = Color(0xFFF472B6);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray900 = Color(0xFF111827);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
```

### **2. Typography System | نظام الطباعة**
```dart
class AppTypography {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
}
```

## 🧩 **Components | المكونات**

### **1. Button Components | مكونات الأزرار**
```dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  
  const AppButton({
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

enum AppButtonType { primary, secondary, outline, text }
enum AppButtonSize { small, medium, large }
```

### **2. Card Components | مكونات البطاقات**
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onTap;
  
  const AppCard({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
```

## ♿ **RTL & Accessibility | النص من اليمين لليسار وإمكانية الوصول**

### **1. RTL Support | دعم النص من اليمين لليسار**
```dart
class RTLWrapper extends StatelessWidget {
  final Widget child;
  final bool forceRTL;
  
  const RTLWrapper({
    required this.child,
    this.forceRTL = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = forceRTL || locale.languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
```

### **2. Accessibility Features | ميزات إمكانية الوصول**
```dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? semanticHint;
  
  const AccessibleButton({
    required this.text,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
```

---

**Last Updated | آخر تحديث**: January 2025  
**Version | الإصدار**: 2.0 - Enhanced Design System  
**Status | الحالة**: ✅ Production Ready

---

## 🔗 **Navigation | التنقل**

[← Previous: Presentation Layer | السابق: طبقة العرض](05_Presentation_Layer.md)
[Next: Project Setup & Configuration | التالي: إعداد المشروع والتكوين →](../02-Implementation/07_Project_Setup_Config.md)
[🏠 Home | الرئيسية](../../index.html)

### **Quick Navigation | التنقل السريع**
- [Design System Architecture | معمارية نظام التصميم](#-design-system-architecture--معمارية-نظام-التصميم)
- [Color & Typography | الألوان والطباعة](#-color--typography--الألوان-والطباعة)
- [Components | المكونات](#-components--المكونات)
- [RTL & Accessibility | النص من اليمين لليسار وإمكانية الوصول](#-rtl--accessibility--النص-من-اليمين-ليسار-وإمكانية-الوصول)

### **Related Files | الملفات ذات الصلة**
- [Presentation Layer | طبقة العرض](05_Presentation_Layer.md)
- [Architecture Overview | نظرة عامة على المعمارية](01_Architecture_Overview.md)
- [State Management & DI | إدارة الحالة وحقن التبعية](02_State_Management_DI.md)

### **Shared Architecture Resources | موارد المعمارية المشتركة**
- [Quality Standards | معايير الجودة](Quality_Standards.md)
- [Testing Strategy | استراتيجية الاختبار](Testing_Strategy.md)
- [Troubleshooting Guide | دليل استكشاف الأخطاء](Troubleshooting_Guide.md)
- [Best Practices | أفضل الممارسات](Best_Practices.md)
- [Success Criteria | معايير النجاح](Success_Criteria.md)

---