# Quy tắc gợi ý lịch tập (nguồn sự thật)

> Nguồn chính thức cho bộ quy tắc offline sinh lịch tuần từ khảo sát (`docs/01-business-analysis.md` § Khảo sát người tập).
> Gợi ý bằng AI (M8) phải trả kết quả cùng định dạng ở mục 1 và qua cùng bước kiểm tra ở mục 5; lỗi thì dùng bộ quy tắc này.
> Quy tắc cập nhật file ở cuối.

## 1. Đầu vào và đầu ra

**Đầu vào:** hồ sơ khảo sát — `goal`, `experience` (Mới bắt đầu / Đã tập), `sessionsPerWeek` (2–6), `sessionMinutes` (30/45/60/90), `equipment`, `priorityGroups` (≤ 2), `limitations`, `birthYear` (tùy chọn).

**Đầu ra:** danh sách ngày tập, mỗi ngày gồm `weekday` (ISO: 1 = Thứ Hai … 7 = Chủ Nhật) và danh sách **slug muscle group có thứ tự**. Ngày không có trong danh sách là ngày nghỉ.

Cờ cảnh báo đau gối (mục 4, bước 4) và cờ chữ Giảm mỡ (bước 7) không thuộc đầu ra danh sách nhóm: domain tính từ hồ sơ, áp dụng như nhau cho lịch từ bộ quy tắc và từ AI (AI không cần trả các cờ này).

Lịch gợi ý chỉ chọn **nhóm cơ cho từng ngày**. Gợi ý bài tập cụ thể và số set/rep không thuộc phạm vi file này.

## 2. Mẫu ngày tập

Thứ tự trong danh sách là **thứ tự ưu tiên**, dùng khi cắt theo thời lượng (mục 4, bước 5).

| Mẫu | Muscle groups (theo thứ tự ưu tiên) |
|---|---|
| `full` | chest, lats, quadriceps, shoulders, hamstrings, abdominals |
| `push` | chest, shoulders, triceps |
| `pull` | lats, upper_back, biceps |
| `legs` | quadriceps, hamstrings, glutes, calves |
| `upper` | chest, lats, shoulders, upper_back, triceps, biceps |
| `lower` | quadriceps, hamstrings, glutes, calves, abdominals |

## 3. Chọn kiểu chia lịch và xếp ngày

| Số buổi | Mới bắt đầu | Đã tập | Thứ trong tuần |
|---|---|---|---|
| 2 | full, full | full, full | 1, 4 |
| 3 | full, full, full | push, pull, legs | 1, 3, 5 |
| 4 | upper, lower, upper, lower | upper, lower, upper, lower | 1, 2, 4, 5 |
| 5 | (giới hạn về 4) | push, pull, legs, upper, lower | 1, 2, 3, 5, 6 |
| 6 | (giới hạn về 4) | push, pull, legs, push, pull, legs | 1, 2, 3, 4, 5, 6 |

## 4. Thứ tự áp dụng

1. **Giới hạn số buổi:** Mới bắt đầu, hoặc `birthYear` cho thấy từ 60 tuổi trở lên → tối đa 4 buổi.
2. **Chọn kiểu chia** theo bảng mục 3. Riêng mục tiêu *Khỏe tổng quát* với ≤ 3 buổi → luôn dùng `full`.
3. **Xếp thứ** theo cột "Thứ trong tuần".
4. **Hạn chế:** đau vai → bỏ `shoulders` khỏi mọi ngày. Đau lưng dưới → bỏ `lower_back` (mẫu hiện không chứa, giữ để AI tuân theo). Đau gối → không bỏ nhóm; ngày có `quadriceps` mang cờ cảnh báo để UI hiển thị (cách tính cờ: mục 1).
5. **Cắt theo thời lượng:** 30 phút → giữ tối đa 3 nhóm đầu; 45 phút → tối đa 4; 60 và 90 phút → giữ nguyên.
6. **Nhóm ưu tiên:** thêm vào cuối mọi ngày tập có mẫu cùng region mà danh sách hiện tại (sau bước 5) chưa chứa nhóm đó. Bỏ qua nhóm ưu tiên đã bị loại ở bước 4 (hạn chế luôn thắng ưu tiên). `full` tính là cả Upper body và Lower body; `push`, `pull`, `upper` là Upper body; `legs`, `lower` là Lower body. Bước này không bị giới hạn ở bước 5.
7. **Giảm mỡ:** không thêm nhóm cơ. Cờ chữ (domain suy từ `goal`) để màn lịch tuần hiện một dòng gợi ý, ví dụ "Nên thêm cardio: đi bộ hoặc đạp xe". Log thời lượng và quãng đường thuộc V1.1, không thuộc file này.

`equipment` không đổi nhóm cơ của ngày. Enum trên bài seed (bắt buộc, không null): `barbell`, `dumbbell`, `machine`, `cable`, `bodyweight`, `other`. Bài custom để trống và luôn hiện.

| Dụng cụ trong hồ sơ | Bài được hiện |
|---|---|
| Phòng gym đầy đủ | Mọi bài |
| Tạ đơn ở nhà | `dumbbell` + `bodyweight` |
| Không dụng cụ | `bodyweight` |

Nút "Hiện cả bài cần dụng cụ khác" bỏ lọc. Lọc áp khi thêm bài vào buổi và ở màn thư viện bài.

## 5. Kiểm tra kết quả (bắt buộc với cả quy tắc và AI)

- Mọi slug phải có trong catalog `docs/01-business-analysis.md`.
- Số ngày tập = số buổi sau bước 1; `weekday` trong 1–7, không trùng; mỗi ngày có ≥ 1 nhóm.
- Không chứa nhóm đã bị loại ở bước 4.
- Số nhóm mỗi ngày ≤ giới hạn bước 5 + số nhóm ưu tiên.
- Mỗi nhóm ưu tiên còn lại sau bước 4 có mặt ít nhất một ngày.
- Sai bất kỳ điều kiện nào → bỏ kết quả, dùng kết quả từ bộ quy tắc.

## 6. Ví dụ (dùng làm unit test)

| Đầu vào | Kết quả |
|---|---|
| Mới bắt đầu · 3 buổi · 60' · gym · Tăng cơ | 1, 3, 5: chest, lats, quadriceps, shoulders, hamstrings, abdominals |
| Đã tập · 4 buổi · 45' · Giảm mỡ | Không thêm cardio. 1, 4: chest, lats, shoulders, upper_back · 2, 5: quadriceps, hamstrings, glutes, calves. Cờ chữ cardio trên màn lịch tuần |
| Mới bắt đầu · 6 buổi · 30' · Tăng cơ · đau vai · ưu tiên glutes | Giới hạn về 4 buổi. 1, 4: chest, lats, upper_back · 2, 5: quadriceps, hamstrings, glutes |
| Đã tập · 4 buổi · 60' · Tăng cơ · đau vai · ưu tiên shoulders | Không ngày nào có shoulders. 1, 4: chest, lats, upper_back, triceps, biceps · 2, 5: quadriceps, hamstrings, glutes, calves, abdominals |
| Mới bắt đầu · 3 buổi · 30' · Tăng cơ · ưu tiên hamstrings | 1, 3, 5: chest, lats, quadriceps, hamstrings |

## 7. Vị trí trong code

- Dart thuần trong `lib/features/onboarding/domain/` (vd. `schedule_suggestion/`), không import Flutter / Riverpod / Drift.
- Contract `ScheduleSuggester`; bản cài đặt offline `RuleBasedScheduleSuggester`. Bản AI (M8) nằm ở tầng data và luôn qua bước kiểm tra mục 5.
- Mỗi ví dụ ở mục 6 có một unit test.

## 8. Quy tắc cập nhật file này (dành cho agent)

1. Đổi mẫu ngày, bảng chia lịch hoặc thứ tự áp dụng: sửa file này TRƯỚC, rồi sửa code và test.
2. Code và file này mâu thuẫn: dừng lại và hỏi người dùng.
3. Mỗi lần sửa thêm một dòng vào Lịch sử thay đổi.
4. Quy tắc gợi ý không phải lời khuyên y tế; không thêm quy tắc dựa trên bệnh lý khi chưa có người dùng đồng ý.

## Lịch sử thay đổi

| Ngày | Thay đổi | Lý do |
|---|---|---|
| 2026-11-04 | Bỏ slug `cardio` khỏi lịch Giảm mỡ (cờ chữ trên màn lịch tuần); kinh nghiệm còn 2 mức; thêm bảng lọc dụng cụ; sửa ví dụ và kiểm tra mục 5 | Ba quyết định M7 |
| 2026-11-04 | Bước 6: xét danh sách sau bước 5, bỏ qua nhóm đã bị loại ở bước 4; cờ đau gối do domain tính, không thuộc đầu ra; thêm 2 ví dụ | Nhóm ưu tiên trùng chỗ đau làm bộ quy tắc fail kiểm tra mục 5 (doc review) |
| 2026-11-04 | Mục 5: thêm kiểm tra weekday 1–7, số nhóm mỗi ngày, nhóm ưu tiên có mặt | Lịch AI vi phạm thời lượng vẫn qua kiểm tra (doc review) |
| 2026-11-04 | Tạo file: mẫu ngày, bảng chia lịch, thứ tự áp dụng, kiểm tra kết quả, ví dụ | Khảo sát người tập + gợi ý lịch (M7) |
