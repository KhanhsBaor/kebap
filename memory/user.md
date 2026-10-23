# User & Project Context

## Project

**App:** Kebap  
**Package Dart:** `kebap` · `publish_to: none`  
**Version (pubspec):** `1.0.0+1`  
**SDK:** Dart `^3.12.2`, Flutter 3.x  

App offline-first nhật ký tập gym: lịch tuần theo nhóm cơ, log set/rep/kg, so sánh buổi gần nhất cùng nhóm cơ (progressive overload), chart tiến trình.

## Phase hiện tại

- Scaffold Flutter; stack mục tiêu chưa gắn hết vào `pubspec.yaml`.
- Kiến trúc / agent rules đã chốt (`AGENTS.md`, `.cursor/rules/`).
- **Roadmap milestone đã soạn** (`docs/ROADMAP.md`, `docs/milestones/M0`–`M6`) — chờ review; **chưa bắt đầu code M1**.
- **Công thức đã chốt:** `docs/03-calculation-rules.md` (+ `docs/calculations.md`, `.cursor/rules/calculation-rules.mdc`).
- `docs/01-business-analysis.md` vẫn skeleton (chưa có nhóm B/C chính thức).

## Ưu tiên sản phẩm

1. So sánh buổi tập (core value)
2. Log đang tập nhanh (ít chạm)
3. Chart tiến trình
4. Lịch tuần / nhóm cơ (sau core trong roadmap: M5)

## Backend

Không có API server ở MVP — nguồn sự thật là SQLite qua Drift trên thiết bị.
