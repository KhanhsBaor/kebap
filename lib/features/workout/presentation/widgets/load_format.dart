import 'package:intl/intl.dart';

String formatKg(double kg, String languageCode) {
  final format = NumberFormat.decimalPattern(languageCode);
  format.minimumFractionDigits = 0;
  format.maximumFractionDigits = 1;
  return format.format(kg);
}

String formatSigned(num delta, String languageCode) {
  final formatted = delta is int
      ? delta.abs().toString()
      : formatKg(delta.abs().toDouble(), languageCode);
  if (delta > 0) return '+$formatted';
  if (delta < 0) return '-$formatted';
  return formatted;
}

double? parseKg(String text) {
  final normalized = text.trim().replaceAll(',', '.');
  if (normalized.isEmpty || normalized == '.') return null;
  return double.tryParse(normalized);
}

int? parseReps(String text) {
  final normalized = text.trim().replaceAll(',', '.');
  if (normalized.isEmpty || normalized == '.') return null;
  final value = double.tryParse(normalized);
  if (value == null) return null;
  return value.truncate();
}

bool sameKg(double? left, double? right) {
  if (left == null || right == null) return left == right;
  return (left - right).abs() < 0.05;
}
