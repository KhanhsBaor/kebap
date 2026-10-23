# M1 — Khung dự án

**Trạng thái:** todo  
**Phụ thuộc:** M0  
**Demo cuối milestone:** `flutter run` → shell app (theme + vài route placeholder), `flutter analyze` + `flutter test` xanh; CI chạy được trên PR/push.

## Mục tiêu và giá trị

Gắn stack mục tiêu vào repo và tạo xương sống chạy được: thư mục feature-first, Drift DB rỗng + migration, go_router, theme, Riverpod root, CI cơ bản.  
**Giá trị:** mọi milestone sau chỉ thêm lát cắt nghiệp vụ, không phải tranh luận lại “đặt file ở đâu / DB khởi tạo thế nào”.

## Trong phạm vi

- Cấu trúc `lib/core/` + `lib/features/` (có thể feature placeholder rỗng)
- Dependencies theo `docs/02-tech-stack.md` (Riverpod, Drift, go_router, freezed, …)
- Drift: `AppDatabase`, schema version khởi đầu, DAO stub hoặc table tối thiểu (vd. `meta` / chưa bắt buộc bảng nghiệp vụ)
- `ProviderScope` + database provider
- go_router: ít nhất Home + 1–2 route placeholder (Workout / Progress)
- Theme Material 3 cơ bản (màu/typography tạm, không brand đầy đủ)
- CI: workflow chạy `flutter pub get`, `dart run build_runner` (nếu cần), `flutter analyze`, `flutter test`
- Smoke test: app / router / DB memory mở được

## Ngoài phạm vi

- Log set, so sánh, chart, lịch tuần
- Seed bài tập / nhóm cơ đầy đủ
- Branding / design system hoàn chỉnh
- Store listing, signing, flavors

## Checklist task (1 chat / task)

- [ ] Thêm packages mục tiêu vào `pubspec.yaml` + `flutter pub get`
- [ ] Tạo cây thư mục `lib/core/{db,router,theme}` và `lib/features/` (placeholder)
- [ ] Drift `AppDatabase` + schema v1 + mở DB (path_provider); test `NativeDatabase.memory()`
- [ ] Riverpod: `main.dart` bọc `ProviderScope`, provider expose DB
- [ ] go_router shell + 2–3 route placeholder; gắn vào `MaterialApp.router`
- [ ] Theme cơ bản (light); áp dụng trên app
- [ ] `build_runner` chạy sạch cho Drift/Riverpod (và freezed nếu đã có model mẫu)
- [ ] CI GitHub Actions (hoặc tương đương): analyze + test
- [ ] Smoke widget/unit test tối thiểu + cập nhật trạng thái ROADMAP khi xong

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift tables | Schema v1 tối thiểu (có thể chỉ bảng kỹ thuật hoặc empty tables list + version); migration hook sẵn |
| Providers | `appDatabaseProvider` (hoặc tương đương), router nếu cần |
| Màn hình | `HomePlaceholderScreen`, `WorkoutPlaceholderScreen`, `ProgressPlaceholderScreen` (tên có thể đổi) |

## Definition of Done

- [ ] `flutter analyze` không error
- [ ] `flutter test` xanh (ít nhất: DB memory mở; smoke widget hoặc router)
- [ ] CI config có trong repo và mô tả cách chạy local trong milestone notes / README ngắn nếu cần
- [ ] Demo: app launch → chuyển tab/route placeholder được
- [ ] Không có màn hình nghiệp vụ “giả hoàn chỉnh” — chỉ khung

## Rủi ro và câu hỏi còn mở

- CI chạy trên GitHub hay chỉ script local? (ảnh hưởng file workflow)
- Schema v1: để trống bảng nghiệp vụ hay tạo sẵn skeleton tables cho M2? (khuyến nghị: skeleton tối thiểu cho muscle_group / exercise / workout nếu đã chốt model; nếu chưa chốt → DB rỗng + version)
- iOS simulator vs Android emulator làm máy demo chính?
