# M2 — Log buổi tập tối thiểu

**Trạng thái:** todo  
**Phụ thuộc:** M1  
**Demo cuối milestone:** Bắt đầu buổi (chọn nhóm cơ) → thêm bài → nhập vài set (rep/kg) với ít chạm → kết thúc buổi → mở lại thấy dữ liệu còn (offline).

## Mục tiêu và giá trị

Hoàn thành **luồng đang tập** tối thiểu — trái tim nhật ký.  
**Giá trị:** người dùng (và bạn) có thể ghi một buổi thật trên máy; chứng minh offline-first và UX “ít chạm”.

## Trong phạm vi

- Entity + repository: nhóm cơ, bài tập (seed nhỏ), buổi tập, set (gồm `isWarmup`, kg/reps nullable theo `docs/03-calculation-rules.md`)
- Bắt đầu buổi **ad-hoc** theo nhóm cơ (chưa bắt buộc lịch tuần — lịch ở M5)
- Màn hình đang tập: chọn/ thêm bài, log set (rep, kg), đánh dấu set xong; đánh dấu warmup nếu cần
- Kết thúc buổi (status completed + timestamp)
- Stream UI từ `repository.watch*()` → Drift
- Domain helpers volume tối thiểu (`setVolume` / `exerciseVolume`) theo `03` + unit test ví dụ Bench 1680; test DAO/repo memory
- Đơn vị lưu **kg** (đổi lb chỉ khi hiển thị — sau nếu cần)

## Ngoài phạm vi

- So sánh buổi trước (M3)
- Chart (M4)
- Lịch tuần (M5)
- Sửa buổi đã đóng phức tạp (M6 — cho phép sửa set buổi đang mở)
- Rest timer, RPE, supersets
- Chart / so sánh đầy đủ (M3–M4); 1RM dùng trong domain/chart theo `03`, không màn 1RM riêng
- Thư viện bài tập lớn / tìm kiếm nâng cao
- Bodyweight nâng cao (cân người + tạ thêm) — MVP theo `03`: reps riêng khi kg = 0

## Checklist task (1 chat / task)

- [ ] Chốt schema Drift: `muscle_groups`, `exercises`, `workouts`, `workout_exercises`, `sets` (tên có thể chỉnh) + migration v2 nếu M1 để trống
- [ ] Domain entities (freezed) + repository contracts
- [ ] Seed nhóm cơ + vài bài tập mẫu (DAO/seed script)
- [ ] Data: repository impl + mapper Drift ↔ entity
- [ ] Use case/command: start workout, add exercise to workout, log/update set, finish workout
- [ ] Providers/notifiers Riverpod cho phiên đang tập (không nhét business nặng vào notifier)
- [ ] UI: màn bắt đầu buổi (chọn nhóm cơ)
- [ ] UI: màn đang tập — list bài + nhập set nhanh (ít chạm)
- [ ] UI: kết thúc buổi + xác nhận ngắn (chỉ nếu cần tránh mất dữ liệu)
- [ ] Test: DAO memory (insert/watch workout+sets); unit test `setVolume`/`exerciseVolume` theo ví dụ trong `docs/03-calculation-rules.md`
- [ ] Demo script ghi trong milestone / memory: 1 buổi Push mẫu

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | `MuscleGroups`, `Exercises`, `Workouts`, `WorkoutExercises`, `Sets` (+ index theo `workoutId`, `muscleGroupId`, `startedAt`) |
| Providers | `muscleGroupRepository`, `exerciseRepository`, `workoutRepository`, `activeWorkoutNotifier` / tương đương |
| Màn hình | `StartWorkoutScreen`, `ActiveWorkoutScreen` (thay placeholder Workout) |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh
- [ ] Test migration nếu schema đổi từ M1
- [ ] Demo: cold start → log ≥ 2 bài × ≥ 2 set → finish → kill app → mở lại vẫn thấy buổi completed
- [ ] UI không import `*.drift.dart`
- [ ] Số bước chạm từ “bắt đầu” đến “log xong 1 set” được ghi nhận / chấp nhận được (mục tiêu: tối thiểu)

## Rủi ro và câu hỏi còn mở

- Nhóm cơ: list cố định (Push/Pull/Legs/…) hay CRUD tự do?
- Bài tập: chỉ seed hay cho tạo custom ngay M2?
- Cho phép nhiều buổi `in_progress` hay chỉ một?
- (Đã chốt bởi `03`: lưu kg; có `isWarmup`; warmup không vào volume/1RM.)
