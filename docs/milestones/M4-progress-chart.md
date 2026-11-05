# M4 — Chart tiến trình

**Trạng thái:** todo  
**Phụ thuộc:** M2, M3  
**Demo cuối milestone:** Tab Progress theo mapping `docs/03-calculation-rules.md` mục 6 — ít nhất: tiến bộ bài (1RM đường + volume bài cột) và/hoặc tổng quan volume buổi theo tuần/tháng; set volume nhóm cơ (working sets / 7 ngày) nếu kịp trong milestone.

**Công thức / metric:** chỉ từ `docs/03-calculation-rules.md` — không tự chọn metric lệch.

## Mục tiêu và giá trị

Nhìn xu hướng dài hơn “hai buổi”: progressive overload theo thời gian.  
**Giá trị:** củng cố core value sau so sánh điểm-điểm; dùng `fl_chart` theo tech stack.

## Trong phạm vi

- Domain: series từ buổi completed — load volume bài/buổi, max estimated 1RM/bài/buổi, `weeklySetCount` theo nhóm cơ
- Repository/DAO: query lịch sử + filter bài / nhóm cơ / khoảng thời gian
- UI Progress theo mapping mục 6 `03`:
  - Tiến bộ từng bài: 1RM (đường) + volume bài (cột), trục X = ngày tập
  - Tổng quan lâu dài: volume buổi theo tuần hoặc tháng
  - (Khuyến nghị MVP) Cân bằng nhóm cơ: số working set / tuần
- Unit test aggregate + ví dụ `03`; empty state khi thiếu dữ liệu

## Ngoài phạm vi

- Heat map lịch tập
- So sánh với bạn bè / cloud
- Export ảnh chart
- Predictive trend / regression
- Bodyweight nâng cao (cân người + tạ) — giữ reps-only khi kg = 0 theo `03`

## Checklist task (1 chat / task)

- [ ] Đọc `docs/03` mục 2, 3, 6; chốt phạm vi UI MVP trong milestone (bắt buộc: chart bài 1RM+volume; thêm volume buổi và/hoặc set-volume nhóm cơ)
- [ ] Domain: helpers/`ProgressSeries` dùng `exerciseVolume`, `sessionVolume`, `estimated1RM`, `weeklySetCount`
- [ ] Unit test (warmup loại, reps>10 không vào 1RM, thiếu kg/reps bỏ qua, ví dụ 1680)
- [ ] DAO query lịch sử theo `exerciseId` / `muscleGroupId` + khoảng thời gian
- [ ] Repository + provider stream/future cho series
- [ ] UI: `ProgressScreen` — chọn bài / nhóm cơ / loại chart trong phạm vi
- [ ] UI: `fl_chart` đọc được trên mobile
- [ ] Empty / ít điểm: copy rõ, không crash
- [ ] Demo với ≥ 3 buổi seed hoặc log tay

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | Query trên bảng M2; index `WorkoutMuscleGroups(muscleGroupId)` + `Workouts(completedAt)` nếu chưa có từ M3. Set volume nhóm cơ đếm theo `exercises.muscleGroupId` của từng set, không theo nhóm của buổi |
| Providers | `progressSeriesProvider(filter)` |
| Màn hình | `ProgressScreen` (+ widgets chart) |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh; unit test metric khớp `03`
- [ ] Demo: filter đổi → chart cập nhật từ DB local
- [ ] Không gọi mạng; UI không import Drift generated; không đặt công thức trong UI
- [ ] Chart vẫn dùng được với 1–2 điểm (không bắt buộc đẹp, nhưng không lỗi)

## Rủi ro và câu hỏi còn mở

- MVP ship đủ 3 chart mapping (bài / cân bằng nhóm cơ / volume buổi) hay chỉ chart bài trước?
- Range mặc định UI: 8 tuần vs tùy chọn?
- Timezone / “theo ngày”: local device date?
