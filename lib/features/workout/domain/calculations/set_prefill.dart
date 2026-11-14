import 'package:kebap/features/workout/domain/entities/set_log.dart';

/// Lower bound of the general-health rep range (docs/01) until a profile exists.
const generalHealthMinReps = 8;

/// Suggested kg and reps for one unsaved row. docs/05 mục 1.
class SetLoadSuggestion {
  const SetLoadSuggestion({this.kg, this.reps});

  final double? kg;
  final int? reps;
}

/// Priority: the saved set just before this row, then the same position in
/// the reference session, then the general-health minimum while the row is
/// still inside the plan, otherwise empty.
SetLoadSuggestion suggestSetLoad({
  required int position,
  required List<SetLog> savedSets,
  required List<SetLog> referenceSets,
  required int plannedSetCount,
}) {
  final previous = _at(savedSets, position - 1);
  if (previous != null) {
    return SetLoadSuggestion(kg: previous.kg, reps: previous.reps);
  }
  final reference = _at(referenceSets, position);
  if (reference != null) {
    return SetLoadSuggestion(kg: reference.kg, reps: reference.reps);
  }
  if (position >= 1 && position <= plannedSetCount) {
    return const SetLoadSuggestion(reps: generalHealthMinReps);
  }
  return const SetLoadSuggestion();
}

SetLog? _at(List<SetLog> sets, int position) {
  for (final set in sets) {
    if (set.position == position) return set;
  }
  return null;
}
