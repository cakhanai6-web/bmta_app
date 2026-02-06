import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// BMTA (브타) 디자인 시스템 기반 앱 테마.
///
/// - Main: Connect Blue  (#2563EB)
/// - Accent: Mobility Amber (#F59E0B)
/// - Text: Deep Slate (#1E293B)
/// - Background: Soft Light (#F8FAFC)
/// - Input Fill: (#F1F5F9)
///
/// 또한 8px 여백 시스템과 16px 라운드 값을 ThemeExtension으로 제공합니다.
final class AppTheme {
  AppTheme._();

  static const Color _connectBlue = Color(0xFF2563EB);
  static const Color _mobilityAmber = Color(0xFFF59E0B);
  static const Color _deepSlate = Color(0xFF1E293B);
  static const Color _softLight = Color(0xFFF8FAFC);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _inputFill = Color(0xFFF1F5F9);
  static const Color _outline = Color(0xFFE2E8F0); // slate-200
  static const Color _muted = Color(0xFF64748B); // slate-500
  static const Color _error = Color(0xFFEF4444); // red-500

  static const double _radiusMd = 16;

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _connectBlue,
      onPrimary: Colors.white,
      secondary: _mobilityAmber,
      onSecondary: _deepSlate,
      error: _error,
      onError: Colors.white,
      surface: _surface,
      onSurface: _deepSlate,
      outline: _outline,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _softLight,
      canvasColor: _softLight,
      splashFactory: InkSparkle.splashFactory,
      fontFamily: 'Pretendard',
      extensions: const <ThemeExtension<dynamic>>[
        AppSpacing(),
        AppRadii(),
      ],
    );

    final textTheme = base.textTheme.copyWith(
      titleLarge: base.textTheme.titleLarge?.copyWith(
        color: _deepSlate,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        color: _deepSlate,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        color: _deepSlate,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        color: _deepSlate,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(
        color: _muted,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );

    final radius16 = BorderRadius.circular(_radiusMd);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _deepSlate,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: _deepSlate,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius16,
          side: const BorderSide(color: _outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: _outline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: _deepSlate),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _connectBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: radius16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _connectBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _connectBlue.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(44, 44), // 터치 영역 확보
          shape: RoundedRectangleBorder(borderRadius: radius16),
          elevation: 1,
          shadowColor: _connectBlue.withValues(alpha: 0.18),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _connectBlue,
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(borderRadius: radius16),
          side: const BorderSide(color: _connectBlue, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _connectBlue,
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: radius16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _inputFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: _muted,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: const BorderSide(color: _connectBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: const BorderSide(color: _error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: const BorderSide(color: _error, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _deepSlate,
        contentTextStyle: const TextStyle(
          fontFamily: 'Pretendard',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: radius16),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius16),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius16),
        titleTextStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: _deepSlate,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: _deepSlate,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: _connectBlue.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            fontSize: 12,
            color: states.contains(WidgetState.selected) ? _deepSlate : _muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color:
                states.contains(WidgetState.selected) ? _connectBlue : _muted,
          ),
        ),
      ),
    );
  }
}

/// 8px 기반 여백 시스템.
///
/// 디자인 가이드의 "터치 대상 간 간격 최소 8px" 원칙을 쉽게 지키기 위해
/// 테마에서 spacing scale을 제공합니다.
@immutable
final class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({this.base = 8});

  /// 8px 기준 단위.
  final double base;

  double get x0 => 0;
  double get x0_5 => base * 0.5; // 4
  double get x1 => base; // 8
  double get x1_5 => base * 1.5; // 12
  double get x2 => base * 2; // 16
  double get x2_5 => base * 2.5; // 20
  double get x3 => base * 3; // 24
  double get x4 => base * 4; // 32
  double get x5 => base * 5; // 40
  double get x6 => base * 6; // 48

  EdgeInsets all(double v) => EdgeInsets.all(v);
  EdgeInsets h(double v) => EdgeInsets.symmetric(horizontal: v);
  EdgeInsets v(double v) => EdgeInsets.symmetric(vertical: v);
  EdgeInsets hv({required double h, required double v}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  @override
  AppSpacing copyWith({double? base}) => AppSpacing(base: base ?? this.base);

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(base: lerpDouble(base, other.base, t) ?? base);
  }
}

/// 16px 기본 라운드 시스템.
@immutable
final class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({this.md = 16});

  /// 기본 라운드(요청: 16px).
  final double md;

  BorderRadius get rMd => BorderRadius.circular(md);

  @override
  AppRadii copyWith({double? md}) => AppRadii(md: md ?? this.md);

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(md: lerpDouble(md, other.md, t) ?? md);
  }
}

extension AppThemeX on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
  AppRadii get radii => Theme.of(this).extension<AppRadii>()!;
}

