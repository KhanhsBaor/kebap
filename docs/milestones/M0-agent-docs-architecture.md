# M0 — Agent docs + kiến trúc

**Trạng thái:** done  
**Phụ thuộc:** —

## Mục tiêu và giá trị

Chốt cách làm việc và kiến trúc trước khi viết app: Clean Architecture feature-first, Riverpod, Drift offline-first, quy trình milestone.  
**Giá trị:** giảm quyết định ad-hoc khi code; agent và người cùng đọc một nguồn (`AGENTS.md`, `.cursor/rules/`, `memory/`).

## Trong phạm vi

- [x] `AGENTS.md` + session protocol
- [x] Rules: clean architecture, Riverpod, Drift, milestone workflow
- [x] `memory/` (user, decisions, preferences)
- [x] Skeleton `docs/01-business-analysis.md`, `docs/02-tech-stack.md`

## Ngoài phạm vi

- Code app / `pubspec` đầy đủ stack
- Schema Drift production
- UI màn hình nghiệp vụ

## Checklist task

Đã hoàn thành trước roadmap này — không còn task mở.

## Drift / provider / màn hình

| Loại | Nội dung |
|------|----------|
| Drift | chưa |
| Provider | chưa |
| Màn hình | scaffold Flutter mặc định (chưa theo feature) |

## Definition of Done

- [x] Docs/rules đủ để bắt M1 mà không đoán kiến trúc
- [x] Quyết định Riverpod (không BLoC) và Drift offline ghi trong `memory/decisions.md`

## Rủi ro và câu hỏi còn mở

- `01-business-analysis.md` còn skeleton → roadmap M1+ dựa trên giả định tạm (xem ROADMAP).
