# M2 — Log buổi tập tối thiểu

**Trạng thái:** doing  
**Phụ thuộc:** M1  
**Demo cuối milestone:** Bắt đầu buổi ad-hoc (chọn một hoặc nhiều nhóm cơ, vd. Chest + Triceps) → thêm bài thuộc các nhóm đó → lưu vài set theo `docs/05` → kill app → mở lại: set đã lưu còn, Home hiện banner "Buổi đang dở" (không tự nhảy vào màn tập) → tiếp tục hoặc kết thúc theo `docs/06`.

**Nguồn tương tác:** `docs/05-log-set-interaction-spec.md` · **vòng đời:** `docs/06-workout-session-lifecycle.md`.

**Catalog:** `docs/01-business-analysis.md` § Catalog bài tập (Upper/Lower/Other → muscle groups cố định → exercises).

## Mục tiêu và giá trị

Hoàn thành **luồng đang tập** tối thiểu — trái tim nhật ký.  
**Giá trị:** người dùng (và bạn) có thể ghi một buổi thật trên máy; chứng minh offline-first và UX “ít chạm”.

## Trong phạm vi

- Entity + repository: **body region**, **muscle group** (cố định), **exercises** (seed + custom), buổi tập gắn **một hoặc nhiều** muscle group, set (gồm `isWarmup`, kg/reps nullable theo `docs/03-calculation-rules.md`)
- Bắt đầu buổi **ad-hoc**: chọn region → một hoặc nhiều muscle group (chưa bắt buộc lịch tuần — lịch ở M5; các dòng "hôm nay" / ngày nghỉ trong `docs/06` mục 2 có hiệu lực từ M5)
- Tối đa một buổi `in_progress`; mỗi "Lưu set" ghi ngay vào Drift; hủy và kết thúc theo `docs/06` mục 4–5
- Màn hình đang tập theo `docs/05`: nút − / + và bàn phím số, prefill, "Lưu set" là bước hoàn thành (không có bước đánh dấu xong riêng), cột "Lần trước" (số từ buổi tham chiếu `docs/03` mục 5, chưa hiện trend ±2% — trend thuộc M3), warmup bằng cách chạm số thứ tự set
- Đồng hồ nghỉ cơ bản: mặc định theo mục tiêu (`docs/01` bảng set/rep/nghỉ; chưa có hồ sơ thì dùng dòng Khỏe tổng quát), chỉnh ±15 giây. Rest timer nâng cao vẫn ngoài phạm vi
- **Seed** bài từ nguồn mở → asset/JSON → Drift (offline)
- Chỉ thêm bài thuộc các nhóm cơ của buổi. Không thêm bài ngoài các nhóm đó.
- **Custom exercise:** tạo tên bài mới (`isCustom = true`), mặc định gắn nhóm đang xem; buổi nhiều nhóm có chip để đổi sang nhóm khác của buổi. Tên trùng y hệt (không phân biệt hoa thường) với một bài trong cùng nhóm thì chặn và gợi ý dùng bài có sẵn. Sửa hoặc xóa custom exercise thuộc M6.
- Kết thúc buổi theo bảng `docs/06` mục 5 (`completed` chỉ khi có ít nhất một set đã lưu; `endedAt` = lúc bấm kết thúc)
- Stream UI từ `repository.watch*()` → Drift
- Domain helpers volume tối thiểu (`setVolume` / `exerciseVolume`) theo `03` + unit test ví dụ Bench 1680; test DAO/repo memory
- Đơn vị lưu **kg** (đổi lb chỉ khi hiển thị — sau nếu cần)

## Ngoài phạm vi

- So sánh buổi trước (M3)
- Chart (M4)
- Lịch tuần (M5)
- Sửa buổi đã đóng phức tạp (M6 — cho phép sửa set buổi đang mở)
- Sửa hoặc xóa custom exercise (M6)
- Rest timer nâng cao (đồng hồ cơ bản ±15 giây thuộc phạm vi), RPE, supersets
- Chart / so sánh đầy đủ (M3–M4); 1RM dùng trong domain/chart theo `03`, không màn 1RM riêng
- Thư viện full + video / tìm kiếm nâng cao (nhóm B) — seed MVP đủ dùng là được
- Bodyweight nâng cao (cân người + tạ thêm) — MVP theo `03`: reps riêng khi kg = 0
- Đổi / xóa muscle group cố định; custom region

## Checklist task (1 chat / task)

- [x] Schema Drift: `muscle_groups` (+ region), `exercises` (`muscleGroupId`, `isCustom`, `sourceId` nullable, `equipment` enum bắt buộc với bài seed, để trống với custom — `docs/04`), `workouts`, `workout_muscle_groups` (bảng nối, buổi ↔ nhiều nhóm), `workout_exercises`, `sets`. Schema v1 đã đủ — không cần migration.
- [x] Domain entities (freezed) + repository contracts — region / muscle group / exercise / workout / set
- [x] Seed region + đủ muscle groups theo `01`; import các dòng trong `seed/exercises.csv` đã có `kebapMuscleGroup`, `kebapEquipment` và `nameVi` (bài seed: `equipment` không null, tên EN + VI)
- [ ] Data: repository impl + mapper Drift ↔ entity
- [ ] Use case/command: start workout, add exercise, **createCustomExercise(name, muscleGroupId)**, log/update set, finish workout
- [ ] Providers/notifiers Riverpod cho phiên đang tập (không nhét business nặng vào notifier)
- [ ] UI: start — chọn **Upper body / Lower body / Other** → chọn một hoặc nhiều muscle group
- [ ] UI: đang tập theo `docs/05` — bài của các nhóm đã chọn, "Lưu set", prefill, cột "Lần trước", warmup, đồng hồ nghỉ ±15 giây
- [ ] UI: Home — banner "Buổi đang dở" (Tiếp tục / Hủy buổi) khi có `in_progress`; không tự mở màn tập
- [ ] UI: tạo custom exercise — mặc định nhóm đang xem, chip đổi sang nhóm khác của buổi; thêm ngay vào buổi. Tên trùng y hệt (không phân biệt hoa thường) trong cùng nhóm thì chặn và gợi ý bài có sẵn. Không cho thêm bài ngoài các nhóm của buổi.
- [ ] UI: hủy và kết thúc theo `docs/06` mục 4–5 (0 set không cho kết thúc; còn set dự kiến thì hỏi)
- [ ] Widget test: đếm `tester.tap` theo ngân sách `docs/05` mục 2; vùng chạm tối thiểu 48 dp
- [ ] Test: DAO seed + custom; filter by `muscleGroupId`; chặn tên custom trùng trong cùng nhóm; unit test volume theo `03`
- [ ] Demo script: buổi **Chest + Triceps** với ≥1 bài seed + ≥1 bài custom

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | `MuscleGroups` (region), `Exercises` (`muscleGroupId`, `isCustom`, `equipment` enum bắt buộc với seed), `Workouts`, `WorkoutMuscleGroups`, `WorkoutExercises`, `Sets` |
| Providers | `muscleGroupRepository`, `exerciseRepository` (watch by groups + create custom), `workoutRepository`, `activeWorkoutNotifier` |
| Màn hình | `StartWorkoutScreen` (region → nhiều group), `ActiveWorkoutScreen`, dialog/sheet **Create custom exercise** |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh
- [ ] Test migration nếu schema đổi từ M1
- [ ] Demo: cold start → lưu ≥ 2 bài × ≥ 2 set → kill app giữa buổi → mở lại thấy banner "Buổi đang dở" và đúng các set đã lưu → kết thúc → buổi `completed`
- [ ] UI không import `*.drift.dart`
- [ ] Ngân sách chạm trong `docs/05` mục 2 được widget test giữ (80% set ≤ 2 chạm là mục tiêu kiểm chứng sau, không chặn demo)

## Rủi ro và câu hỏi còn mở

- (Đã chốt) Region + muscle groups cố định; seed nguồn mở + custom theo nhóm đang chọn.
- (Đã chốt 2026-11-05) Nguồn seed: ExerciseGymGifsDB `v1.1.0`, file `seed/exercises.csv`. Chưa import được cho đến khi điền `kebapMuscleGroup`, `kebapEquipment`, `nameVi`.
- (Đã chốt trong `docs/06`) Chỉ một buổi `in_progress`.
- (Đã chốt 2026-11-05) Không thêm bài ngoài các nhóm cơ của buổi (ít chạm). So sánh theo `docs/03` không phụ thuộc giới hạn này.
- (Đã chốt 2026-11-05) Custom exercise mặc định gắn nhóm đang xem; chip đổi sang nhóm khác của buổi. Tên trùng y hệt (không phân biệt hoa thường) trong cùng nhóm thì chặn và gợi ý bài có sẵn.
- (Đã chốt) Bài seed có `equipment` không null; lọc danh sách bài thuộc M7 (`docs/04`).
- (Đã chốt 2026-11-05) Sửa hoặc xóa custom exercise thuộc M6.
- (Đã chốt bởi `03`: lưu kg; có `isWarmup`; warmup không vào volume/1RM.)
- (Đã chốt 2026-11-04) Cách nhập set, ngân sách chạm và cột "Lần trước": `docs/05`. Vòng đời buổi: `docs/06`.
