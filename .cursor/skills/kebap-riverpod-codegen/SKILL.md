---
name: kebap-riverpod-codegen
description: Viết provider Riverpod 3 bằng riverpod_generator cho Kebap — provider hạ tầng, repository, stream đọc DB, notifier ghi, và override trong test. Dùng khi tạo hoặc sửa provider trong lib/core hoặc features/**/presentation.
---

# Riverpod 3 + codegen cho Kebap

Bám `.cursor/rules/riverpod-presentation.mdc` và `.cursor/rules/flutter-clean-architecture-lib.mdc`.

## Setup (M1)

- Packages: `flutter_riverpod`, `riverpod_annotation`; dev: `riverpod_generator`, `build_runner`.
- `main.dart`: `runApp(const ProviderScope(child: KebapApp()))`.
- Mỗi file provider có `part '<file>.g.dart';`.

## Mẫu

```dart
// Hạ tầng sống suốt app
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(openConnection());
  ref.onDispose(db.close);
  return db;
}

// Repository: data implement contract domain
@riverpod
WorkoutRepository workoutRepository(Ref ref) =>
    DriftWorkoutRepository(ref.watch(appDatabaseProvider));

// Đọc reactive
@riverpod
Stream<List<Workout>> recentWorkouts(Ref ref) =>
    ref.watch(workoutRepositoryProvider).watchRecent();

// Ghi: notifier gọi repository, không chứa công thức
@riverpod
class ActiveSession extends _$ActiveSession {
  @override
  FutureOr<Session?> build() => null;
}
```

## Quy tắc

- Riverpod 3 dùng `Ref` chung trong hàm provider (không còn `XxxRef`).
- Provider hạ tầng (DB, router) `keepAlive: true`; provider màn hình để autoDispose mặc định.
- Business logic (1RM, volume, so sánh) ở domain, provider chỉ gọi.
- UI dùng `ref.watch` để render, `ref.read(...notifier)` trong callback; xử lý `AsyncValue` bằng `switch` pattern.
- Không truyền `WidgetRef`/`Ref` xuống domain hay data.

## Test

```dart
final container = ProviderContainer(overrides: [
  appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory())),
]);
addTearDown(container.dispose);
```

Widget test: `ProviderScope(overrides: [...], child: ...)`.
