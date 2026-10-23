# Decisions

INDEX — mới nhất ở trên. Khi file vượt ~300 dòng, chuyển entry cũ sang `memory/decisions-archive.md` (không đọc lúc session start).

| Date | Tiêu đề |
|------|---------|
| 2026-10-23 | Công thức chính thức: docs/03-calculation-rules.md |
| 2026-10-23 | Thứ tự milestone: foundation → log → compare → chart → schedule → history |
| 2026-10-23 | Clean Architecture feature-first + Riverpod (không BLoC) |
| 2026-10-23 | Offline-first Drift; UI không đụng Drift generated |

---

### [2026-10-23] Công thức chính thức: docs/03-calculation-rules.md

**Context:** Cần một nguồn sự thật cho volume, set volume, 1RM Epley, so sánh buổi, mapping chart; tránh agent/code tự bịa. **Decision:** `docs/03-calculation-rules.md` là nguồn duy nhất; `docs/calculations.md` + `.cursor/rules/calculation-rules.mdc` bắt agent cập nhật `03` trước khi đổi code; mâu thuẫn docs↔code thì hỏi user. Milestone M2–M4 bám file này (warmup loại, so sánh theo bài ±2%, chart mục 6).

---

### [2026-10-23] Thứ tự milestone: foundation → log → compare → chart → schedule → history

**Context:** Cần chia MVP thành lát cắt demo được; core value (so sánh) và log/chart phải sớm; lịch tuần nằm trong luồng chính nhưng không chặn chứng minh progressive overload. **Decision:** M1 khung dự án → M2 log buổi → M3 so sánh → M4 chart → M5 lịch tuần → M6 lịch sử/sửa. Ngoài phạm vi MVP trên ROADMAP là đề xuất tạm vì `01-business-analysis.md` chưa có nhóm B/C — chờ user chốt.

---

### [2026-10-23] Clean Architecture feature-first + Riverpod (không BLoC)

**Context:** Cần chuẩn kiến trúc cho Kebap; tham chiếu bài Clean Architecture + Riverpod và skill layered Flutter, format agents từ fnb-mobile (BLoC). **Decision:** Dùng **feature-first** `lib/features/<feature>/{presentation,domain,data}` + `core/`; state/DI bằng **Riverpod 3 + riverpod_generator**, không BLoC/GetIt. Domain giữ entity + repository contract + use case khi logic phức tạp; CRUD mỏng có thể gọi repository từ presentation qua provider. Dependency: presentation → domain ← data. Domain không import Flutter/Riverpod/Drift.

---

### [2026-10-23] Offline-first Drift; UI không đụng Drift generated

**Context:** MVP không sync server; cần reactive UI từ DB local. **Decision:** Drift (SQLite) là source of truth. UI đọc qua StreamProvider trên `repository.watch*()`; ghi qua repository → DAO. Presentation không import class generated của Drift. Đổi schema phải có migration + test migration. Truy vấn “buổi gần nhất cùng nhóm cơ” nằm trong DAO.
