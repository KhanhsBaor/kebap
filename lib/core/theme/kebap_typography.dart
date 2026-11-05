import 'package:flutter/material.dart';

@immutable
class KebapTypography extends ThemeExtension<KebapTypography> {
  const KebapTypography({
    required this.entryNumber,
    required this.secondaryNumber,
  });

  final TextStyle entryNumber;
  final TextStyle secondaryNumber;

  static KebapTypography of(Color foreground) {
    return KebapTypography(
      entryNumber: TextStyle(
        fontFamily: 'BarlowCondensed',
        fontSize: 32,
        height: 36 / 32,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: foreground,
      ),
      secondaryNumber: TextStyle(
        fontFamily: 'BarlowCondensed',
        fontSize: 20,
        height: 24 / 20,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: foreground,
      ),
    );
  }

  @override
  KebapTypography copyWith({
    TextStyle? entryNumber,
    TextStyle? secondaryNumber,
  }) {
    return KebapTypography(
      entryNumber: entryNumber ?? this.entryNumber,
      secondaryNumber: secondaryNumber ?? this.secondaryNumber,
    );
  }

  @override
  KebapTypography lerp(KebapTypography? other, double t) {
    if (other is! KebapTypography) {
      return this;
    }
    return KebapTypography(
      entryNumber: TextStyle.lerp(entryNumber, other.entryNumber, t)!,
      secondaryNumber: TextStyle.lerp(
        secondaryNumber,
        other.secondaryNumber,
        t,
      )!,
    );
  }
}
