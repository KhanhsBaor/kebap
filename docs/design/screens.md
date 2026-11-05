# Bản đồ màn Kebap

> Trạng thái: **đã chốt 2026-11-04**. Bố cục và trạng thái từng màn M1–M7.
> Màu, chữ, nút, trend: `docs/07-ui-system.md`.
> Cách nhập set: `docs/05-log-set-interaction-spec.md`. Vòng đời buổi: `docs/06-workout-session-lifecycle.md`.
> `docs/05` trỏ `docs/design/S05-*.png`. Ảnh đó chưa có. File này là nguồn bố cục cho đến khi có ảnh.

Copy điều khiển tiếng Việt. Tên nhóm cơ và bài giữ catalog `docs/01`.

## 1. Điều hướng

Thanh dưới 3 mục, mỗi mục vùng chạm tối thiểu 48 dp, icon outline kèm chữ:

| Tab | Màn | Có từ |
|---|---|---|
| Hôm nay | S01 | M1 (khung), nội dung đầy từ M2 và M5 |
| Tiến trình | S02 | M1 (khung), chart từ M4 |
| Lịch sử | S03 | M1 (khung), danh sách từ M6 |

Lịch tuần (S08) và Cài đặt (S12) mở từ S01, không thêm tab thứ tư.

Màn đang tập (S05) là route full-screen, không nằm trong tab. Thanh tab ẩn khi đang ở S05. Nút hệ thống quay lại từ S05 về S01 và giữ buổi `in_progress`. Không kết thúc buổi bằng nút quay lại.

M1 chỉ dựng khung 3 tab, empty state một câu, và chỗ trống cho banner "Buổi đang dở". Không điền dữ liệu giả, không làm màn log hay chart giả hoàn chỉnh.

```text
S01 Hôm nay
 ├─ S04 Bắt đầu buổi (M2, prefill từ M5)
 │    └─ S05 Đang tập
 │         ├─ sheet thêm bài
 │         ├─ S06 Tạo bài custom
 │         └─ S07 Tóm tắt (sau kết thúc, M3)
 ├─ S08 Lịch tuần (M5)
 ├─ S13 Thư viện bài (M7 lọc dụng cụ)
 └─ S12 Cài đặt (M7 hồ sơ)
      └─ S10 Khảo sát (sửa hoặc tạo lại)
           └─ S11 Xem trước lịch gợi ý

S02 Tiến trình
S03 Lịch sử → S09 Chi tiết buổi
```

Lần mở đầu, chưa có hồ sơ và chưa từng bỏ qua: router chuyển tới S10 (M7). Bỏ qua thì vào S01 và không hỏi lại.

## 2. Chỉ mục

| ID | Màn | Milestone |
|---|---|---|
| S01 | Hôm nay | M1 khung, M2 banner, M5 thẻ hôm nay |
| S02 | Tiến trình | M1 khung, M4 chart |
| S03 | Lịch sử | M1 khung, M6 danh sách |
| S04 | Bắt đầu buổi | M2, prefill M5 |
| S05 | Đang tập | M2, trend M3 |
| S06 | Tạo bài custom | M2 |
| S07 | Tóm tắt buổi | M3 |
| S08 | Lịch tuần | M5, dòng cardio M7 |
| S09 | Chi tiết buổi | M6 |
| S10 | Khảo sát | M7 |
| S11 | Xem trước lịch gợi ý | M7 |
| S12 | Cài đặt | M7 |
| S13 | Thư viện bài | M2 danh sách, M7 lọc dụng cụ |

## 3. S01 Hôm nay

**Mục đích.** Biết hôm nay tập gì và vào buổi đang dở hoặc buổi mới với ít chạm.

**M1.** Tiêu đề "Hôm nay". Một câu empty: "Chưa có buổi tập." Chỗ banner để trống, không hiện banner giả. Lối tới S08 và S12 có thể là icon trên app bar (vùng chạm 48 dp, có tên).

**Có buổi `in_progress` (M2).** Banner thay nút bắt đầu. Nội dung: tên buổi (các nhóm cơ), số set đã lưu, thời điểm bắt đầu. Nút chính "Tiếp tục" mở S05 tại bài có set lưu cuối. Nút phụ "Hủy buổi" theo mục 7. Không tự mở S05.

**Không có buổi dở, đã có lịch (M5).** Thẻ "Hôm nay" liệt kê nhóm cơ đúng thứ tự, ví dụ "Chest, Shoulders, Triceps". Một nút "Bắt đầu buổi tập" tạo buổi với các nhóm đó và mở S05. Từ Home tới lưu set đầu tiên khi giữ prefill: 2 chạm (`docs/05`).

**Ngày nghỉ hoặc chưa có lịch.** Câu "Hôm nay nghỉ" hoặc "Chưa có lịch tuần". Nút "Tập ngày khác" mở S04 để chọn nhóm thủ công. Không bịa một buổi bắt buộc.

**Muốn buổi mới khi đang có buổi dở.** Hộp thoại "Bạn đang có buổi tập dở". "Tiếp tục buổi đó" hoặc "Hủy và bắt đầu buổi mới".

**Buổi dở quá 6 giờ (docs/06).** Hộp thoại khi người dùng đưa app lên trước, trước khi vào S05: "Buổi tập bắt đầu lúc … chưa được kết thúc." Ba lựa chọn: "Lưu thành buổi đã hoàn thành", "Hủy buổi", "Tiếp tục". Lưu thì `endedAt` là lúc set cuối được lưu.

## 4. S02 Tiến trình

**Mục đích.** Nhìn progressive overload dài hơn hai buổi. Metric chỉ từ `docs/03` mục 6.

**M1.** Tiêu đề "Tiến trình". Một câu: "Chart sẽ hiện sau khi có buổi đã hoàn thành."

**M4.** Ba kiểu, chọn bằng control phân đoạn (mỗi mục ≥ 48 dp):

| Kiểu | Vẽ | Trục |
|---|---|---|
| Tiến bộ bài | Đường 1RM (primary) và cột volume (muted). Chọn một bài | Ngày tập |
| Cân bằng nhóm cơ | Cột số working set / 7 ngày. Không radar | Nhóm cơ |
| Tổng quan | Cột volume buổi | Tuần hoặc tháng |

Cột ngang khi có hơn 6 nhóm. Ít hơn thì cột dọc. Nhãn trực tiếp. Bảng số dưới chart.

Phía trên chart: số lớn của điểm mới nhất (1RM hoặc volume tùy kiểu đang chọn). Dưới 4 điểm vẫn hiện số này và vẫn vẽ chart. 1–2 điểm không được làm chart lỗi.

**Trống.** Chưa có buổi `completed`: câu "Chưa có buổi đã hoàn thành để vẽ." và nút "Về Hôm nay". Đổi bộ lọc ra rỗng: câu "Không có dữ liệu trong khoảng này." Chart chỉ tính buổi `completed`.

Khoảng thời gian mặc định và mốc tuần vẫn là câu hỏi mở của M4. Spec không đặt số tuần.

## 5. S03 Lịch sử

**M1.** Tiêu đề "Lịch sử". Một câu: "Buổi đã hoàn thành sẽ nằm ở đây."

**M6.** Danh sách buổi `completed`, mới nhất trên cùng. Mỗi hàng ≥ 48 dp: ngày, các nhóm cơ, volume buổi hoặc số set. Lọc đơn giản theo nhóm cơ và khoảng thời gian. Bấm hàng mở S09.

**Trống.** "Chưa có buổi đã hoàn thành."

## 6. S04 Bắt đầu buổi

**Mục đích.** Chọn một hoặc nhiều nhóm cơ khi không đi từ thẻ Hôm nay.

**Bố cục.** Bước 1: Upper body, Lower body, Other. Bước 2: các nhóm của region đó, chọn nhiều, có thứ tự chọn. Nút "Bắt đầu buổi tập" chỉ bật khi đã chọn ít nhất một nhóm. Prefill từ lịch (M5) vẫn cho bỏ hoặc thêm nhóm trước khi bắt đầu.

MVP không thêm bài ngoài các nhóm đã chọn.

**Trống.** Catalog seed chưa có (chỉ xảy ra lúc dev): câu lỗi "Chưa có nhóm cơ." Không nút bắt đầu.

## 7. S05 Đang tập

**Mục đích.** Ghi set với ít chạm. Đây là màn mật độ cao của hệ UI.

**Đầu màn.** Tên các nhóm cơ của buổi. Menu "⋯" có "Hủy buổi tập" và "Kết thúc". Nút kết thúc cũng có trên thanh cuối khi không mở bàn phím.

**Mỗi bài.** Tên bài. Dòng tham chiếu dưới tên: số lần trước, hoặc "Chưa có lần trước". Từ M3, dưới tên có hai trend riêng (volume và 1RM, hoặc reps nếu kg = 0). M2 chỉ hiện số ở cột "Lần trước", chưa vẽ trend.

**Hàng set.** Cột Set, Lần trước, kg, Reps, Lưu set. Quy tắc prefill, − / +, bàn phím số, warmup, undo bằng cách chạm lại check: `docs/05`. "Lưu set" cao 56 dp. Set đã lưu không còn stepper. Hàng dự kiến (chưa lưu) không phải dữ liệu.

**Thêm bài.** Sheet danh sách bài của các nhóm trong buổi. Ô tìm theo tên được phép. Bài custom và seed cùng danh sách. Chạm hàng để thêm. Nút "Tạo bài mới" mở S06. Từ M7: danh sách lọc theo dụng cụ trong hồ sơ, kèm nút phụ "Hiện cả bài cần dụng cụ khác". Bài custom luôn hiện.

**Đồng hồ nghỉ.** Hiện sau mỗi lần lưu. Mặc định theo bảng mục tiêu ở `docs/01`. Chưa có hồ sơ thì 90 giây. Nút ±15 giây. Không tự nhảy sang set kế.

**M3 trên màn này.** Trend cạnh bài, ít chữ. Đọc được trong 3 giây. Không nhét `groupVolume` vào S05. Dòng đó thuộc S07.

**Trạng thái.** Bài không có set: vẫn ở danh sách, hàng dự kiến theo số set của mục tiêu. Kill app: set đã lưu còn, số đang gõ và đồng hồ nghỉ không còn (`docs/06`).

## 8. S06 Tạo bài custom

Sheet hoặc màn ngắn. Một ô "Tên bài" có nhãn nhìn thấy. Nếu buổi có nhiều nhóm, chọn một nhóm trong các nhóm của buổi. Nút "Thêm vào buổi". Tên trống thì nút disabled. Bài gắn `muscleGroupId` đang chọn, `isCustom = true`, hiện trong list nhóm đó.

## 9. S07 Tóm tắt buổi

**Mục đích.** Đọc xong buổi vừa `completed`: từng bài so với lần gần nhất của chính bài đó, rồi volume từng nhóm.

**Bố cục.** Ngày buổi. Với mỗi bài: tên, ngày buổi tham chiếu (có thể khác nhau giữa các bài), cột đôi volume. Bài có tạ: thêm 1RM ước tính cao nhất, trend riêng. Bài bodyweight (kg = 0): cột đôi tổng reps, không volume tạ. Cuối mỗi nhóm cơ: một dòng `groupVolume` và một trend. Thiếu một phía thì không hiện trend của chỉ số đó.

Không dùng chart cho màn này. Không gộp một trend cho cả buổi thay cho từng bài.

**Trống từng bài.** "Chưa có lần trước". Buổi vừa xong vẫn hiện số hôm nay.

Nút "Xong" về S01. Buổi đã nằm trong Lịch sử.

## 10. S08 Lịch tuần

**Mục đích.** Gán nhóm cơ cho 7 ngày để S01 bắt đầu nhanh.

Bảy hàng, Thứ Hai trước (khớp weekday ISO của `docs/04`, 1 = Thứ Hai). Mỗi ngày: nhiều nhóm có thứ tự, hoặc nhãn "Nghỉ" khi không có nhóm. Chạm ngày để thêm hoặc bỏ nhóm từ catalog region → group. Kéo đổi thứ tự trong ngày nếu danh sách có từ hai nhóm. Mỗi tay cầm ≥ 48 dp.

Lưu ngay vào lịch M5. S01 đọc cùng nguồn.

**M7.** Nếu mục tiêu là Giảm mỡ: một dòng chữ trên đầu màn, ví dụ "Nên thêm cardio: đi bộ hoặc đạp xe". Không thêm nhóm `cardio`. Ngày có quadriceps và hồ sơ đau gối: cờ chữ "Đau gối" trên ngày đó, không tự xóa quadriceps.

**Trống.** Cả tuần nghỉ hợp lệ. S01 hiện lối tập thủ công.

## 11. S09 Chi tiết buổi

**Mục đích.** Sửa số đã ghi mà không thêm bước vào lúc đang tập.

Ngày, nhóm cơ snapshot, từng bài và set. Sửa kg và reps tại chỗ bằng stepper hoặc bàn phím số, cùng nhãn với S05. Xóa một set: xác nhận. Xóa cả buổi: hộp thoại nêu số set sẽ mất, nút nguy hiểm "Xóa buổi", nút an toàn "Giữ lại".

Sau khi sửa, S07 (nếu mở từ buổi sau), trend và chart cập nhật không cần khởi động lại app.

**Trống.** Buổi không còn set nào sau khi xóa hết: cho xóa buổi hoặc để buổi không set. Không tạo lại set dự kiến trên buổi `completed`.

Không sửa danh sách nhóm cơ của buổi đã hoàn thành trong spec này (câu hỏi mở của M6).

## 12. S10 Khảo sát

**Mục đích.** Vài câu để có lịch tuần. Không chặn người đã bỏ qua.

Mỗi màn một câu. Thanh tiến trình là chữ "Câu 2 / 5", không chỉ một dải màu. Danh sách lựa chọn, mỗi mục ≥ 48 dp, trạng thái selected. "Tiếp tục" disabled khi chưa chọn. "Quay lại" sửa câu trước. "Bỏ qua" luôn có.

Câu 1–5 bắt buộc nếu không bỏ qua cả luồng: mục tiêu, kinh nghiệm, số buổi (2–6), thời lượng (30 / 45 / 60 / 90), dụng cụ. Bỏ qua ở câu 1–5 thì thoát cả khảo sát, không lưu câu dở, vào S01, không hỏi lại.

Câu 6–9 hiện sau câu 5, bỏ qua được từng câu: nhóm ưu tiên (tối đa 2, Upper hoặc Lower), chỗ đau (vai, lưng dưới, gối), cân nặng kg, năm sinh. Ô cân nặng và năm sinh là bàn phím số, có nhãn, có nút bỏ qua câu đó.

Hết câu thì sang S11. Không hỏi chiều cao.

## 13. S11 Xem trước lịch gợi ý

**Mục đích.** Thấy lịch trước khi ghi đè lịch M5.

Bảy ngày, cùng cách đọc với S08. Phía trên, mỗi điều chỉnh của bộ quy tắc một dòng chữ (ví dụ giới hạn còn 4 buổi, bỏ shoulders vì đau vai). Cờ đau gối và dòng cardio giảm mỡ hiện cùng quy tắc với S08.

Nút chính "Áp dụng". Nếu lịch M5 đang có dữ liệu: hộp thoại "Lịch hiện tại sẽ bị thay bằng lịch gợi ý." Nút "Áp dụng" và "Giữ lịch cũ". Áp dụng xong về S01, thẻ Hôm nay khớp ngày hôm nay.

Nút phụ "Sửa tay" mở S08 với lịch gợi ý chưa ghi, hoặc đã ghi nếu người dùng vừa áp dụng. Không gọi mạng ở màn này.

## 14. S12 Cài đặt

**Mục đích.** Sửa hồ sơ và tạo lại lịch.

Hiện các câu đã trả lời. Cân nặng và năm sinh có thể trống. "Sửa hồ sơ" mở S10 với câu trả lời cũ. "Tạo lại lịch gợi ý": nếu thiếu câu bắt buộc thì mở S10. Đủ thì chạy bộ quy tắc và mở S11.

Không có mục tài khoản, sync, hay theme tùy chỉnh trong MVP. Sáng/tối theo hệ thống (`docs/07`).

## 15. S13 Thư viện bài

**Mục đích.** Xem bài seed và custom ngoài buổi tập. Thêm bài vào buổi vẫn dùng sheet trên S05.

Nhóm theo region rồi muscle group. Hàng bài: tên, dụng cụ nếu là seed. Custom không hiện dụng cụ.

**M7.** Lọc theo bảng dụng cụ ở `docs/04`. Nút "Hiện cả bài cần dụng cụ khác". Bài custom luôn hiện. Chưa có hồ sơ: hiện mọi bài seed, không lọc.

**Trống.** Nhóm không có bài: "Chưa có bài trong nhóm này." Kèm "Tạo bài mới" khi đang đứng trong một nhóm (cùng luật S06, không thêm vào buổi nếu không có buổi `in_progress`).

## 16. Hộp thoại buổi tập

Dùng chung cho S01 và S05. Chi tiết hành vi: `docs/06`. Kiểu nút: `docs/07`.

| Tình huống | Câu | Nút an toàn | Nút nguy hiểm |
|---|---|---|---|
| Hủy khi chưa có set | Không hộp thoại. Xóa và về S01 | — | — |
| Hủy khi đã có set | "Hủy buổi tập? X set đã ghi sẽ bị xóa." | Tiếp tục tập | Hủy buổi |
| Kết thúc khi 0 set | "Chưa có set nào được ghi" | Tiếp tục tập | Hủy buổi tập |
| Kết thúc còn set dự kiến | "Còn N set chưa ghi ở M bài. Kết thúc và bỏ qua các set này?" | Tiếp tục tập | Kết thúc |
| Xóa buổi ở S09 | Nêu số set sẽ mất | Giữ lại | Xóa buổi |

Số đang gõ dở chưa bấm "Lưu set" tính là chưa ghi.

## 17. Việc không vẽ trong MVP

- Màn 1RM riêng, heat map, chia sẻ, coach trong lúc tập.
- Log cardio thời lượng và quãng đường (V1.1). M7 và S08 chỉ có một dòng chữ.
- M8 dùng lại S11. Cách gọi server không thuộc file này.

## 18. Quy tắc cập nhật

1. Đổi bố cục hoặc trạng thái một màn: sửa file này trước, rồi code.
2. Đổi ngân sách chạm hoặc cách nhập set: sửa `docs/05` trước.
3. Đổi vòng đời buổi: sửa `docs/06` trước.
4. Đổi màu và component dùng chung: sửa `docs/07` trước.
5. Mỗi lần sửa thêm một dòng vào lịch sử.

## Lịch sử thay đổi

| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-11-04 | Bản đồ S01–S13 cho M1–M7, tab 3 mục, S05 full-screen | Chốt bố cục trước khi code theme và màn |
