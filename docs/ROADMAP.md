# Kebap Roadmap

Roadmap milestone theo **lát cắt chạy được / demo được** (không chia theo lớp kỹ thuật).  
Chi tiết từng milestone: `docs/milestones/`.

> **Lưu ý nguồn:** `docs/01-business-analysis.md` hiện là skeleton — **chưa có nhóm B/C**.  
> Phần [Ngoài phạm vi MVP](#ngoài-phạm-vi-mvp) bên dưới là **đề xuất tạm** từ ràng buộc MVP (offline-first, 5 bước luồng chính) + tính năng gym-app thường gặp ngoài 5 bước đó. Cần bạn chốt trước khi code M1+.

## Bảng milestone

| ID | Tên | Mục tiêu | Phụ thuộc | Trạng thái |
|----|-----|----------|-----------|------------|
| M0 | Agent docs + kiến trúc | Rules, `AGENTS.md`, Clean Architecture + Riverpod/Drift đã chốt trên giấy | — | done |
| M1 | Khung dự án | App chạy được: thư mục feature-first, Drift shell, go_router, theme, Riverpod root, CI analyze/test | M0 | done |
| M2 | Log buổi tập tối thiểu | Chọn region → nhóm cơ → bài → log set/rep/kg; lưu Drift; demo 1 buổi hoàn chỉnh | M1 | doing |
| M3 | So sánh buổi gần nhất | Theo bài vs lần gần nhất của chính bài đó, cộng `groupVolume` theo nhóm cơ; trend ±2% (`docs/03`) | M2 | todo |
| M4 | Chart tiến trình | Mapping chart trong `docs/03` mục 6 (1RM+volume bài, set volume nhóm cơ, volume buổi) | M2, M3 | todo |
| M5 | Lịch tuần theo nhóm cơ | Setup lịch tuần; bắt đầu buổi từ lịch hôm nay (ít chạm hơn M2) | M2 | todo |
| M6 | Lịch sử & chỉnh sửa | Xem lại buổi cũ; sửa/xóa set; đảm bảo compare/chart phản ánh đúng | M3, M4 | todo |
| M7 | Khảo sát + lịch gợi ý offline | Khảo sát ngắn lần đầu mở app → lịch tuần gợi ý theo `docs/04` → áp dụng vào lịch M5 | M5 | todo |
| M8 | Gợi ý lịch bằng AI (sau MVP) | AI qua server trung gian, kiểm tra kết quả, dự phòng bằng bộ quy tắc M7 | M7 | todo |

**Thứ tự khuyến nghị:** M1 → M2 → M3 → M4 → M5 → M6 → M7 → M8  
(Core log / so sánh / chart trước lịch tuần để chứng minh progressive overload sớm. Khảo sát cần lịch M5 để áp dụng gợi ý. M8 cần backend nên nằm sau MVP.)

## Quy ước trạng thái

- `todo` — chưa làm
- `doing` — đang active (chỉ một milestone tại một thời điểm)
- `done` — analyze + test xanh, đã / chờ review theo workflow

## V1.1 (sau MVP)

- Log cardio (thời lượng, quãng đường)

## Ngoài phạm vi MVP

Đề xuất tạm (chờ map lại khi `01-business-analysis.md` có nhóm B/C):

**Nhóm B — nên có sau MVP (không block demo core)**

- Thư viện bài tập lớn / video hướng dẫn
- Rest timer nâng cao, supersets / dropsets
- Màn hình / công cụ 1RM chuyên biệt (1RM đã dùng trong so sánh + chart theo `docs/03`; không cần màn riêng ở MVP)
- Export dữ liệu (CSV / JSON)
- Tùy chỉnh brand sâu hơn cặp sáng/tối đã chốt trong `docs/07-ui-system.md`
- Onboarding / empty-state marketing dài

**Nhóm C — ngoài MVP / không làm sớm**

- Sync cloud / multi-device / tài khoản
- Mạng xã hội, chia sẻ buổi tập, leaderboard
- AI coach trong lúc tập / gợi ý tăng tạ / chat với AI (riêng gợi ý **lịch tuần** bằng AI đã chuyển thành M8)
- Dinh dưỡng, theo dõi cân nặng / body composition (trừ khi sau này mở rộng sản phẩm)
- Wearable / HealthKit / Google Fit
- Thanh toán / premium / quảng cáo
- Multi-user trên cùng thiết bị (profile)

## Công thức (đã chốt)

Nguồn sự thật: `docs/03-calculation-rules.md` · pointer agent: `docs/calculations.md` · Cursor rule: `.cursor/rules/calculation-rules.mdc`.

Tóm tắt: load volume = kg×reps (loại warmup / thiếu số); set volume = working sets / 7 ngày; 1RM Epley (reps≤10); so sánh theo bài với lần gần nhất của chính bài đó (volume + max 1RM, trend riêng), thêm `groupVolume` theo nhóm cơ, giữ nguyên nếu \|Δ\|≤2%; chart theo mục 6 của `03`.

## Catalog nhóm cơ (đã chốt)

Chi tiết: `docs/01-business-analysis.md` § Catalog bài tập.

- **Region:** Upper body · Lower body · Other  
- **Muscle group** cố định trong từng region (chest, back/lats, quads, … — đủ list trong `01`)  
- **Exercise** thuộc một muscle group; UI: region → nhóm cơ → bài  
- **Seed** từ ExerciseGymGifsDB `v1.1.0` (`seed/exercises.csv`, offline) + **custom exercise** theo muscle group user chọn. GIF không ship.  
- So sánh / lịch: theo **muscle group**, không theo region  
- Một ngày lịch / một buổi tập có thể gồm **nhiều** muscle group

## Gợi ý lịch (đã chốt)

Câu hỏi khảo sát: `docs/01-business-analysis.md` § Khảo sát người tập · quy tắc: `docs/04-schedule-suggestion-rules.md`.  
MVP dùng bộ quy tắc offline (M7); AI ở M8, luôn dự phòng bằng bộ quy tắc. Giảm mỡ không thêm nhóm cardio; màn lịch tuần hiện một dòng chữ. Dụng cụ lọc danh sách bài, không đổi nhóm cơ của ngày.

## Điểm cần quyết định trước khi bắt đầu

Xem thêm `Rủi ro và câu hỏi còn mở` trong từng milestone. Còn mở:

1. Chốt nội dung nhóm B/C chính thức trong `docs/01-business-analysis.md`.
2. (Đã chốt 2026-11-05) Nguồn seed: ExerciseGymGifsDB `v1.1.0`. GIF / video vẫn nhóm B. Import M2 chờ phân loại trong `seed/exercises.csv`.
3. Bắt đầu buổi: bắt buộc theo lịch (M5) hay cho phép ad-hoc từ M2 (roadmap hiện: ad-hoc từ M2).
4. (Đã chốt 2026-11-05) Ngôn ngữ UI: cả tiếng Anh và tiếng Việt. Máy demo chính: iOS simulator; Android vẫn phải chạy được.
5. M4: ship đủ các loại chart trong mục 6 `03` hay ưu tiên chart tiến bộ bài trước.
6. (Đã chốt 2026-11-04) Buổi tham chiếu theo từng bài + `groupVolume` theo nhóm cơ (`docs/03` mục 5).
7. M7: xác nhận các quy tắc đơn giản trong `docs/04` (giới hạn 60 tuổi, xử lý đau vai / gối).
