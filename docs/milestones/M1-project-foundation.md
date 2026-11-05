# M1 — Khung dự án

**Trạng thái:** doing  
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

- [ ] Thêm packages mục tiêu vào `pubspec.yaml` + `flutter pub get`
- [ ] Tạo cây thư mục `lib/core/{db,router,theme}` và `lib/features/` (placeholder)
- [ ] Drift `AppDatabase` + schema v1 + mở DB (path_provider); test `NativeDatabase.memory()`
- [ ] Riverpod: `main.dart` bọc `ProviderScope`, provider expose DB
- [ ] go_router shell 3 tab (Hôm nay, Tiến trình, Lịch sử); gắn vào `MaterialApp.router`
- [ ] Theme sáng + tối theo `docs/07`; áp dụng trên app (`ThemeMode.system`)
- [ ] Setup l10n EN/VI (gen-l10n, `app_en.arb` + `app_vi.arb`) cho nhãn 3 tab
- [ ] `build_runner` chạy sạch cho Drift/Riverpod (và freezed nếu đã có model mẫu)
- [ ] CI GitHub Actions (hoặc tương đương): analyze + test
- [ ] Smoke widget/unit test tối thiểu + cập nhật trạng thái ROADMAP khi xong

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift tables | `regions`, `muscle_groups`, `exercises`, `workouts`, `workout_muscle_groups`, `workout_exercises`, `sets`; migration hook sẵn; không seed |
| Providers | `appDatabaseProvider` (hoặc tương đương), router nếu cần |
| Màn hình | Placeholder S01 Hôm nay, S02 Tiến trình, S03 Lịch sử |

## Definition of Done

- [ ] `flutter analyze` không error
- [ ] `flutter test` xanh (ít nhất: DB memory mở; smoke widget hoặc router)
- [ ] CI config có trong repo và mô tả cách chạy local trong milestone notes / README ngắn nếu cần
- [ ] Demo: app launch → chuyển tab/route placeholder được
- [ ] Không có màn hình nghiệp vụ “giả hoàn chỉnh” — chỉ khung

## Rủi ro và câu hỏi còn mở

Đã chốt 2026-11-05 khi bắt đầu M1 (chi tiết: `memory/decisions.md`):

- CI: GitHub Actions, repo `KhanhsBaor/kebap`. Workflow: `flutter pub get` → `build_runner` → `dart format` → `flutter analyze` → `flutter test`.
- Schema v1: bảng khung `regions`, `muscle_groups`, `exercises`, `workouts`, `workout_muscle_groups`, `workout_exercises`, `sets`. Khóa `int` autoincrement. Quan hệ `workouts` → `workout_exercises` → `sets`. Không seed. `splitDayId` nullable, chưa khóa ngoại (lịch thuộc M5).
- Máy demo chính: iOS simulator. App vẫn phải chạy được trên Android.
- l10n: `gen-l10n`, `app_en.arb` + `app_vi.arb` cho nhãn và câu trống của 3 tab. Tên region / nhóm cơ / bài không vào ARB.

Không còn câu hỏi mở cho M1.
