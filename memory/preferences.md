# Project Preferences

Style lấy từ `AGENTS.md` và `.cursor/rules/`, không copy máy từ project BLoC khác.

## State và cấu trúc

- State / DI: Riverpod 3 + `riverpod_generator` (`@riverpod`).
- Feature-first: `lib/features/<feature>/{presentation,domain,data}` + `lib/core/`.
- Luồng: presentation → domain ← data. Riverpod = wiring + UI state, không business logic nặng.
- Presentation không import `data/` internals hay Drift generated; chỉ domain entity + repository abstraction (qua provider).
- Model: freezed. Sau đổi annotation: `dart run build_runner build --delete-conflicting-outputs`.
- Package import: `package:kebap/...`.
- File `snake_case`. Identifier tiếng Anh; chat với user bằng tiếng Việt.

## DB và offline

- Drift tables/DAOs trong `core/db/`.
- Repository impl trong `features/.../data/`.
- Test DAO: `NativeDatabase.memory()`.

## Lint và test

- `flutter analyze` · `flutter test`.
- Test trong `test/`, không cạnh `lib/`.
- Domain calculators (1RM, volume, compare) bắt buộc unit test; công thức theo `docs/03-calculation-rules.md` (xem `docs/calculations.md`, `.cursor/rules/calculation-rules.mdc`).
- Đổi công thức: sửa `03` + lịch sử trước, rồi code/test; mâu thuẫn docs↔code → hỏi user.

## UX

- Luồng đang tập: tối thiểu số lần chạm; không thêm bước xác nhận thừa trừ khi docs yêu cầu.

## Git

- Conventional Commits; chỉ commit / push khi user yêu cầu.
