/// Last section whose top edge has reached or passed [viewportTop].
/// Falls back to the first measured section, then [groupIds].first.
int visibleMuscleGroupId({
  required List<int> groupIds,
  required Map<int, double> sectionTops,
  required double viewportTop,
}) {
  if (groupIds.isEmpty) return 0;
  int? lastPast;
  int? firstVisible;
  for (final id in groupIds) {
    final top = sectionTops[id];
    if (top == null) continue;
    firstVisible ??= id;
    if (top <= viewportTop + 1) lastPast = id;
  }
  return lastPast ?? firstVisible ?? groupIds.first;
}

/// Prefills S06 when the user searched and nothing matched.
String customExercisePrefill({
  required String query,
  required bool hasMatches,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty || hasMatches) return '';
  return trimmed;
}
