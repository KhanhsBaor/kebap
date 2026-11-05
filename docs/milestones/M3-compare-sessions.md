# M3 — So sánh buổi gần nhất

**Trạng thái:** todo  
**Phụ thuộc:** M2  
**Demo cuối milestone:** Log buổi có bài đã tập trước đó → mỗi bài so với lần gần nhất của chính bài đó (load volume + 1RM ước tính cao nhất): tăng / giữ nguyên / giảm (±2%). Màn tóm tắt thêm một dòng `groupVolume` cho từng nhóm cơ.

**Công thức:** `docs/03-calculation-rules.md` mục 1, 3, 4, 5 — không tự đặt công thức khác.

## Mục tiêu và giá trị

Thể hiện **core value** progressive overload: không chỉ ghi nhật ký mà **nhìn thấy** chênh lệch với lần gần nhất của từng bài, cộng thêm volume theo nhóm cơ.  
**Giá trị:** lý do tồn tại của Kebap — quyết định sản phẩm ưu tiên mốc này sớm sau khi đã log được.

## Trong phạm vi

- Truy vấn DAO: với mỗi bài, buổi `completed` gần nhất có đúng `exerciseId`, `endedAt` trước `startedAt` buổi hiện tại (`docs/03` mục 5). Buổi `in_progress` không phải tham chiếu. Với mỗi nhóm cơ của buổi, buổi `completed` gần nhất có ít nhất một bài của nhóm đó
- Domain: so sánh **theo từng bài** với buổi tham chiếu của bài đó — load volume + max estimated 1RM (Epley, reps ≤ 10); bodyweight so tổng reps; loại warmup / set thiếu kg|reps
- Domain: `groupVolume` + một trend theo nhóm cơ (bỏ set kg = 0; một phía không có volume tạ thì không hiện trend)
- Kết quả: mỗi chỉ số có trend riêng; giữ nếu |Δ%| ≤ 2%
- UI trong phiên đang tập và/hoặc màn tóm tắt sau finish: delta rõ ràng theo bài; dòng `groupVolume` trên màn tóm tắt
- Unit test calculator + ví dụ/edge trong `03` (không previous, bài chỉ có một phía, warmup, reps > 10, hai bài trỏ hai buổi khác nhau, groupVolume)

## Ngoài phạm vi

- Chart theo thời gian (M4)
- So sánh với buổi tùy chọn trong lịch sử (không phải “gần nhất”)
- Aggregate so sánh cả buổi thay cho theo bài (không đúng `03`)
- Gợi ý tăng tạ / AI
- Social share kết quả

## Checklist task (1 chat / task)

- [ ] Đọc `docs/03-calculation-rules.md` + `docs/calculations.md`; không viết lại spec lệch
- [ ] Domain: `CompareSessions` (hoặc tương đương) + models kết quả freezed (per-exercise: volumeΔ, volumeTrend, e1rmΔ, e1rmTrend; bài bodyweight: repsΔ, repsTrend; per-group: groupVolumeΔ, groupTrend)
- [ ] Unit test domain: có previous / không previous / bài lệch nhau / warmup / ±2% / reps>10 không vào 1RM / bodyweight so reps / 1RM tăng nhưng volume giảm / chỉ số thiếu ở một phía / hai bài trỏ hai buổi khác nhau / groupVolume bỏ set kg = 0
- [ ] DAO: latest completed theo `exerciseId` với `endedAt` trước `startedAt` buổi hiện tại; latest completed theo `muscleGroupId` (+ load exercises/sets)
- [ ] Repository method + mapper sang input domain
- [ ] Provider: so sánh gắn active session + previous
- [ ] UI: delta cạnh mỗi bài trên `ActiveWorkoutScreen` (ít noise)
- [ ] UI: card tóm tắt (sau finish hoặc bottom sheet) — cột đôi volume theo bài (ghi ngày tham chiếu, có thể khác nhau giữa các bài) + một dòng `groupVolume` mỗi nhóm
- [ ] Test repo/DAO: bài vắng ở buổi gần nhất vẫn tìm được buổi cũ hơn; buổi `in_progress` không được chọn làm tham chiếu
- [ ] Demo: seed hoặc log tay sao cho hai bài trỏ hai buổi tham chiếu khác nhau → screenshot/delta

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | Không bắt buộc bảng mới; **query/index** trên `WorkoutExercises(exerciseId)` + `Workouts(endedAt)`; nhóm cơ qua `exercises.muscleGroupId` |
| Providers | `sessionComparisonProvider(workoutId)` / family theo active session |
| Màn hình | Widget trên `ActiveWorkoutScreen`; có thể `WorkoutSummaryScreen` nhẹ |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh; **unit test domain compare bắt buộc**, khớp `03`
- [ ] Demo: bài đã tập trước hiện trend; bài chưa có buổi tham chiếu empty-state theo từng bài (“Chưa có lần trước”)
- [ ] Presentation không chứa công thức (chỉ render kết quả domain)
- [ ] Core value đọc được trong ≤ 3 giây trên màn đang tập / summary

## Rủi ro và câu hỏi còn mở

- (Đã chốt 2026-11-04) Buổi tham chiếu theo từng bài (`exerciseId`) và thêm `groupVolume` theo nhóm cơ — `docs/03` mục 5.
- Buổi in-progress: so sánh live khi đang gõ set? (khuyến nghị: có; cột "Lần trước" trên màn đang tập thuộc M2 / `docs/05`, trend ±2% thuộc M3)
- Hiển thị tuyệt đối + % hay chỉ trend label? (công thức trend đã chốt ±2%)
