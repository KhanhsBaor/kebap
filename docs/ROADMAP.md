# Kebap Roadmap

Roadmap milestone theo **lát cắt chạy được / demo được** (không chia theo lớp kỹ thuật).  
Chi tiết từng milestone: `docs/milestones/`.

> **Lưu ý nguồn:** `docs/01-business-analysis.md` hiện là skeleton — **chưa có nhóm B/C**.  
> Phần [Ngoài phạm vi MVP](#ngoài-phạm-vi-mvp) bên dưới là **đề xuất tạm** từ ràng buộc MVP (offline-first, 5 bước luồng chính) + tính năng gym-app thường gặp ngoài 5 bước đó. Cần bạn chốt trước khi code M1+.

## Bảng milestone

| ID | Tên | Mục tiêu | Phụ thuộc | Trạng thái |
|----|-----|----------|-----------|------------|
| M0 | Agent docs + kiến trúc | Rules, `AGENTS.md`, Clean Architecture + Riverpod/Drift đã chốt trên giấy | — | done |
| M1 | Khung dự án | App chạy được: thư mục feature-first, Drift shell, go_router, theme, Riverpod root, CI analyze/test | M0 | todo |
| M2 | Log buổi tập tối thiểu | Chọn nhóm cơ → thêm bài → log set/rep/kg → kết thúc buổi; lưu Drift; demo 1 buổi hoàn chỉnh | M1 | todo |
| M3 | So sánh buổi gần nhất | Theo bài vs buổi gần nhất cùng nhóm cơ: load volume + max 1RM; trend ±2% (`docs/03`) | M2 | todo |
| M4 | Chart tiến trình | Mapping chart trong `docs/03` mục 6 (1RM+volume bài, set volume nhóm cơ, volume buổi) | M2, M3 | todo |
| M5 | Lịch tuần theo nhóm cơ | Setup lịch tuần; bắt đầu buổi từ lịch hôm nay (ít chạm hơn M2) | M2 | todo |
| M6 | Lịch sử & chỉnh sửa | Xem lại buổi cũ; sửa/xóa set; đảm bảo compare/chart phản ánh đúng | M3, M4 | todo |

**Thứ tự khuyến nghị:** M1 → M2 → M3 → M4 → M5 → M6  
(Core log / so sánh / chart trước lịch tuần để chứng minh progressive overload sớm.)

## Quy ước trạng thái

- `todo` — chưa làm
- `doing` — đang active (chỉ một milestone tại một thời điểm)
- `done` — analyze + test xanh, đã / chờ review theo workflow

## Ngoài phạm vi MVP

Đề xuất tạm (chờ map lại khi `01-business-analysis.md` có nhóm B/C):

**Nhóm B — nên có sau MVP (không block demo core)**

- Thư viện bài tập lớn / video hướng dẫn
- Rest timer nâng cao, supersets / dropsets
- Màn hình / công cụ 1RM chuyên biệt (1RM đã dùng trong so sánh + chart theo `docs/03`; không cần màn riêng ở MVP)
- Export dữ liệu (CSV / JSON)
- Dark mode / theme tùy chỉnh sâu
- Onboarding / empty-state marketing dài

**Nhóm C — ngoài MVP / không làm sớm**

- Sync cloud / multi-device / tài khoản
- Mạng xã hội, chia sẻ buổi tập, leaderboard
- AI coach / gợi ý bài tập thông minh
- Dinh dưỡng, theo dõi cân nặng / body composition (trừ khi sau này mở rộng sản phẩm)
- Wearable / HealthKit / Google Fit
- Thanh toán / premium / quảng cáo
- Multi-user trên cùng thiết bị (profile)

## Công thức (đã chốt)

Nguồn sự thật: `docs/03-calculation-rules.md` · pointer agent: `docs/calculations.md` · Cursor rule: `.cursor/rules/calculation-rules.mdc`.

Tóm tắt: load volume = kg×reps (loại warmup / thiếu số); set volume = working sets / 7 ngày; 1RM Epley (reps≤10); so sánh theo bài (volume + max 1RM), giữ nguyên nếu \|Δ\|≤2%; chart theo mục 6 của `03`.

## Điểm cần quyết định trước khi bắt đầu

Xem thêm `Rủi ro và câu hỏi còn mở` trong từng milestone. Còn mở:

1. Chốt nội dung nhóm B/C chính thức trong `docs/01-business-analysis.md`.
2. Danh sách nhóm cơ cố định vs tùy chỉnh; seed bài tập ban đầu thế nào.
3. Bắt đầu buổi: bắt buộc theo lịch (M5) hay cho phép ad-hoc từ M2 (roadmap hiện: ad-hoc từ M2).
4. Ngôn ngữ UI (VI / EN / cả hai) và platform ưu tiên demo (iOS / Android / cả hai).
5. M4: ship đủ các loại chart trong mục 6 `03` hay ưu tiên chart tiến bộ bài trước.
