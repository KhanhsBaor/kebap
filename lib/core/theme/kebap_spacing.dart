import 'package:flutter/material.dart';

@immutable
class KebapSpacing extends ThemeExtension<KebapSpacing> {
  const KebapSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.radiusControl,
    required this.radiusCard,
  });

  static const standard = KebapSpacing(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    radiusControl: 8,
    radiusCard: 12,
  );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double radiusControl;
  final double radiusCard;

  @override
  KebapSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? radiusControl,
    double? radiusCard,
  }) {
    return KebapSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      radiusControl: radiusControl ?? this.radiusControl,
      radiusCard: radiusCard ?? this.radiusCard,
    );
  }

  @override
  KebapSpacing lerp(KebapSpacing? other, double t) {
    if (other is! KebapSpacing) {
      return this;
    }
    return KebapSpacing(
      xs: _lerp(xs, other.xs, t),
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xl: _lerp(xl, other.xl, t),
      radiusControl: _lerp(radiusControl, other.radiusControl, t),
      radiusCard: _lerp(radiusCard, other.radiusCard, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
