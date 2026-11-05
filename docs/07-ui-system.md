# Hệ UI Kebap

> Trạng thái: **đã chốt 2026-11-04**. Nguồn cho theme và component dùng chung.
> Bản đồ từng màn: `docs/design/screens.md`.
> Công thức, ngưỡng ±2% và metric chart vẫn thuộc `docs/03-calculation-rules.md`. File này chỉ quy định cách vẽ.
> M1 áp dụng cặp theme dưới đây. Không dựng màn nghiệp vụ giả trong M1.

## 1. Style

**Nhật ký thể thao, mật độ cao, một màu nhấn.** Lưới gọn, chữ số thể thao, chuyển động rất nhẹ.

App được mở giữa các set. Người tập phải đọc kg, reps và chênh lệch trong khoảng 3 giây (M3). Nút − / +, ô số và "Lưu set" bám `docs/05`: vùng chạm tối thiểu 48 dp, nút "Lưu set" cao 56 dp.

Giữ từ hướng gym phổ biến: cam năng lượng, nền tối đọc được trong phòng tập, số đậm. Bỏ khối marketing, neumorphism, glass, chuyển động kiểu landing, và gamification (streak, huy hiệu, ăn mừng).

**Cả hai theme, mặc định theo hệ thống.** Khi code M1: `ThemeMode.system`, có đủ `theme` và `darkTheme`. Câu "theme sáng" trong checklist M1 được file này thay cho phần màu. Dark mode không còn là hạng mục sau MVP. Tùy chỉnh brand sâu hơn cặp token này vẫn ngoài MVP.

Copy điều khiển trong spec là tiếng Việt. Tên region, nhóm cơ và bài giữ đúng catalog ở `docs/01` cho đến khi có bảng dịch. Câu hỏi ngôn ngữ UI trên ROADMAP vẫn mở cho bản tiếng Anh.

## 2. Màu

Cam chỉ dùng cho hành động chính (Bắt đầu buổi tập, Lưu set, Áp dụng) và cho đường 1RM trên chart. Không dùng cam cho đoạn văn, không dùng cam để báo tăng.

Trend tách khỏi màu brand. Mỗi trend có nhãn chữ. Ngưỡng "giữ nguyên" là `|Δ| ≤ 2%` theo `docs/03`. Màu không phải tín hiệu duy nhất.

| Vai trò | Sáng | Tối | Dùng cho |
|---|---|---|---|
| Primary | `#F97316` | `#F97316` | Nút chính, đường 1RM |
| On primary | `#0F172A` | `#0F172A` | Chữ và icon trên nút cam |
| Background | `#F8FAFC` | `#111827` | Nền màn |
| Surface | `#FFFFFF` | `#1F2937` | Thẻ, hàng set, sheet |
| Foreground | `#0F172A` | `#F8FAFC` | Chữ chính, số |
| Muted | `#475569` | `#CBD5E1` | Nhãn cột, chữ phụ, trend "giữ nguyên" |
| Border | `#E2E8F0` | `#374151` | Viền thẻ, kẻ hàng, nút phụ |
| Trend up | `#15803D` | `#4ADE80` | Chữ và icon tăng |
| Trend down | `#B91C1C` | `#F87171` | Chữ và icon giảm, hành động hủy |
| Focus ring | `#F97316` | `#F97316` | Viền focus |

Lúc gắn vào `ColorScheme`, đo chữ thường trên đúng bề mặt của nó. Ngưỡng chữ thường là 4.5:1 ở cả hai theme. Viền, icon mang nghĩa và nút cần ít nhất 3:1 với nền kề. Nếu một cặp trend không đạt, đậm hơn ở theme sáng hoặc nhạt hơn ở theme tối trước khi giao diện đó được dùng. Không hard-code hex trong từng màn. Widget lấy màu từ theme.

Cột volume trên chart dùng màu chữ phụ, không dùng xanh trend. Xanh và đỏ chỉ dành cho tăng và giảm.

## 3. Chữ

| Vai trò | Family | Cỡ / line-height | Weight | Ghi chú |
|---|---|---|---|---|
| Số đang nhập (kg, reps) | Barlow Condensed | 32 / 36 | 600 | `tabular figures` |
| Số phụ (lần trước, volume, 1RM) | Barlow Condensed | 20 / 24 | 600 | `tabular figures` |
| Tiêu đề màn | Barlow | 22 / 28 | 600 | |
| Thân | Barlow | 16 / 24 | 400 | Câu, mô tả, hộp thoại |
| Nhãn | Barlow | 12 / 16 | 500 | Tiêu đề cột; được xuống tối đa 2 dòng |

Barlow Condensed chỉ cho số và tên bài ngắn trên hàng set. Câu dài dùng Barlow. Số kg dùng dấu thập phân theo locale (ví dụ `62,5`). Không rút gọn `1680` thành `1.7K` trên màn tập và trên chart tiến trình. Ngăn cách hàng nghìn theo locale được phép trên chart tổng quan khi số dài.

Cỡ chữ theo cỡ chữ hệ thống. Hàng set cao thêm khi chữ lớn. Không cắt kg. Trên bề ngang 375 pt, hàng set được phép xếp kg và reps xuống dòng thứ hai, miễn vùng chạm vẫn đạt mục 6.

## 4. Khoảng cách, bo góc, icon

Nhịp 4 và 8 dp.

| Token | dp | Dùng |
|---|---|---|
| xs | 4 | Khoảng trong một cụm số |
| sm | 8 | Giữa nút − / số / + |
| md | 16 | Padding thẻ, gutter điện thoại |
| lg | 24 | Giữa các khối trên Home, khảo sát, lịch |
| xl | 32 | Trên dưới một màn ít nội dung |

Màn đang tập dùng mật độ cao: chiều cao hàng lấy từ vùng chạm 48 dp, không từ khoảng trắng trang trí. Home, khảo sát và lịch tuần dùng `lg` giữa các khối.

| Token | dp |
|---|---|
| Ô số, chip | 8 |
| Thẻ, nút, sheet | 12 |

Không bo viên thuốc. Không bóng đổ. Phân cấp bằng nền surface và viền 1 dp.

Icon: Material Symbols **outline**, một độ dày. Cỡ vẽ 24 dp. Nút chỉ có icon phải có vùng chạm 48 dp và tên cho trình đọc màn hình. Icon cạnh chữ nhìn thấy được thì ẩn khỏi cây accessibility. Không dùng emoji làm icon điều khiển.

## 5. Chuyển động

Nhấn nút đổi opacity trong 100–150 ms, không đổi kích thước layout. Không animate hàng set, không reveal khi cuộn, không hiệu ứng khi lưu set hay khi trend tăng.

Đồng hồ nghỉ là số đếm cộng với hai nút ±15 giây. Không vòng tròn ăn mừng.

Khi hệ thống bật giảm chuyển động, bỏ mọi animation không mang thông tin. Số trên đồng hồ nghỉ vẫn cập nhật.

## 6. Vùng chạm và thanh cố định

- Nút − / +, ô số, mục chọn trong danh sách, mục tab: tối thiểu 48 × 48 dp.
- "Lưu set": cao 56 dp, rộng full nội dung, nằm trên safe area.
- Tab bar, banner và thanh đồng hồ nghỉ nằm trong safe area. Nội dung cuộn có inset đáy bằng chiều cao thanh cố định cộng 16 dp.
- Một vùng một cử chỉ chính. Hàng set không vừa vuốt xóa vừa có nút lưu.

## 7. Component dùng chung

**Nút chính.** Nền primary, chữ on-primary, cao 48 dp (56 dp với "Lưu set"), bo 12. Trạng thái nhấn: opacity. Disabled: chữ muted, nền border, không nhận chạm, semantics disabled.

**Nút phụ.** Nền trong, viền border, chữ foreground. Dùng cho "Tiếp tục tập", "Bỏ qua", "Hiện cả bài cần dụng cụ khác".

**Nút nguy hiểm.** Chữ trend-down, viền trend-down. Dùng cho xác nhận hủy hoặc xóa. Không phải nút mặc định của hộp thoại.

**Stepper.** Cụm − / số / +. Mỗi phần 48 dp. Số là Barlow Condensed. Chạm số mở bàn phím số thập phân (`docs/05`). Kg bước 2,5. Reps bước 1.

**Hàng set.** Cột: số set, Lần trước, kg, reps, Lưu set. Set đã lưu hiện dấu check bằng icon, không đổi chiều cao hàng. Chạm số set để đổi warmup (nhãn `W`). Cột "Lần trước" hiện `—` khi chưa có buổi tham chiếu.

**Trend.** Một dòng cho một chỉ số: tên chỉ số, giá trị, nhãn "tăng" / "giữ nguyên" / "giảm" hoặc delta cụ thể ("+2,5 kg"). Kèm icon mũi tên lên, gạch ngang, hoặc mũi tên xuống. Thiếu một phía thì không vẽ trend của chỉ số đó. Hiện câu "Chưa có lần trước".

**Banner buổi đang dở.** Surface, viền, tên buổi, số set đã lưu, thời điểm bắt đầu. Nút chính "Tiếp tục". Nút phụ "Hủy buổi". Không tự mở màn đang tập.

**Thẻ Hôm nay.** Nhãn "Hôm nay", danh sách nhóm cơ theo thứ tự lịch, một nút "Bắt đầu buổi tập". Ngày nghỉ: câu "Hôm nay nghỉ" và lối bắt đầu thủ công, không nút bắt đầu sẵn nhóm.

**Đồng hồ nghỉ.** Thanh dưới cùng trên màn đang tập. Số giây còn lại, nút −15 và +15, mỗi nút 48 dp. Không che nút "Lưu set": đồng hồ hiện sau khi đã lưu.

**Hộp thoại.** Tiêu đề một câu, hậu quả nói bằng số ("X set đã ghi sẽ bị xóa"). Nút an toàn là nút được nhấn mạnh. Nút phá dữ liệu dùng kiểu nguy hiểm. Scrim đủ tối để tách nội dung ở cả hai theme.

**Empty state.** Một câu nói thiếu gì và một hành động nếu có việc để làm. Không minh họa marketing.

**Chart.** `fl_chart` lấy màu từ theme. Đường 1RM màu primary. Cột volume màu muted. Nhãn trực tiếp trên series. Dưới chart có bảng số cùng dữ liệu cho trình đọc màn hình. 1–2 điểm vẫn vẽ được và hiện số lớn phía trên. Không radar.

## 8. Accessibility

- Thứ tự focus khớp thứ tự nhìn.
- Ô kg và reps có nhãn nhìn thấy, không chỉ placeholder.
- Trend, warmup, set đã lưu, tab đang chọn, câu khảo sát đang chọn: có trạng thái semantics (selected / disabled).
- Màu không phải tín hiệu duy nhất.
- Chữ thường đạt 4.5:1 ở cả hai theme. Kiểm tra riêng, không suy từ theme còn lại.
- Cỡ chữ lớn nhất của hệ thống không làm tràn trên điện thoại nhỏ. Hàng set được cao thêm hoặc xuống dòng.
- Giảm chuyển động được tôn trọng.
- Thanh cố định không che focus khi bàn phím số mở. Bàn phím đóng khi bấm "Lưu set" (`docs/05`).
- Xóa và hủy luôn có nút, không chỉ vuốt.

## 9. Việc không làm

- Không emoji làm icon. Không trộn outline và filled cùng một cấp.
- Không hard-code hex trong widget.
- Không đặt công thức volume, 1RM hay trend trong presentation.
- Không thêm streak, huy hiệu, animation ăn mừng.
- Không dùng radar cho cân bằng nhóm cơ.
- Không đưa màn đang tập vào tab bar.

## 10. Quy tắc cập nhật

1. Đổi màu, chữ, vùng chạm hoặc component dùng chung: sửa file này trước, rồi code.
2. Đổi cách nhập set: sửa `docs/05` trước. File này chỉ trích quy tắc chạm.
3. Đổi công thức hoặc ngưỡng: sửa `docs/03` trước.
4. Code và file này mâu thuẫn thì dừng và hỏi, không tự chọn.
5. Mỗi lần sửa thêm một dòng vào lịch sử.

## Lịch sử thay đổi

| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-11-04 | Tạo hệ UI: nhật ký thể thao, token sáng/tối, mặc định theo hệ thống | Chốt style trước khi code M1 |
