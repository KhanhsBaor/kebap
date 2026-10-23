# M3 — So sánh buổi gần nhất

**Trạng thái:** todo  
**Phụ thuộc:** M2  
**Demo cuối milestone:** Log buổi thứ hai cùng nhóm cơ → thấy so sánh với buổi trước theo **từng bài** (load volume + 1RM ước tính cao nhất): tăng / giữ nguyên / giảm (±2%).

**Công thức:** `docs/03-calculation-rules.md` mục 1, 3, 4, 5 — không tự đặt công thức khác.

## Mục tiêu và giá trị

Thể hiện **core value** progressive overload: không chỉ ghi nhật ký mà **nhìn thấy** chênh lệch với buổi gần nhất cùng nhóm cơ.  
**Giá trị:** lý do tồn tại của Kebap — quyết định sản phẩm ưu tiên mốc này sớm sau khi đã log được.

## Trong phạm vi

- Truy vấn DAO: buổi completed gần nhất cùng `muscleGroupId` (hoặc split day), **ngày trước** buổi hiện tại
- Domain: so sánh **theo bài có mặt ở cả hai buổi** — load volume bài + max estimated 1RM (Epley, reps ≤ 10); loại warmup / set thiếu kg|reps
- Kết quả: tăng / giữ nguyên / giảm; giữ nếu chênh lệch trong ±2%
- UI trong phiên đang tập và/hoặc màn tóm tắt sau finish: delta rõ ràng
- Unit test calculator + ví dụ/edge trong `03` (không previous, bài chỉ có một phía, warmup, reps > 10)

## Ngoài phạm vi

- Chart theo thời gian (M4)
- So sánh với buổi tùy chọn trong lịch sử (không phải “gần nhất”)
- Aggregate so sánh cả buổi thay cho theo bài (không đúng `03`)
- Gợi ý tăng tạ / AI
- Social share kết quả

## Checklist task (1 chat / task)

- [ ] Đọc `docs/03-calculation-rules.md` + `docs/calculations.md`; không viết lại spec lệch
- [ ] Domain: `CompareSessions` (hoặc tương đương) + models kết quả freezed (per-exercise: volumeΔ, e1rmΔ, trend)
- [ ] Unit test domain: có previous / không previous / bài lệch nhau / warmup / ±2% / reps>10 không vào 1RM
- [ ] DAO: latest completed cùng nhóm cơ trước ngày buổi hiện tại (+ load exercises/sets)
- [ ] Repository method + mapper sang input domain
- [ ] Provider: so sánh gắn active session + previous
- [ ] UI: delta cạnh mỗi bài trên `ActiveWorkoutScreen` (ít noise)
- [ ] UI: card tóm tắt (sau finish hoặc bottom sheet) — cột đôi volume theo bài khớp mapping chart mục 6 nếu tái dùng
- [ ] Test repo/DAO: 2 buổi cùng nhóm cơ → previous đúng; khác nhóm → không nhầm
- [ ] Demo: seed hoặc log tay 2 buổi cùng nhóm → screenshot/delta

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | Không bắt buộc bảng mới; **query/index** trên `Workouts(muscleGroupId, completedAt)` |
| Providers | `sessionComparisonProvider(workoutId)` / family theo active session |
| Màn hình | Widget trên `ActiveWorkoutScreen`; có thể `WorkoutSummaryScreen` nhẹ |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh; **unit test domain compare bắt buộc**, khớp `03`
- [ ] Demo: buổi 2 cùng nhóm cơ hiện trend; buổi đầu tiên empty-state (“Chưa có buổi trước”)
- [ ] Presentation không chứa công thức (chỉ render kết quả domain)
- [ ] Core value đọc được trong ≤ 3 giây trên màn đang tập / summary

## Rủi ro và câu hỏi còn mở

- “Cùng split day” ngoài `muscleGroupId`: có entity split riêng từ M5 hay chỉ nhóm cơ ở MVP?
- Buổi in-progress: so sánh live khi đang gõ set? (khuyến nghị: có)
- Hiển thị tuyệt đối + % hay chỉ trend label? (công thức trend đã chốt ±2%)
