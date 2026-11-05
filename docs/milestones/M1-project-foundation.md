# M1 — Khung dự án

**Trạng thái:** done  
**Phụ thuộc:** M0  
**Demo cuối milestone:** `flutter run` → shell app (theme + vài route placeholder), `flutter analyze` + `flutter test` xanh; CI chạy được trên PR/push.

## Mục tiêu và giá trị

Gắn stack mục tiêu vào repo và tạo xương sống chạy được: thư mục feature-first, Drift DB rỗng + migration, go_router, theme, Riverpod root, CI cơ bản.  
**Giá trị:** mọi milestone sau chỉ thêm lát cắt nghiệp vụ, không phải tranh luận lại “đặt file ở đâu / DB khởi tạo thế nào”.

## Trong phạm vi

- Cấu trúc `lib/core/` + `lib/features/` (có thể feature placeholder rỗng)
- Dependencies theo `docs/02-tech-stack.md` (Riverpod, Drift, go_router, freezed, …)
- Drift: `AppDatabase` schema v1 (bảng khung catalog + buổi + set, không seed, không DAO nghiệp vụ)
- `ProviderScope` + database provider
- go_router: 3 tab placeholder theo `docs/design/screens.md` (Hôm nay, Tiến trình, Lịch sử). Màn đang tập không nằm trong tab
- Theme theo token `docs/07-ui-system.md` (sáng và tối, mặc định theo hệ thống; không dùng seed color mặc định)
- l10n EN/VI (`gen-l10n`) cho nhãn và câu trống của 3 tab
- CI: GitHub Actions — `flutter pub get`, `build_runner`, `dart format`, `flutter analyze`, `flutter test`
- Smoke test: app / router / DB memory mở được

## Ngoài phạm vi

- Log set, so sánh, chart, lịch tuần
- Seed bài tập / nhóm cơ đầy đủ
- Thiết kế lại token (đã chốt ở `docs/07`) hoặc dựng màn nghiệp vụ giả
- Store listing, signing, flavors

## Checklist task (1 chat / task)

- [x] Thêm packages mục tiêu vào `pubspec.yaml` + `flutter pub get`
- [x] Tạo cây thư mục `lib/core/{db,router,theme}` và `lib/features/` (placeholder)
- [x] Drift `AppDatabase` + schema v1 + mở DB (path_provider); test `NativeDatabase.memory()`
- [x] Riverpod: `main.dart` bọc `ProviderScope`, provider expose DB
- [x] go_router shell 3 tab (Hôm nay, Tiến trình, Lịch sử); gắn vào `MaterialApp.router`
- [x] Theme sáng + tối theo `docs/07`; áp dụng trên app (`ThemeMode.system`)
- [x] Setup l10n EN/VI (gen-l10n, `app_en.arb` + `app_vi.arb`) cho nhãn 3 tab
- [x] `build_runner` chạy sạch cho Drift/Riverpod (và freezed nếu đã có model mẫu)
- [x] CI GitHub Actions (hoặc tương đương): analyze + test
- [x] Smoke widget/unit test tối thiểu + cập nhật trạng thái ROADMAP khi xong

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift tables | `regions`, `muscle_groups`, `exercises`, `workouts`, `workout_muscle_groups`, `workout_exercises`, `sets`; migration hook sẵn; không seed |
| Providers | `appDatabaseProvider` (hoặc tương đương), router nếu cần |
| Màn hình | Placeholder S01 Hôm nay, S02 Tiến trình, S03 Lịch sử |

## Definition of Done

- [x] `flutter analyze` không error
- [x] `flutter test` xanh (ít nhất: DB memory mở; smoke widget hoặc router)
- [x] CI config có trong repo và mô tả cách chạy local trong milestone notes / README ngắn nếu cần
- [x] Demo: app launch → chuyển tab/route placeholder được
- [x] Không có màn hình nghiệp vụ “giả hoàn chỉnh” — chỉ khung

## Rủi ro và câu hỏi còn mở

Đã chốt 2026-11-05 khi bắt đầu M1 (chi tiết: `memory/decisions.md`):

- CI: GitHub Actions, repo `KhanhsBaor/kebap`. Workflow: `flutter pub get` → `build_runner` → `dart format` → `flutter analyze` → `flutter test`.
- Schema v1: bảng khung `regions`, `muscle_groups`, `exercises`, `workouts`, `workout_muscle_groups`, `workout_exercises`, `sets`. Khóa `int` autoincrement. Quan hệ `workouts` → `workout_exercises` → `sets`. Không seed. `splitDayId` nullable, chưa khóa ngoại (lịch thuộc M5).
- Máy demo chính: iOS simulator. App vẫn phải chạy được trên Android.
- l10n: `gen-l10n`, `app_en.arb` + `app_vi.arb` cho nhãn và câu trống của 3 tab. Tên region / nhóm cơ / bài không vào ARB.

Không còn câu hỏi mở cho M1.

## Chạy local

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

CI giống các lệnh trên, file `.github/workflows/ci.yml`, chạy khi push và pull request. Không build iOS/Android trên CI.

Schema dump nằm ở `drift_schemas/`. `dart run drift_dev make-migrations` chỉ sinh test migration khi schema lên version 2 trở đi. Version 1 được kiểm tra bằng `test/core/db/app_database_test.dart`.

Máy demo chính: iOS simulator (`flutter run`). Android dùng cùng codebase.
