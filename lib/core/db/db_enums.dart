enum ExerciseEquipment { barbell, dumbbell, machine, cable, bodyweight, other }

enum WorkoutStatus {
  inProgress,
  completed;

  String get storageValue => switch (this) {
    WorkoutStatus.inProgress => 'in_progress',
    WorkoutStatus.completed => 'completed',
  };

  static WorkoutStatus fromStorage(String value) {
    return switch (value) {
      'in_progress' => WorkoutStatus.inProgress,
      'completed' => WorkoutStatus.completed,
      _ => throw ArgumentError.value(value, 'value', 'Unknown workout status'),
    };
  }
}
