# Tech Stack — Kebap

| Hạng mục | Chọn | Ghi chú |
|----------|------|---------|
| Framework | Flutter / Dart 3 | |
| Architecture | Clean Architecture, feature-first | `features/<f>/{presentation,domain,data}` |
| State / DI | Riverpod 3 + riverpod_generator | Không BLoC / GetIt |
| Local DB | Drift (SQLite) | Offline source of truth |
| Navigation | go_router | |
| Models | freezed | + build_runner |
| Charts | fl_chart | |
| Test | flutter_test, mocktail | DAO: NativeDatabase.memory() |

## Packages mục tiêu (thêm vào pubspec khi vào milestone code)

- `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- `drift`, `drift_dev`, `sqlite3_flutter_libs`, `path_provider`, `path`
- `go_router`
- `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable` (nếu cần)
- `fl_chart`
- `flutter_hooks` (state UI tạm)
- `mocktail` (dev)
- `build_runner` (dev)

## Lệnh

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```
