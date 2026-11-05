# Đặc tả tương tác: Ghi set khi đang tập (màn S05)

> Trạng thái: **đã chốt 2026-11-04** — nguồn cho milestone log buổi tập (M2). Câu hỏi ở mục 5 vẫn mở.
> Mục đích: biến nguyên tắc "ít chạm" thành tiêu chí kiểm chứng được.
> Agent được cập nhật file này theo mục "Quy tắc cập nhật" ở cuối. Thiết kế tham chiếu: `docs/design/S05-*.png`.

## 1. Quyết định về cách nhập một set
| Câu hỏi | Quyết định đề xuất |
|---|---|
| Cách nhập kg và reps | Hai cách cùng tồn tại: nút − / + (kg bước 2,5 mặc định, reps bước 1) và chạm vào số để mở bàn phím số có dấu thập phân |
| Có prefill không | Có. Thứ tự ưu tiên: (1) set liền trước trong buổi này, (2) set cùng số thứ tự ở buổi trước, (3) số set và khoảng rep theo mục tiêu ở `docs/01`, (4) để trống |
| Có bước "đánh dấu xong" riêng không | Không. Nút "Lưu set" chính là bước hoàn thành: lưu dữ liệu và chuyển set sang trạng thái xong cùng lúc |
| Bàn phím số có cần bấm "Xong" không | Không. Bấm "Lưu set" tự lưu và đóng bàn phím |
| Hiện kg×reps buổi trước khi đang nhập không | **Có**, ở ba chỗ: cột "Lần trước" trên mỗi hàng set, dòng tham chiếu dưới tên bài tập, và gợi ý delta tức thời ("+2,5 kg so với lần trước") |
| Sau khi lưu set | Tự bật đồng hồ nghỉ (mặc định theo bảng mục tiêu ở `docs/01`; chưa có hồ sơ thì 90 giây của dòng Khỏe tổng quát; chỉnh ±15 giây), không tự bắt đầu set kế tiếp |
| Nhập nhầm | Chạm lại dấu check để hoàn tác set; không cần hộp thoại xác nhận |
| Bài tập chưa có lịch sử | Cột "Lần trước" hiện "—", prefill theo bảng mục tiêu ở `docs/01` (chưa có hồ sơ thì Khỏe tổng quát: 3 set, 8–12 rep) |
| Set khởi động | Chạm vào số thứ tự set để đổi loại (W); set W không tính volume |

## 2. Ngân sách số chạm (chốt một con số)
Một "chạm" là một lần chạm nút hoặc ô. Mỗi phím trên bàn phím số tính một chạm.

| Tình huống | Số chạm tối đa |
|---|---|
| Từ Home đến lưu xong set đầu tiên, giữ nguyên giá trị prefill | **2** (Bắt đầu buổi tập, Lưu set) |
| Set kế tiếp giống set trước | **1** (Lưu set) |
| Set kế tiếp đổi kg hoặc reps một bước | **2** |
| Set kế tiếp đổi hai bước tùy ý bằng nút − / + | **4** |
| Set kế tiếp nhập kg bằng bàn phím (ví dụ 62,5) | **6** (mở ô, 4 phím, Lưu set) |

**Mục tiêu tổng:** tối thiểu 80% số set trong một buổi tập thực tế phải đạt ≤ 2 chạm.
Con số 80% là giả định, cần kiểm chứng bằng dữ liệu dùng thử và chỉnh lại.

## 3. Cách kiểm chứng (đưa vào Definition of Done của milestone log buổi tập)
- Widget test mô phỏng từng tình huống ở bảng trên và đếm số lần `tester.tap`, test fail nếu vượt ngân sách.
- Kích thước vùng chạm: tối thiểu 48 dp cho nút − / +, ô số và "Lưu set" (nút "Lưu set" cao 56 dp).
- Kiểm tra thủ công: một người dùng thật tập 1 buổi, đếm chạm và ghi lại các điểm vấp.
- Nếu kết quả thực tế khác ngân sách, sửa ngân sách ở file này trước (ghi lý do), rồi mới sửa code.

## 4. Nguồn tham chiếu đã dùng
- Hevy: hàng set gồm Set, Previous, kg, Reps và dấu check; chạm check để hoàn thành set và bật đồng hồ nghỉ, chỉnh ±15 giây; có cài đặt hiển thị giá trị buổi trước.
- MacroFactor: bảng một hàng mỗi set với cột Previous Performance; bỏ check để hoàn tác khi lưu nhầm; chỉnh đồng hồ nghỉ ±10 giây.
- Kích thước vùng chạm: Apple HIG (44 pt), Material Design 3 (48 dp), WCAG 2.2 mục Target Size.

## 5. Câu hỏi còn mở cho chủ dự án
1. Bước nhảy kg mặc định 2,5 có phù hợp với bài tạ đơn (thường 1 hoặc 2 kg) không? Có nên cho mỗi bài tập một bước riêng?
2. Với set 1 buổi này, prefill theo set 1 buổi trước hay theo set tốt nhất buổi trước?
3. Có cần widget màn hình khóa để lưu set (như Live Activity của Hevy) ở giai đoạn sau không?

## Quy tắc cập nhật (dành cho agent)
1. Khi đổi cách nhập set hoặc ngân sách chạm: sửa file này trước, rồi code và test.
2. Code và file này mâu thuẫn thì dừng lại hỏi người dùng.
3. Mỗi lần sửa thêm một dòng vào Lịch sử thay đổi.

## Lịch sử thay đổi
| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-11-04 | Nghỉ và prefill lấy từ bảng mục tiêu ở `docs/01`; chưa có hồ sơ thì dùng dòng Khỏe tổng quát | Mục tiêu khảo sát quyết định mặc định set/rep/nghỉ |
| 2026-11-04 | Đánh dấu đã chốt để làm M2 | Chủ dự án chọn file này làm nguồn cho màn đang tập |
| 2026-11-04 | Tạo bản đề xuất đầu tiên | Bổ sung chỗ thiếu: cách nhập set, ngân sách chạm, hiển thị mốc buổi trước |
