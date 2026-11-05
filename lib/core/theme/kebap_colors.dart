import 'package:flutter/material.dart';

@immutable
class KebapColors extends ThemeExtension<KebapColors> {
  const KebapColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.foreground,
    required this.muted,
    required this.border,
    required this.trendUp,
    required this.trendDown,
    required this.focusRing,
  });

  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color foreground;
  final Color muted;
  final Color border;
  final Color trendUp;
  final Color trendDown;
  final Color focusRing;

  static const light = KebapColors(
    primary: Color(0xFFF97316),
    onPrimary: Color(0xFF0F172A),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    foreground: Color(0xFF0F172A),
    muted: Color(0xFF475569),
    border: Color(0xFFE2E8F0),
    trendUp: Color(0xFF15803D),
    trendDown: Color(0xFFB91C1C),
    focusRing: Color(0xFFF97316),
  );

  static const dark = KebapColors(
    primary: Color(0xFFF97316),
    onPrimary: Color(0xFF0F172A),
    background: Color(0xFF111827),
    surface: Color(0xFF1F2937),
    foreground: Color(0xFFF8FAFC),
    muted: Color(0xFFCBD5E1),
    border: Color(0xFF374151),
    trendUp: Color(0xFF4ADE80),
    trendDown: Color(0xFFF87171),
    focusRing: Color(0xFFF97316),
  );

  @override
  KebapColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? foreground,
    Color? muted,
    Color? border,
    Color? trendUp,
    Color? trendDown,
    Color? focusRing,
  }) {
    return KebapColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      foreground: foreground ?? this.foreground,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      trendUp: trendUp ?? this.trendUp,
      trendDown: trendDown ?? this.trendDown,
      focusRing: focusRing ?? this.focusRing,
    );
  }

  @override
  KebapColors lerp(KebapColors? other, double t) {
    if (other is! KebapColors) {
      return this;
    }
    return KebapColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      trendUp: Color.lerp(trendUp, other.trendUp, t)!,
      trendDown: Color.lerp(trendDown, other.trendDown, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
    );
  }
}
