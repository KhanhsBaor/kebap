# M6 — Lịch sử & chỉnh sửa

**Trạng thái:** todo  
**Phụ thuộc:** M3, M4  
**Demo cuối milestone:** Mở lịch sử buổi → sửa rep/kg một set buổi cũ → màn so sánh/chart phản ánh số mới; xóa set/buổi có xác nhận.

## Mục tiêu và giá trị

Nhật ký đáng tin: sửa sai số sau khi tập, xem lại quá khứ.  
**Giá trị:** dữ liệu compare/chart không “đóng băng sai”; người dùng yên tâm log nhanh rồi chỉnh sau.

## Trong phạm vi

- Danh sách buổi completed (lọc theo nhóm cơ / thời gian đơn giản)
- Chi tiết buổi: exercises + sets
- Sửa set (reps, kg); xóa set; xóa buổi (confirm)
- Đảm bảo stream compare/chart cập nhật sau sửa (reactive Drift)
- Test repo: update/delete → watch emit

## Ngoài phạm vi

- Undo stack phức tạp / sync conflict
- Duplicate buổi / copy buổi trước thành template đầy đủ (có thể post-MVP)
- Ghi chú dài / ảnh form check
- Export (nhóm B)

## Checklist task (1 chat / task)

- [ ] UI: `WorkoutHistoryScreen` (list từ repository.watch)
- [ ] UI: `WorkoutDetailScreen` — xem + edit set inline hoặc form ngắn
- [ ] Commands: updateSet, deleteSet, deleteWorkout (+ confirm dialog)
- [ ] Repository/DAO implement + cascade xóa hợp lý
- [ ] Kiểm tra M3: sửa buổi previous → delta buổi sau đổi đúng
- [ ] Kiểm tra M4: chart điểm cập nhật sau edit
- [ ] Test: update/delete + stream; không orphan sets
- [ ] Empty history state
- [ ] Demo script: sửa 1 set → mở compare/chart

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | Dùng bảng M2; có thể thêm `updatedAt` nếu chưa có |
| Providers | `workoutHistoryProvider`, `workoutDetailProvider(id)`, edit notifiers |
| Màn hình | `WorkoutHistoryScreen`, `WorkoutDetailScreen` |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh
- [ ] Demo: edit set buổi cũ → summary compare và chart đổi không cần restart app
- [ ] Xóa buổi có confirm; không crash khi đang mở detail
- [ ] Vẫn giữ UX “ít chạm” cho luồng đang tập (M2) — không thêm bước thừa vào active workout

## Rủi ro và câu hỏi còn mở

- Cho phép sửa danh sách muscle group của buổi đã hoàn thành không?
- (Đã chốt 2026-11-04) Xóa buổi đang làm tham chiếu: chỉ cập nhật reactive; buổi `completed` kế trước của bài hoặc nhóm đó trở thành tham chiếu. Không cần thông báo riêng.
- Có cần “chỉnh giờ hoàn thành” không (ảnh hưởng chart theo ngày)?
