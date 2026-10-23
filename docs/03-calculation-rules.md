# Quy tắc tính toán (nguồn sự thật duy nhất)

> File này là nguồn chính thức cho mọi công thức của app kebap (volume, 1RM, so sánh buổi tập, chart).
> **Agent được phép và có trách nhiệm cập nhật file này** khi công thức hoặc quy tắc thay đổi.
> Quy tắc cập nhật ở cuối file.

## 1. Volume tải (load volume): dùng cho chart tiến bộ
```
Volume 1 set     = kg × reps
Volume 1 bài tập = Σ (kg × reps) của các set hợp lệ
Volume 1 buổi    = Σ volume các bài tập trong buổi
```
Ví dụ: Bench Press 60×10, 60×10, 60×8 → 600 + 600 + 480 = 1.680 kg.
Dùng để so sánh buổi hôm nay với buổi gần nhất cùng nhóm cơ.

## 2. Volume theo số set (set volume): dùng cho chart nhóm cơ
```
Volume tuần của 1 nhóm cơ = số working set trong 7 ngày
```
Không phụ thuộc mức tạ nên so sánh công bằng giữa các bài tập khác nhau.

## 3. 1RM ước tính (Epley)
```
1RM ≈ kg × (1 + reps / 30)      (reps = 1 thì 1RM = kg)
```
- Chỉ tính cho set có reps ≤ 10 (ngoài khoảng này kém chính xác).
- Mỗi bài tập trong một buổi lấy 1RM cao nhất để vẽ chart.

## 4. Set hợp lệ và các trường hợp đặc biệt
| Trường hợp | Quy tắc |
|---|---|
| Set khởi động (`isWarmup = true`) | Loại khỏi mọi phép tính volume và 1RM |
| Set thiếu kg hoặc reps | Bỏ qua, KHÔNG tính là 0 |
| Bài tập bodyweight (kg = 0) | Mặc định dùng reps làm chỉ số riêng; bản nâng cao: (cân nặng người dùng + tạ thêm) × reps |
| Đơn vị | Lưu DB bằng kg; chỉ đổi sang lb khi hiển thị |

## 5. So sánh hai buổi tập
- Buổi tham chiếu: buổi gần nhất cùng nhóm cơ (hoặc cùng split day), ngày trước buổi hiện tại.
- So sánh theo từng bài tập có mặt ở cả hai buổi: volume, 1RM ước tính cao nhất.
- Kết quả: tăng / giữ nguyên / giảm. Ngưỡng "giữ nguyên": chênh lệch trong ±2% (có thể chỉnh).

## 6. Mapping chart
| Chart | Chỉ số | Trục X |
|---|---|---|
| Tiến bộ từng bài tập | 1RM ước tính (đường) + volume bài (cột) | Ngày tập |
| So sánh 2 buổi cùng loại | Volume từng bài, cột đôi | Tên bài tập |
| Cân bằng nhóm cơ | Số set mỗi tuần | Nhóm cơ (radar/cột) |
| Tổng quan lâu dài | Volume buổi | Tuần hoặc tháng |

## 7. Vị trí trong code
- Hàm tính toán là Dart thuần, đặt trong `lib/features/<feature>/domain/` (ví dụ `calculations/`).
- Mỗi hàm có unit test; test dùng đúng các ví dụ trong file này.
- Tên hàm tham chiếu: `setVolume`, `exerciseVolume`, `sessionVolume`, `estimated1RM`, `weeklySetCount`.

```dart
double setVolume(double kg, int reps) => kg * reps;

double exerciseVolume(List<SetLog> sets) => sets
    .where((s) => !s.isWarmup && s.kg != null && s.reps != null)
    .fold(0.0, (sum, s) => sum + s.kg! * s.reps!);

double estimated1RM(double kg, int reps) =>
    reps == 1 ? kg : kg * (1 + reps / 30);
```

## 8. Quy tắc cập nhật file này (dành cho agent)
1. Khi thay đổi công thức, ngưỡng hoặc quy tắc: sửa file này TRƯỚC, rồi sửa code và test cho khớp.
2. Nếu code và file này mâu thuẫn, dừng lại và hỏi người dùng, không tự chọn bên nào.
3. Mỗi lần sửa phải thêm một dòng vào Lịch sử thay đổi bên dưới (ngày, thay đổi, lý do).
4. Không xóa quy tắc cũ khi chưa được người dùng đồng ý; đánh dấu "đã thay thế" nếu cần.

## Lịch sử thay đổi
| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-10-23 | Gắn pointer agent: `docs/calculations.md`, Cursor rule `.cursor/rules/calculation-rules.mdc`; đồng bộ ROADMAP/M2–M4/AGENTS | Enforce nguồn sự thật |
| 2026-10-23 | Tạo file với công thức volume, set volume, 1RM Epley, quy tắc set hợp lệ | Khởi tạo |
