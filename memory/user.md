# User & Project Context

## Project

**App:** Kebap  
**Package Dart:** `kebap` · `publish_to: none`  
**Version (pubspec):** `1.0.0+1`  
**SDK:** Dart `^3.12.2`, Flutter 3.x  

App offline-first nhật ký tập gym: lịch tuần theo nhóm cơ, log set/rep/kg, so sánh từng bài với lần gần nhất của bài đó (progressive overload), chart tiến trình.

## Phase hiện tại

- Scaffold Flutter; stack mục tiêu chưa gắn hết vào `pubspec.yaml`.
- Kiến trúc / agent rules đã chốt (`AGENTS.md`, `.cursor/rules/`).
- **Roadmap milestone đã soạn** (`docs/ROADMAP.md`, `docs/milestones/M0`–`M6`) — chờ review; **chưa bắt đầu code M1**.
- **Công thức đã chốt:** `docs/03-calculation-rules.md` (+ `docs/calculations.md`, `.cursor/rules/calculation-rules.mdc`).
- **Catalog đã chốt:** region (Upper/Lower/Other) → muscle group cố định → exercise; **seed nguồn mở + custom** theo nhóm đang chọn (`docs/01-business-analysis.md`).
- **Khảo sát + gợi ý lịch đã chốt:** M7 (quy tắc offline, `docs/04-schedule-suggestion-rules.md`), M8 (AI, sau MVP). Một ngày / một buổi có nhiều muscle group.
- `docs/01-business-analysis.md` vẫn thiếu nhóm B/C chính thức (ngoài catalog).

## Ưu tiên sản phẩm

1. So sánh buổi tập (core value)
2. Log đang tập nhanh (ít chạm)
3. Chart tiến trình
4. Lịch tuần / nhóm cơ (sau core trong roadmap: M5)

## Backend

Không có API server ở MVP — nguồn sự thật là SQLite qua Drift trên thiết bị.
