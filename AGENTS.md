# Project: Kebap — Nhật ký tập luyện

App offline-first cho người tập gym: setup lịch tập tuần theo nhóm cơ, log set/rep/kg khi đang tập,
so sánh từng bài hôm nay với lần gần nhất của chính bài đó, xem chart tiến trình.

**Core value:** so sánh buổi tập để thấy progressive overload. Mọi quyết định ưu tiên core này.

## Stack

- Language: Dart 3.x
- Framework: Flutter
- Architecture: Clean Architecture (feature-first) + Riverpod
- State / DI: Riverpod 3 (`flutter_riverpod`, `riverpod_generator`)
- Local DB: Drift (SQLite), offline-first
- Navigation: go_router
- Models: freezed (+ build_runner)
- Charts: fl_chart
- Testing: flutter_test, mocktail, Drift in-memory DB

## Project Structure

```text
lib/
  main.dart                    ← App entry
  core/                        ← db (Drift), router, theme, utils
  features/<feature>/
    presentation/              ← screens, widgets, @riverpod providers
    domain/                    ← entities, repository contracts, use cases
    data/                      ← repository impl, Drift mappers

test/                          ← unit / widget / migration tests
docs/                          ← nghiệp vụ, tech stack, roadmap, milestones
android/, ios/                 ← platform
```

Luồng phụ thuộc: **presentation → domain ← data**. Domain không import Flutter / Riverpod / Drift.

## Tài liệu (đọc theo nhu cầu, KHÔNG nạp hết một lần)

- Nghiệp vụ, luồng, data model: `docs/01-business-analysis.md`
- Tech stack, package: `docs/02-tech-stack.md`
- **Công thức (nguồn sự thật):** `docs/03-calculation-rules.md` · pointer: `docs/calculations.md`
- **Quy tắc gợi ý lịch từ khảo sát (nguồn sự thật):** `docs/04-schedule-suggestion-rules.md`
- **Hệ UI (nguồn sự thật giao diện):** `docs/07-ui-system.md` · bản đồ màn: `docs/design/screens.md`
- Roadmap & trạng thái milestone: `docs/ROADMAP.md`
- Chi tiết từng milestone: `docs/milestones/Mx-*.md`

## Workflow: Milestone → Implement → Verify → Review

### Standard workflow cho mọi thay đổi trong milestone

1. **Plan** → đọc `docs/ROADMAP.md` + file milestone đang active; xác định phạm vi
2. **Implement** → chỉ trong milestone hiện tại; tick checklist khi xong từng task
3. **Verify** → `flutter analyze` + `flutter test` (+ `build_runner` nếu đổi annotation/schema)
4. **Review** → dừng chờ người dùng review; cập nhật trạng thái trong `docs/ROADMAP.md`
5. Nếu yêu cầu mơ hồ hoặc mâu thuẫn với docs → hỏi lại, không tự đoán

### Quy trình milestone (chi tiết)

Xem `.cursor/rules/milestone-workflow.mdc`.

## Lệnh thường dùng

```bash
dart run build_runner build --delete-conflicting-outputs   # freezed / riverpod / drift
flutter analyze
flutter test
flutter test test/path/to_file_test.dart
```

## Agent Delegation Rules

Orchestrate / tách task khi:

- Task có 3+ independent subtasks
- Cần song song UI + domain logic + Drift schema
- Code review trước khi merge / đóng milestone

Không cần delegate khi:

- Bug fix đơn giản < 50 lines
- Documentation / checklist update
- Config / formatting nhỏ

## Code Standards (enforced by `.cursor/rules/`)

- Clean Architecture: dependency inward; Riverpod không chứa business logic nặng
- UI không import Drift generated; đi qua repository + domain entity
- Model bất biến: freezed. Không `setState` cho state nghiệp vụ
- Logic tính toán (1RM, volume, so sánh buổi) thuần Dart trong domain + unit test; **bám `docs/03-calculation-rules.md`**
- Đổi công thức: sửa `docs/03-calculation-rules.md` (+ lịch sử) trước, rồi code/test; mâu thuẫn docs↔code → hỏi user
- Đổi schema Drift: migration + test migration bắt buộc
- Luồng "đang tập": ít chạm nhất có thể
- Code/identifier tiếng Anh; giải thích với người dùng bằng tiếng Việt
- Atomic commits; Conventional Commits

Rules chính:

| Rule | Khi nào |
|------|---------|
| `flutter-clean-architecture-core.mdc` | luôn |
| `flutter-clean-architecture-lib.mdc` | sửa `lib/**` |
| `calculation-rules.mdc` | domain calculations / test volume·1RM·compare / sửa `docs/03*` |
| `riverpod-presentation.mdc` | `features/**/presentation/**` |
| `drift-data-layer.mdc` | `core/db/**`, `features/**/data/**` |
| `milestone-workflow.mdc` | làm / tiếp tục milestone |
| `theme-ui-tokens.mdc` | `core/theme/**`, `features/**/presentation/**` |
| `router-navigation.mdc` | `core/router/**`, `main.dart`, `app.dart` |
| `testing.mdc` | `test/**` |
| `ci-github-actions.mdc` | `.github/workflows/**` |
| `l10n.mdc` | `lib/l10n/**`, `l10n.yaml`, chuỗi trên UI |

## Context Management

- Ưu tiên đọc milestone + file đang sửa; không nạp cả `docs/` một lần
- `/compact` khi context > 70%
- `/clear` khi context > 90%, sau đó reload `AGENTS.md` + `memory/`
- Dùng checkpoint / ghi `memory/decisions.md` trước khi clear nếu vừa chốt hướng lớn

---

## Agent Roster & Triggers

| Agent / focus            | Trigger Phrases                                      | Tools                          |
| ------------------------ | ---------------------------------------------------- | ------------------------------ |
| `planner`                | "implement", "add feature", "milestone", "build"     | Read, Grep, Glob               |
| `architect`              | "design", "architecture", "layer", "ADR"             | Read, Grep, Glob               |
| `tdd-guide`              | "tdd", "test first", "unit test", "migration test"   | Read, Write, Shell             |
| `code-reviewer`          | "review", "check quality", "before merge"            | Read, Grep, Glob               |
| `build-error-resolver`   | "analyze error", "build error", "compile error"      | Read, Write, Shell             |
| `drift-reviewer`         | "schema", "migration", "DAO", "query review"         | Read, Grep, Glob               |
| `mobile-developer`       | "mobile", "iOS", "Android", "performance", "pin", "cold start", "accessibility", "haptic", "danh sách dài" | Read, Write, Shell, Glob, Grep |

Playbook gốc: `.claude/agents/mobile-developer.md`. File đó viết cho app đa nền tảng nói chung (có React Native). **Khi làm Kebap, mục dưới thắng playbook.**

### `mobile-developer`

Gọi khi việc đụng trải nghiệm trên máy: UI theo nền tảng, hiệu năng (khởi động, bộ nhớ, pin, list), accessibility, haptic, layout thích ứng, hoặc chuẩn bị store. Việc domain (1RM, so sánh buổi), schema Drift, hay CRUD mỏng đi roster tương ứng — không giao cho agent này.

Ràng buộc Kebap:

- Flutter + Dart 3, Riverpod, Drift, go_router. Không React Native, WatermelonDB, Redux, GetIt, Hermes, TurboModules.
- Offline trên thiết bị. MVP không có sync server, hàng đợi, hay conflict resolution.
- Giao diện theo `docs/07-ui-system.md` (sáng/tối theo hệ thống). Không tự áp Material 3 / HIG đè token đã chốt.
- Test: `flutter_test`, mocktail, Drift in-memory. E2E khi cần: Maestro. Không Jest, Detox, Flipper.
- List dài dùng lazy build (`ListView.builder` / tương đương). Luồng đang tập giữ ít chạm.
- Push, deep link, biometric, HealthKit, camera, BLE, widget, watch nằm ngoài milestone hiện tại trừ khi file milestone nói rõ.

Checklist áp dụng ngay khi sửa UI:

- Một codebase Flutter cho iOS và Android; khác biệt nền tảng chỉ khi `docs/07` hoặc milestone yêu cầu.
- Widget mới chịu text scale, VoiceOver / TalkBack, và cả hai theme.
- Chạm phản hồi trong một frame; không dựng hết item của list dài.
- Xong việc: `flutter analyze` + `flutter test`.

Checklist để sau (không làm trong milestone đang active): cold start dưới 1.5s, bộ nhớ nền dưới 120MB, pin dưới 4%/giờ, app dưới 40MB, crash dưới 0.1%, FCM/APNs, Universal Links, CI store, certificate pinning.

---

## Commit Format

```
feat(scope): description
fix(scope): description
refactor(scope): description
test(scope): description
docs(scope): description
chore(scope): description
```

Types: feat | fix | refactor | docs | test | chore | perf | ci

Scope gợi ý: `workout`, `schedule`, `compare`, `chart`, `db`, `core`, …

## Git Workflow

Sau mỗi task hoàn thành (khi người dùng yêu cầu commit):

1. Suggest branch: `<type>/<short-description>` (kebab-case, ≤ 50 ký tự)
2. Stage đúng file liên quan
3. Commit message Conventional Commits (imperative, dòng đầu ≤ 72 ký tự)
4. Push chỉ khi được yêu cầu rõ: `-u origin <branch>`

Branch naming:

- `feat/` → tính năng mới
- `fix/` → bug fix
- `refactor/` → refactor
- `docs/` → tài liệu / agents / rules

Commit rules:

- Imperative mood
- Body giải thích WHY nếu change phức tạp
- Không commit secrets / `.env`

---

# Session Protocol

## Session Start

Đọc theo thứ tự:

1. `memory/user.md`
2. `memory/decisions.md`
3. `memory/people.md`
4. `memory/preferences.md`

Sau khi đọc, tóm tắt một câu: "Đây là project Kebap, đang ở phase [phase], ưu tiên hiện tại là [...]".

Không đọc `memory/decisions-archive.md` trừ khi cần tra cứu quyết định cũ.

Nếu đang làm milestone: đọc thêm `docs/ROADMAP.md` và file milestone active.

## Session End

Trước khi đóng session:

1. Update `memory/decisions.md` nếu có quyết định mới (mới nhất ở trên; file vượt ~300 dòng thì chuyển entry cũ sang `memory/decisions-archive.md`).
2. Update `memory/user.md` nếu context project đổi.
3. Update `memory/preferences.md` nếu có pattern mới.
4. Kiểm tra `git status` — không để thay đổi dở dang (hoặc nêu rõ đang WIP).

## Decision making

- Tham chiếu `memory/decisions.md` trước khi đề xuất hướng mới.
- Nếu hướng mới mâu thuẫn quyết định cũ hoặc `docs/`, hỏi xác nhận trước khi làm.
