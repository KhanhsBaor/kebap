# Business Analysis — Kebap

> Skeleton: bổ sung khi chốt MVP chi tiết.

## Vấn đề

Người tập gym khó thấy progressive overload nếu không so được từng bài hôm nay với lần gần nhất của chính bài đó.

## Core value

So sánh buổi tập (volume / load / reps) → thấy tiến bộ hoặc tụt.

## Luồng chính (MVP)

1. Setup lịch tuần theo nhóm cơ
2. Bắt đầu buổi tập theo lịch / nhóm cơ
3. Log set / rep / kg nhanh
4. So sánh từng bài với lần gần nhất của bài đó
5. Xem chart tiến trình theo thời gian

## Nguyên tắc UX

- Offline-first, không phụ thuộc mạng khi tập
- Luồng đang tập: ít chạm nhất có thể

## Catalog bài tập (đã chốt)

Cây 3 tầng, **cố định** (seed; không CRUD region/nhóm cơ ở MVP):

```text
Body region → Muscle group → Exercise
```

| Region (`slug`) | Muscle groups (display · gợi ý `slug`) |
|-----------------|----------------------------------------|
| **Upper body** (`upper_body`) | Abdominals (`abdominals`), Biceps (`biceps`), Chest (`chest`), Forearms (`forearms`), Lats (`lats`), Lower back (`lower_back`), Neck (`neck`), Shoulders (`shoulders`), Traps (`traps`), Triceps (`triceps`), Upper back (`upper_back`) |
| **Lower body** (`lower_body`) | Abductors (`abductors`), Adductors (`adductors`), Calves (`calves`), Glutes (`glutes`), Hamstrings (`hamstrings`), Quadriceps (`quadriceps`) |
| **Other** (`other`) | Cardio (`cardio`), Full body (`full_body`), Others (`others`) |

**Luồng UI chọn bài:** Region → Muscle group → danh sách Exercise thuộc nhóm đó.

**Lịch và chart set-volume** theo **muscle group** (vd. `chest`), không theo region. **So sánh buổi** theo từng bài (`docs/03` mục 5), cộng thêm volume theo nhóm cơ trên màn tóm tắt.

**Nhiều nhóm cơ mỗi buổi (đã chốt 2026-11-04):** một ngày trong lịch tuần và một buổi tập có thể gồm **một hoặc nhiều** muscle group (vd. ngày Push = Chest + Shoulders + Triceps). Mỗi exercise vẫn thuộc đúng một muscle group. Buổi tham chiếu (đã chốt 2026-11-04): theo từng bài, buổi `completed` gần nhất có đúng bài đó (`docs/03` mục 5). Màn tóm tắt thêm so sánh volume theo nhóm cơ.

**Exercise (đã chốt):**

- **Seed** từ [ExerciseGymGifsDB](https://github.com/JahelCuadrado/ExerciseGymGifsDB) `v1.1.0` (1323 bài). Metadata nằm ở `seed/exercises.csv`. Ship offline trong app (không gọi CDN khi tập). GIF không đưa vào app.
- Tên bài có `nameEn` (từ nguồn) và `nameVi` (nguồn không có tiếng Việt, cột đang trống). Giao diện app dùng cả tiếng Anh và tiếng Việt.
- Nhóm cơ và dụng cụ Kebap do chủ dự án điền vào `kebapMuscleGroup` và `kebapEquipment` trước khi M2 import. Nhãn gốc của nguồn không dùng trực tiếp.
- **Custom:** user được tạo bài mới, gắn với **muscle group đang chọn** (không đổi region/group list cố định).
- Custom và seed cùng schema (`isCustom` / tương đương); so sánh theo `exerciseId` + cùng muscle group như `docs/03`.

## Khảo sát người tập (đã chốt 2026-11-04)

Mục đích: đủ thông tin để **gợi ý lịch tuần**, đặt mặc định set/rep/nghỉ, và lọc bài theo dụng cụ. Chạy ở lần mở app đầu tiên; mỗi màn một câu; luôn có **Bỏ qua**; sửa lại được trong Cài đặt. Không chặn người dùng vào app.

**Bỏ qua:** ở câu bắt buộc (1–5) → thoát cả khảo sát, không lưu câu trả lời dở. Câu tùy chọn (6–9) hiện sau câu 5, bỏ qua được từng câu. "Tạo lại lịch gợi ý" khi hồ sơ thiếu câu bắt buộc → mở lại khảo sát.

**Bắt buộc (nếu không bỏ qua khảo sát):**

| # | Câu hỏi | Lựa chọn | Dùng để |
|---|---------|----------|---------|
| 1 | Mục tiêu | Tăng cơ · Tăng sức mạnh · Giảm mỡ · Khỏe tổng quát | Số set, khoảng rep, thời gian nghỉ mặc định (bảng dưới). Khỏe tổng quát với ≤ 3 buổi → mẫu `full`. Giảm mỡ → dòng chữ gợi ý cardio trên màn lịch tuần, không thêm nhóm cơ (`docs/04`) |
| 2 | Kinh nghiệm | Mới bắt đầu · Đã tập | Chọn cột kiểu chia lịch trong `docs/04` mục 3 |
| 3 | Số buổi mỗi tuần | 2 – 6 | Số ngày tập trong lịch |
| 4 | Thời lượng mỗi buổi | 30 · 45 · 60 · 90 phút | Số nhóm cơ mỗi buổi (`docs/04` mục 4 bước 5) |
| 5 | Dụng cụ | Phòng gym đầy đủ · Tạ đơn ở nhà · Không dụng cụ | Lọc danh sách bài khi thêm vào buổi và ở màn thư viện (`docs/04`). Không đổi nhóm cơ của ngày |

**Tùy chọn:**

| # | Câu hỏi | Dùng để |
|---|---------|---------|
| 6 | Nhóm cơ muốn ưu tiên (tối đa 2, chọn trong Upper body / Lower body) | Thêm nhóm đó vào các ngày tập cùng region |
| 7 | Chỗ đau / cần tránh: vai · lưng dưới · gối | Vai / lưng dưới: loại nhóm cơ tương ứng; gối: cảnh báo trên ngày có quadriceps (`docs/04` mục 4) |
| 8 | Cân nặng (kg) | Chỉ lưu. Chưa đưa vào công thức (bodyweight nâng cao để sau). Có nút bỏ qua |
| 9 | Năm sinh | Từ 60 tuổi trở lên tối đa 4 buổi/tuần (`docs/04` mục 4). Có nút bỏ qua |

**Mặc định set / rep / nghỉ theo mục tiêu** (dùng khi chưa có set trước để prefill; chưa có hồ sơ thì dùng dòng Khỏe tổng quát):

| Mục tiêu | Số set | Khoảng rep | Nghỉ |
|---|---|---|---|
| Tăng cơ | 3 | 8–12 | 90 giây |
| Tăng sức mạnh | 5 | 3–6 | 180 giây |
| Giảm mỡ | 3 | 12–15 | 60 giây |
| Khỏe tổng quát | 3 | 8–12 | 90 giây |

Không hỏi chiều cao (không ảnh hưởng lịch). Không theo dõi cân nặng theo thời gian (vẫn thuộc nhóm C).

**Gợi ý lịch:** quy tắc trong `docs/04-schedule-suggestion-rules.md`. MVP dùng bộ quy tắc offline (M7); gợi ý bằng AI là bước sau (M8), luôn có bộ quy tắc làm dự phòng.
