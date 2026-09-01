import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF22D3C5);
  static const _secondary = Color(0xFF4F8CFF);
  static const _darkBackground = Color(0xFF08111F);
  static const _darkSurface = Color(0xFF101C2C);
  static const _darkSurfaceHigh = Color(0xFF17263A);
  static const _lightBackground = Color(0xFFF5F8FC);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightSurfaceHigh = Color(0xFFEAF0F7);
  static const _error = Color(0xFFF97066);

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF087E77),
          secondary: const Color(0xFF2357D5),
          surface: _lightSurface,
          surfaceContainerHighest: _lightSurfaceHigh,
          error: const Color(0xFFC93535),
          errorContainer: const Color(0xFFFFE2E0),
        );
    return _build(scheme, _lightBackground);
  }

  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _primary,
          secondary: _secondary,
          surface: _darkSurface,
          surfaceContainerHighest: _darkSurfaceHigh,
          error: _error,
          errorContainer: const Color(0xFF4A1F23),
        );
    return _build(scheme, _darkBackground);
  }

  static ThemeData _build(ColorScheme scheme, Color background) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
      ),
    );
  }
}
