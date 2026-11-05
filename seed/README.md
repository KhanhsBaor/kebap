# Seed bài tập — chờ phân loại

Nguồn: [ExerciseGymGifsDB](https://github.com/JahelCuadrado/ExerciseGymGifsDB) tag `v1.1.0` (1323 bài). Metadata tiếng Anh lấy từ `api/en/exercises.json` ngày 2026-11-05. File làm việc: `exercises.csv`.

Nguồn có tiếng Anh và tiếng Tây Ban Nha, không có tiếng Việt. Cột `nameVi` để trống để điền sau. App dùng cả hai ngôn ngữ (EN / VI).

GIF không được tải về. Tác giả nguồn không giữ bản quyền ảnh và không cấp quyền cho bên thứ ba. Video / GIF thuộc nhóm B, không ship trong MVP.

## Cột cần điền trước khi import ở M2

| Cột | Giá trị hợp lệ |
|---|---|
| `kebapMuscleGroup` | slug trong `docs/01-business-analysis.md`: `abdominals`, `biceps`, `chest`, `forearms`, `lats`, `lower_back`, `neck`, `shoulders`, `traps`, `triceps`, `upper_back`, `abductors`, `adductors`, `calves`, `glutes`, `hamstrings`, `quadriceps`, `cardio`, `full_body`, `others` |
| `kebapEquipment` | `barbell`, `dumbbell`, `machine`, `cable`, `bodyweight`, `other` |
| `nameVi` | tên hiển thị tiếng Việt |

`sourceMuscle` và `sourceEquipment` là nhãn gốc, không dùng trực tiếp trong app. Nhãn gốc không khớp enum Kebap gồm cơ `abs`, `pectorals`, `delts`, `quads`, `spine`, `serratus-anterior`, `levator-scapulae` và dụng cụ `lever`, `band`, `smith`, `kettlebell`, `ez-bar`, `sled`.

M2 chỉ import những dòng đã có đủ `kebapMuscleGroup`, `kebapEquipment` và `nameVi`.
