import 'package:flutter/widgets.dart';

/// Catalog display name. Vietnamese uses [nameVi] when it is filled in.
String catalogName({
  required String nameEn,
  required String? nameVi,
  required Locale locale,
}) {
  if (locale.languageCode == 'vi') {
    final vietnamese = nameVi?.trim();
    if (vietnamese != null && vietnamese.isNotEmpty) return vietnamese;
  }
  return nameEn;
}
