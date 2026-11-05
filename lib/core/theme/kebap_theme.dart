import 'package:flutter/material.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/core/theme/kebap_typography.dart';

abstract final class KebapTheme {
  static ThemeData light() => _build(KebapColors.light, Brightness.light);

  static ThemeData dark() => _build(KebapColors.dark, Brightness.dark);

  static ThemeData _build(KebapColors colors, Brightness brightness) {
    final spacing = KebapSpacing.standard;
    final typography = KebapTypography.of(colors.foreground);
    final onError = brightness == Brightness.light
        ? KebapColors.light.background
        : KebapColors.dark.onPrimary;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.muted,
      onSecondary: colors.background,
      error: colors.trendDown,
      onError: onError,
      surface: colors.surface,
      onSurface: colors.foreground,
      outline: colors.border,
    );
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(spacing.radiusCard),
      side: BorderSide(color: colors.border),
    );
    final textTheme = TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        color: colors.foreground,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: colors.foreground,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: colors.muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Barlow',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colors.foreground, size: 24),
      extensions: [colors, spacing, typography],
      splashFactory: NoSplash.splashFactory,
      highlightColor: colors.foreground.withValues(alpha: 0.08),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        shape: cardShape,
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(48, 48),
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusCard),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: colors.surface,
        indicatorColor: colors.border,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: selected ? colors.foreground : colors.muted,
          );
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(spacing.radiusCard),
          ),
          side: BorderSide(color: colors.border),
        ),
      ),
    );
  }
}
