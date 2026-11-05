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
Dùng để so sánh từng bài hôm nay với lần gần nhất của chính bài đó (mục 5).

## 2. Volume theo số set (set volume): dùng cho chart nhóm cơ
```
Volume tuần của 1 nhóm cơ = số working set trong 7 ngày
```
Working set = set hợp lệ theo mục 4 (không warmup, có đủ kg và reps; bài bodyweight kg = 0 vẫn tính).
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

## 5. So sánh buổi tập
Chỉ xét buổi `completed` có ít nhất một set hợp lệ. Buổi `in_progress` không bao giờ là buổi tham chiếu.

**Theo từng bài (đã chốt 2026-11-04).** Với mỗi bài trong buổi hiện tại, buổi tham chiếu là buổi `completed` gần nhất có đúng `exerciseId` đó và `endedAt` trước `startedAt` của buổi hiện tại. Hai bài trong cùng một buổi có thể trỏ tới hai buổi khác nhau. Hai buổi `completed` cùng ngày lịch vẫn so được với nhau.

- So với buổi tham chiếu của bài đó: load volume và 1RM ước tính cao nhất.
- Bài bodyweight (mọi set hợp lệ ở cả hai phía có kg = 0): so tổng reps của các set hợp lệ thay cho volume; không so 1RM (theo mục 4).
- Chỉ số không có ở một phía (không có buổi tham chiếu, không có set hợp lệ, hoặc không set nào reps ≤ 10 cho 1RM): không hiển thị trend cho chỉ số đó.
- Mỗi chỉ số có trend riêng (tăng / giữ nguyên / giảm). Δ% = (hôm nay − tham chiếu) / tham chiếu. Ngưỡng "giữ nguyên": |Δ%| ≤ 2% (có thể chỉnh).

**Theo nhóm cơ (thêm, không thay so sánh theo bài).** Với mỗi muscle group có trong buổi:

```
groupVolume = Σ load volume các set hợp lệ của bài thuộc nhóm đó, bỏ set kg = 0
```

Buổi tham chiếu của nhóm là buổi `completed` gần nhất (cùng mốc `endedAt` < `startedAt`) có ít nhất một bài của nhóm đó. Một trend cho `groupVolume`, cùng ngưỡng ±2%. Nếu một phía không có volume tạ (toàn bodyweight hoặc không có set hợp lệ) thì không hiện trend nhóm.

## 6. Mapping chart
| Chart | Chỉ số | Trục X |
|---|---|---|
| Tiến bộ từng bài tập | 1RM ước tính (đường) + volume bài (cột) | Ngày tập |
| So sánh từng bài với lần gần nhất của bài đó | Volume từng bài, cột đôi (ngày tham chiếu có thể khác nhau; UI ghi ngày) | Tên bài tập |
| Cân bằng nhóm cơ | Số set mỗi tuần | Nhóm cơ (radar/cột) |
| Tổng quan lâu dài | Volume buổi | Tuần hoặc tháng |

So sánh `groupVolume` (mục 5) là một dòng trên màn tóm tắt buổi, không phải loại chart riêng. Chart và set volume chỉ tính set của buổi `completed`.

## 7. Vị trí trong code
- Hàm tính toán là Dart thuần, đặt trong `lib/features/<feature>/domain/` (ví dụ `calculations/`).
- Mỗi hàm có unit test; test dùng đúng các ví dụ trong file này.
- Tên hàm tham chiếu: `setVolume`, `exerciseVolume`, `sessionVolume`, `groupVolume`, `estimated1RM`, `weeklySetCount`.

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
| 2026-11-04 | Mục 5: tham chiếu theo `exerciseId` (`endedAt` trước `startedAt`, chỉ buổi completed); thêm `groupVolume`. Mục 6: cột đôi theo lần gần nhất của từng bài; chart chỉ tính buổi completed | Chốt buổi nhiều nhóm cơ; thêm so sánh theo nhóm; khớp `docs/06` |
| 2026-11-04 | Định nghĩa working set (mục 2); mục 5: trend riêng từng chỉ số, Δ%, bodyweight so reps, chỉ số thiếu một phía không có trend, đánh dấu buổi tham chiếu nhiều nhóm chưa chốt | So sánh bodyweight chia cho 0; một nhãn trend cho hai chỉ số ngược chiều (doc review) |
| 2026-10-23 | Gắn pointer agent: `docs/calculations.md`, Cursor rule `.cursor/rules/calculation-rules.mdc`; đồng bộ ROADMAP/M2–M4/AGENTS | Enforce nguồn sự thật |
| 2026-10-23 | Tạo file với công thức volume, set volume, 1RM Epley, quy tắc set hợp lệ | Khởi tạo |
