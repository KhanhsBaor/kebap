---
name: kebap-drift-setup
description: Dựng và mở rộng Drift database của Kebap — AppDatabase, mở DB trên máy, provider, schema version, migration và test migration. Dùng khi tạo DB (M1), thêm/sửa table hoặc DAO, tăng schemaVersion.
---

# Drift cho Kebap

Bám `.cursor/rules/drift-data-layer.mdc` và `docs/01-business-analysis.md` (data model). Chỗ model chưa chốt → hỏi user.

## Cấu trúc

```text
lib/core/db/
  app_database.dart        ← @DriftDatabase(tables: [...], daos: [...])
  connection.dart          ← mở DB file trên máy
  tables/<name>_table.dart
  daos/<name>_dao.dart
  app_database_provider.dart
drift_schemas/             ← schema dump JSON theo version (commit vào git)
test/core/db/
```

## Các bước

1. Packages theo `docs/02`: `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`; dev: `drift_dev`, `build_runner`.
2. `AppDatabase extends _$AppDatabase` nhận `QueryExecutor` qua constructor để test truyền `NativeDatabase.memory()`.
3. Mở DB thật: `LazyDatabase` + `getApplicationDocumentsDirectory()` + `NativeDatabase.createInBackground(File(p.join(dir.path, 'kebap.sqlite')))`.
4. `schemaVersion` bắt đầu từ 1. `MigrationStrategy`: `onCreate: (m) => m.createAll()`, `onUpgrade` dùng step-by-step migration; `beforeOpen` bật `PRAGMA foreign_keys = ON`.
5. Provider: `@Riverpod(keepAlive: true) AppDatabase appDatabase(Ref ref)`; `ref.onDispose(db.close)`. Test override provider này bằng DB memory.
6. Cấu hình `build.yaml` cho drift_dev (`databases: kebap: lib/core/db/app_database.dart`, `schema_dir: drift_schemas/`, `test_dir: test/drift/`) rồi chạy `dart run drift_dev make-migrations` mỗi khi đổi schema để sinh schema dump, step-by-step migration và test migration.
7. `dart run build_runner build --delete-conflicting-outputs`.

## Quy tắc

- Tên table/column tiếng Anh, snake_case trong SQL (Drift tự map từ camelCase).
- Khóa ngoại có `references(...)`; quan hệ nhiều-nhiều qua bảng nối (vd. `workout_muscle_groups`).
- Thời gian lưu UTC (`DateTime` của Drift); hiển thị mới đổi sang giờ máy.
- Không đổi schema mà không tăng `schemaVersion` + migration + test migration.
- Presentation không bao giờ import file này hay class generated.

## Kiểm tra

- Test mở DB memory, insert/select tối thiểu, đóng DB.
- Test migration từ mọi version cũ lên version hiện tại (file sinh bởi `make-migrations`).
- `flutter analyze` + `flutter test` xanh.
