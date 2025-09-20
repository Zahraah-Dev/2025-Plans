# 6. مكتبة المكونات
## 6. Component Library

> **الجزء الأول: المعمارية والأنماط الأساسية | Part I: Architecture & Core Patterns**

## 🎯 **Objective | الهدف**
Create comprehensive reusable component library with consistent design patterns for Flutter e-commerce application.

## 📋 **Rule | القاعدة**
**Arabic**: مكونات قابلة لإعادة الاستخدام + تصميم متسق + APIs واضحة  
**English**: Reusable components + Consistent design + Clear APIs

## 💡 **Benefits | الفوائد**
- **Code Reusability | إعادة استخدام الكود**: Reduce development time with reusable components
- **Consistency | الاتساق**: Uniform component behavior across the app
- **Maintainability | سهولة الصيانة**: Single source of truth for component logic
- **Quality Assurance | ضمان الجودة**: Tested and validated components
- **Developer Experience | تجربة المطور**: Easy-to-use component APIs
- **Design System Compliance | الامتثال لنظام التصميم**: Enforce design standards

---

## 🔘 **Buttons | الأزرار**

### **1. Primary Button**
```dart
class AppButtons {
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
  }) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(text, style: AppTextStyles.labelLarge),
              ],
            ),
    );
  }
  
  static Widget secondary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
  }) {
    return OutlinedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(text, style: AppTextStyles.labelLarge),
              ],
            ),
    );
  }
}
```

---

## 🃏 **Cards | البطاقات**

### **1. Product Card**
```dart
class AppCards {
  static Widget product({
    required Widget child,
    VoidCallback? onTap,
    double? elevation,
  }) {
    return Card(
      elevation: elevation ?? AppLayout.elevationSM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        child: child,
      ),
    );
  }
  
  static Widget info({
    required String title,
    required String content,
    IconData? icon,
    Color? backgroundColor,
  }) {
    return Card(
      elevation: AppLayout.elevationXS,
      color: backgroundColor ?? AppColors.gray50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
      ),
      child: Padding(
        padding: AppLayout.paddingMD,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    content,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📝 **Input Fields | حقول الإدخال**

### **1. Text Input**
```dart
class AppInputs {
  static Widget textField({
    required String label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
              borderSide: const BorderSide(color: AppColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 🎨 **Themes | الثيمات**

### **1. Light Theme**
```dart
class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.light,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppLayout.elevationSM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusSM),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusSM),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
```

---

## 🔗 **Navigation | التنقل**

[← Previous: Color & Typography | السابق: الألوان والخطوط](06_Color_Typography.md)
[Next: RTL & Accessibility | التالي: دعم RTL وإمكانية الوصول →](06_RTL_Accessibility.md)
[🏠 Home | الرئيسية](../../../index.html)

---
