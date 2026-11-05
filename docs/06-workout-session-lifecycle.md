# Vòng đời buổi tập (Workout Session Lifecycle)

> Trạng thái: **đã chốt 2026-11-04** — nguồn cho milestone log buổi tập (M2). Câu hỏi ở mục 9 vẫn mở.
> Trả lời các câu hỏi: một hay nhiều buổi `in_progress`, quay lại buổi dở thế nào, hủy buổi ra sao,
> kết thúc buổi khi còn set trống hoặc chưa có set nào thì xử lý gì.
> Agent được cập nhật file này theo "Quy tắc cập nhật" ở cuối. Liên quan: `05-log-set-interaction-spec.md`, `03-calculation-rules.md`.

## 1. Trạng thái và quy tắc nền tảng
| Trạng thái | Ý nghĩa |
|---|---|
| `in_progress` | Buổi đã bấm "Bắt đầu buổi tập", chưa kết thúc |
| `completed` | Đã kết thúc và có ít nhất một set đã lưu |
| (hủy) | Không có trạng thái riêng: hủy buổi nghĩa là xóa buổi và toàn bộ set của nó |

- **Chỉ có tối đa MỘT buổi `in_progress` tại mọi thời điểm.** Người tập chỉ tập một buổi một lúc; quy tắc này giữ Home và nút Bắt đầu đơn giản và không tạo được buổi trùng.
- Ràng buộc đặt trong repository, trong một transaction Drift. Có thể thêm unique index một phần (`WHERE status = 'in_progress'`) bằng câu lệnh tùy chỉnh trong migration.
- **Mỗi lần bấm "Lưu set" ghi ngay vào Drift.** Tắt app, hệ điều hành kill app hay hết pin chỉ làm mất số liệu đang gõ dở trong hàng set hiện tại, không mất set đã lưu.
- `SetLog` chỉ tồn tại sau khi bấm "Lưu set". Các hàng set dự kiến (số set và khoảng rep theo mục tiêu ở `docs/01`; chưa có hồ sơ thì 3 set × 8–12) chỉ là chỗ giữ trên UI, không phải dữ liệu.
- Khi bắt đầu buổi, **sao chép (snapshot)** nhóm cơ và danh sách bài tập từ template vào buổi, để sửa lịch tuần sau này không làm đổi lịch sử.
- Thời lượng tính từ `startedAt` và `endedAt` (không dùng bộ đếm giữ trong bộ nhớ), nên vẫn đúng sau khi app bị kill.

## 2. Bắt đầu buổi

Các dòng phụ thuộc lịch tuần ("buổi hôm nay", ngày nghỉ, chọn một ngày trong lịch) có hiệu lực từ M5. M2 bắt đầu ad-hoc: chọn một hoặc nhiều nhóm cơ, rồi tạo buổi `in_progress`.
| Tình huống | Hành vi |
|---|---|
| Không có buổi dở | Home hiện nút "Bắt đầu buổi tập" cho buổi hôm nay; tạo buổi `in_progress` và mở màn S05 |
| Có buổi dở | Home thay nút Bắt đầu bằng banner "Buổi đang dở" với hai nút "Tiếp tục" (chính) và "Hủy buổi" (phụ) |
| Muốn tập buổi khác khi đang có buổi dở | Hiện hộp thoại "Bạn đang có buổi tập dở", chọn "Tiếp tục buổi đó" hoặc "Hủy và bắt đầu buổi mới" |
| Hôm nay là ngày nghỉ hoặc chưa có lịch | Cho chọn một ngày tập trong lịch để bắt đầu thủ công |
| Hai buổi `completed` trong cùng một ngày | Cho phép |

## 3. Quay lại buổi `in_progress` sau khi app bị tắt
1. Mở app (hoặc đưa app về foreground): kiểm tra có buổi `in_progress` không.
2. Có: Home hiện banner "Buổi đang dở" kèm tên buổi, số set đã lưu, thời điểm bắt đầu. Không tự nhảy vào S05, để người dùng chủ động.
3. Bấm "Tiếp tục": mở S05 tại bài tập có set cuối cùng được lưu, các set đã lưu hiện đúng trạng thái xong.
4. **Buổi quá cũ (stale):** nếu hoạt động cuối (set đã lưu gần nhất, hoặc lúc bắt đầu nếu chưa có set) cách hiện tại hơn **6 giờ**, hiện hộp thoại:
   "Buổi tập bắt đầu lúc … chưa được kết thúc." với các lựa chọn "Lưu thành buổi đã hoàn thành" và "Hủy buổi" và "Tiếp tục".
   Nếu chọn lưu: `endedAt` = thời điểm set cuối cùng được lưu (không phải bây giờ), tránh thời lượng sai như 20 giờ.
   (Ngưỡng 6 giờ là giả định, cần chỉnh theo dữ liệu thực tế.)
- Không lưu lại đồng hồ nghỉ và số đang gõ dở sau khi app bị kill (giới hạn chấp nhận được ở MVP).

## 4. Hủy buổi (Discard)
- Vị trí: menu "⋯" ở S05 ("Hủy buổi tập") và nút phụ trên banner "Buổi đang dở".
- **Buổi chưa có set nào được lưu:** hủy ngay, không hỏi.
- **Buổi đã có set:** hiện hộp thoại xác nhận nêu rõ hậu quả: "Hủy buổi tập? X set đã ghi sẽ bị xóa." Nút hủy dùng kiểu nguy hiểm (đỏ), nút mặc định được nhấn mạnh là "Tiếp tục tập".
- Hủy là xóa cứng buổi và toàn bộ set của buổi đó trong một transaction. Không thể hoàn tác sau khi xác nhận.
- Sau khi hủy: về Home, trạng thái như chưa bắt đầu.

## 5. Kết thúc buổi (Finish)
| Tình huống khi bấm "Kết thúc" | Hành vi |
|---|---|
| **0 set đã lưu** | Không cho kết thúc. Hộp thoại "Chưa có set nào được ghi" với hai lựa chọn "Hủy buổi tập" và "Tiếp tục tập". Không tạo buổi `completed` rỗng |
| Có set đã lưu, **mọi bài đã ghi đủ** | Kết thúc ngay, `status = completed`, `endedAt` = bây giờ, sang màn S07 |
| Có set đã lưu, **còn set dự kiến chưa ghi** | Hộp thoại "Còn N set chưa ghi ở M bài. Kết thúc và bỏ qua các set này?" với "Kết thúc" và "Tiếp tục tập". Chọn kết thúc: các set chưa ghi bị bỏ, bài tập không có set nào được ghi bị loại khỏi buổi |
| Có **số đang gõ dở** trong hàng set hiện tại, chưa bấm Lưu set | Coi như chưa ghi (không lưu), tính vào số set chưa ghi ở hộp thoại trên |
| Buổi cực ngắn (ví dụ dưới 3 phút) nhưng có set | Cho kết thúc bình thường (không chặn); đây là quyết định đơn giản hóa ở MVP |

Sau khi kết thúc, buổi `completed` hiện ở Lịch sử và được dùng làm buổi tham chiếu cho lần sau.

## 6. Ảnh hưởng đến các phần khác
- **So sánh và cột "Lần trước":** buổi tham chiếu theo `docs/03` mục 5 — buổi `completed` gần nhất có đúng `exerciseId`, `endedAt` trước `startedAt`. Buổi `in_progress` không bao giờ là tham chiếu. Cột "Lần trước" trên S05 chỉ hiện số, không hiện trend ±2% (trend thuộc M3).
- **So sánh theo nhóm cơ:** `groupVolume` trên màn tóm tắt, cùng mốc thời gian, theo `docs/03` mục 5.
- **Chart và volume tuần:** chỉ tính set thuộc buổi `completed`.
- **Mô hình dữ liệu `WorkoutSession`:** `id`, `status` (`in_progress` | `completed`), `startedAt`, `endedAt` (null khi đang dở), `splitDayId` (có thể null), `muscleGroups` (snapshot), `exerciseSnapshot`.

## 7. Tiêu chí kiểm chứng (đưa vào Definition of Done)
- Gọi bắt đầu buổi khi đã có buổi `in_progress` không tạo buổi thứ hai (kiểm tra cả khi gọi hai lần liên tiếp).
- Ghi 2 set, dựng lại `ProviderContainer` trên cùng DB: Home hiện banner, bấm Tiếp tục thấy đúng 2 set, thời lượng đúng.
- Hủy buổi không có set: không hộp thoại, buổi biến mất. Hủy buổi có set: có hộp thoại, xóa sạch buổi và set (kiểm tra không còn dòng mồ côi).
- Kết thúc với 0 set bị chặn; kết thúc với set chưa ghi hiện hộp thoại và kết quả loại bài không có set.
- Buổi stale: lưu thành hoàn thành thì `endedAt` bằng thời điểm set cuối.
- Truy vấn buổi tham chiếu bỏ qua buổi `in_progress`.

## 8. Nguồn tham chiếu đã dùng
- Hevy: có nút Discard Workout cho buổi không thể hoàn thành; chỉ kết thúc được khi đánh dấu xong ít nhất một set, và chỉ các set đã hoàn thành được hiển thị.
- MacroFactor: "Discard workout" kết thúc buổi mà không lưu gì.
- StrengthLog: khi lưu còn set chưa làm, hỏi xóa chúng hoặc chuyển sang buổi dự kiến (tính năng chuyển để ngoài MVP).
- Apple Human Interface Guidelines (mẫu Workouts): với buổi cực ngắn, tự bỏ hoặc hỏi người dùng có ghi lại không.
- Playbook: khi thoát app mà chưa hoàn thành, hiện banner để vào lại buổi tập.
- Bài học từ Garmin Cirqa (TechRadar): người dùng mất dữ liệu sau khi chọn "End" ở hộp thoại "Activity in Progress", nên lựa chọn phá hủy phải được nêu rõ hậu quả.

## 9. Câu hỏi còn mở cho chủ dự án
1. Ngưỡng buổi stale 6 giờ có hợp lý không?
2. Có muốn app tự mở S05 khi có buổi dở còn mới (ví dụ dưới 3 giờ) thay vì chỉ hiện banner?
3. Cho phép sửa hoặc xóa buổi `completed` sau này ở MVP, hay để V1.1?
4. Có cần chức năng tạm dừng (pause) đồng hồ buổi tập không?

## Quy tắc cập nhật (dành cho agent)
1. Khi đổi vòng đời hay trạng thái buổi tập: sửa file này trước, rồi code và test.
2. Code và file này mâu thuẫn thì dừng lại hỏi người dùng.
3. Mỗi lần sửa thêm một dòng vào Lịch sử thay đổi.

## Lịch sử thay đổi
| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-11-04 | Hàng set dự kiến lấy số set / khoảng rep theo mục tiêu ở `docs/01` | Khớp mặc định logging với khảo sát |
| 2026-11-04 | Đánh dấu đã chốt để làm M2; mục 2 ghi phần lịch tuần thuộc M5; mục 6 trỏ buổi tham chiếu theo `exerciseId` ở `docs/03` | Khớp vòng đời với quy tắc so sánh |
| 2026-11-04 | Tạo bản đề xuất đầu tiên | Bổ sung chỗ thiếu: một hay nhiều buổi in_progress, quay lại, hủy, kết thúc |
