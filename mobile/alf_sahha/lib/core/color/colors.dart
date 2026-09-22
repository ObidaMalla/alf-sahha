import 'dart:ui';

/// ============================================================
/// 🎨 RESTAURANT APP — DARK THEME PALETTE
/// خلفيات غامقة (~70%) + ألوان فاقعة نارية/ذهبية (~30%)
/// ============================================================
abstract class AppColors {
  // ============================================================
  // 🖤 BACKGROUNDS — التدرجات الغامقة الأساسية
  // ============================================================
  static const Color backgroundColor = Color(0xFF0B0B0F); // أسود عميق دافئ
  static const Color backgroundSecondary = Color(0xFF121116); // طبقة أعمق شوي
  static const Color cardColor = Color(0xFF1A1820); // خلفية الكروت
  static const Color surfaceColor = Color(
    0xFF211E28,
  ); // أسطح مرتفعة (Sheets, Dialogs)
  static const Color inputColor = Color(0xFF17151C); // خلفية حقول الإدخال

  // ============================================================
  // 🔥 PRIMARY ACCENT — نار/بهارات (اللون الفاقع الأساسي)
  // ============================================================
  static const Color accentColor = Color(0xFFB31217); // أحمر دامي
  static const Color accentColorDeep = Color(0xFF6A040F);

  static const Color spicyColor = Color(0xFFD00000); // نسخة أغمق للضغط/الظل
  static const Color accentColorSoft = Color(
    0x33FF5A36,
  ); // شفاف خفيف (خلفيات/توهج)

  // ============================================================
  // ✨ SECONDARY ACCENT — ذهبي فاخر
  // ============================================================
  static const Color goldColor = Color(0xFFFFC93C); // ذهبي دافئ
  static const Color goldColorDeep = Color(0xFFE0A800);
  static const Color goldColorSoft = Color(0x33FFC93C);

  // ============================================================
  // 🌶️ TERTIARY ACCENT — أحمر توابل (تحذيرات/حار)
  // ============================================================
  static const Color spicyColorSoft = Color(0x33FF2E4D);

  // ============================================================
  // 🌿 SUCCESS / FRESH — أخضر منعش
  // ============================================================
  static const Color successColor = Color(0xFF2ECC71);
  static const Color freshColor = Color(0xFF3DDC97); // للعناصر "طازج/صحي"

  // ============================================================
  // ⚠️ STATUS COLORS
  // ============================================================
  static const Color errorColor = Color(0xFFFF4757);
  static const Color dangerColor = Color(0xFFFF4757);
  static const Color warningColor = Color(0xFFFFB020);
  static const Color infoColor = Color(0xFF3FA9F5);

  // ============================================================
  // 🔤 TEXT COLORS
  // ============================================================
  static const Color textPrimary = Color(
    0xFFF5F3F0,
  ); // أبيض دافئ (مو أبيض ناصع)
  static const Color textSecondary = Color(0xFFA8A3AD); // رمادي دافئ
  static const Color textMuted = Color(
    0xFF6E6875,
  ); // رمادي خافت للتفاصيل الصغيرة
  static const Color hintColor = Color(0xFF5C5763);
  static const Color footerColor = Color(0xFF4A4650);

  // ============================================================
  // 🧱 BORDERS & DIVIDERS
  // ============================================================
  static const Color borderColor = Color(0xFF2C2833);
  static const Color borderColorLight = Color(0xFF3A3542);
  static const Color dividerColor = Color(0xFF221F27);

  // ============================================================
  // 🌈 GRADIENTS — للكروت والأزرار المميزة
  // ============================================================
  static const List<Color> fireGradient = [
    Color(0xFFB31217),
    Color(0xFF6A040F),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFFC93C),
    Color(0xFFE0A800),
  ];

  static const List<Color> darkGlassGradient = [
    Color(0xFF211E28),
    Color(0xFF17151C),
  ];

  // ============================================================
  // 🍽️ CATEGORY TAG COLORS — لتصنيفات الأطباق (اختياري لكن مفيد)
  // ============================================================
  static const Color mainDishColor = Color(0xFFFF5A36); // أطباق رئيسية
  static const Color dessertColor = Color(0xFFFF7EB6); // حلويات
  static const Color drinkColor = Color(0xFF3FA9F5); // مشروبات
  static const Color appetizerColor = Color(0xFF3DDC97); // مقبلات

  // ============================================================
  // 💫 SHADOWS & GLOW
  // ============================================================
  static Color accentGlow(double opacity) => accentColor.withOpacity(opacity);
  static Color goldGlow(double opacity) => goldColor.withOpacity(opacity);
}
