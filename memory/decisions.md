# Decisions

INDEX — mới nhất ở trên. Khi file vượt ~300 dòng, chuyển entry cũ sang `memory/decisions-archive.md` (không đọc lúc session start).

| Date | Tiêu đề |
|------|---------|
| 2026-11-05 | M2: không thêm bài ngoài buổi; custom gắn nhóm đang xem; trùng tên thì chặn |
| 2026-11-05 | M1: CI GitHub Actions, schema v1, iOS simulator, l10n EN/VI |
| 2026-11-05 | Seed ExerciseGymGifsDB; giao diện tiếng Anh và tiếng Việt |
| 2026-11-04 | Hệ UI: nhật ký thể thao, sáng và tối theo hệ thống |
| 2026-11-04 | M7: cardio chỉ là dòng chữ; khảo sát 2 mức kinh nghiệm; lọc dụng cụ |
| 2026-11-04 | M2 bám docs/05 (nhập set) và docs/06 (vòng đời buổi) |
| 2026-11-04 | Buổi tham chiếu theo từng bài, thêm groupVolume theo nhóm cơ |
| 2026-11-04 | Khảo sát người tập + gợi ý lịch: quy tắc offline (M7), AI sau (M8) |
| 2026-11-04 | Một ngày lịch / một buổi tập có nhiều muscle group |
| 2026-10-26 | Exercise: seed nguồn mở + custom theo muscle group |
| 2026-10-26 | Catalog: region → muscle group → exercise (cố định) |
| 2026-10-23 | Công thức chính thức: docs/03-calculation-rules.md |
| 2026-10-23 | Thứ tự milestone: foundation → log → compare → chart → schedule → history |
| 2026-10-23 | Clean Architecture feature-first + Riverpod (không BLoC) |
| 2026-10-23 | Offline-first Drift; UI không đụng Drift generated |

---

### [2026-11-05] M2: không thêm bài ngoài buổi; custom gắn nhóm đang xem; trùng tên thì chặn

**Context:** M2 còn mở việc thêm bài ngoài nhóm của buổi, chọn nhóm khi tạo custom, trùng tên với bài có sẵn, và sửa/xóa custom. **Decision:** Không cho thêm bài nằm ngoài các nhóm cơ của buổi, để ít chạm. Custom exercise mặc định gắn nhóm đang xem; buổi nhiều nhóm có chip để đổi sang nhóm khác của buổi. Tên trùng y hệt (không phân biệt hoa thường) với một bài trong cùng nhóm thì chặn và gợi ý dùng bài có sẵn. Sửa hoặc xóa custom exercise thuộc M6.

### [2026-11-05] M1: CI GitHub Actions, schema v1, iOS simulator, l10n EN/VI

**Context:** Bắt đầu code M1. Ba câu mở của milestone (CI, schema v1, máy demo) và chỗ gắn set vào buổi chưa có trong `docs/01`. Giao diện EN/VI đã chốt cùng ngày, nhưng M1 chưa có chỗ để chuỗi UI. **Decision:**

- CI chạy GitHub Actions trên repo `KhanhsBaor/kebap`. Một workflow: `flutter pub get` → `dart run build_runner build --delete-conflicting-outputs` → `dart format --set-exit-if-changed` → `flutter analyze` → `flutter test`. Không build iOS/Android, không secret.
- Schema v1 tạo bảng khung, không seed: `regions`, `muscle_groups`, `exercises`, `workouts`, `workout_muscle_groups`, `workout_exercises`, `sets`. Khóa chính `int` autoincrement. Quan hệ buổi là `workouts` → `workout_exercises` → `sets`. `splitDayId` trên `workouts` để nullable và chưa có khóa ngoại vì bảng lịch thuộc M5. Xóa buổi xóa kèm nhóm, bài snapshot và set.
- Máy demo chính là iOS simulator. App vẫn phải chạy được trên Android. Câu máy demo để mở ở entry seed cùng ngày được đóng bởi quyết định này.
- Thêm task l10n vào M1: `gen-l10n`, `app_en.arb` + `app_vi.arb`, cho nhãn và câu trống của 3 tab. Lý do: giao diện đã chốt cả tiếng Anh và tiếng Việt (entry seed cùng ngày); chuỗi UI không hard-code trong widget. Tên region, nhóm cơ và bài là dữ liệu (`nameEn` / `nameVi`), không đưa vào ARB.

### [2026-11-05] Seed ExerciseGymGifsDB; giao diện tiếng Anh và tiếng Việt

**Context:** M2 còn mở nguồn seed và ngôn ngữ UI. **Decision:** Lấy metadata 1323 bài từ [ExerciseGymGifsDB](https://github.com/JahelCuadrado/ExerciseGymGifsDB) tag `v1.1.0` vào `seed/exercises.csv`. Không tải GIF (nguồn không cấp bản quyền ảnh; video thuộc nhóm B). Nguồn chỉ có EN/ES, không có tiếng Việt: `nameEn` đã điền, `nameVi` để trống. Chủ dự án tự điền `kebapMuscleGroup`, `kebapEquipment` và `nameVi` trước khi M2 import. Giao diện app dùng cả tiếng Anh và tiếng Việt. Máy demo (iOS hay Android) vẫn chưa chốt.

### [2026-11-04] Hệ UI: nhật ký thể thao, sáng và tối theo hệ thống

**Context:** Cần style trước khi code M1. Catalog gym nghiêng khối màu và nền OLED. Checklist M1 từng ghi theme sáng. ROADMAP từng để dark mode ở nhóm B. **Decision:** Style và token ở `docs/07-ui-system.md`. Bản đồ màn S01–S13 ở `docs/design/screens.md`. Cam `#F97316` chỉ cho nút chính và đường 1RM. Trend tăng / giữ nguyên / giảm có chữ, ngưỡng ±2% vẫn theo `docs/03`. Cả hai theme, mặc định theo hệ thống, gắn khi code M1. Tab dưới: Hôm nay, Tiến trình, Lịch sử. Màn đang tập full-screen. Cân bằng nhóm cơ vẽ cột, không radar. Dark mode không còn là hạng mục sau MVP. Tùy chỉnh brand sâu hơn cặp token này vẫn ngoài MVP.

### [2026-11-04] M7: cardio chỉ là dòng chữ; khảo sát 2 mức kinh nghiệm; lọc dụng cụ

**Context:** Review docs chỉ ra cardio không log được, nhiều câu khảo sát không đổi kết quả, và câu dụng cụ không có task lọc. **Decision:** Giảm mỡ không thêm slug `cardio` vào lịch; màn lịch tuần hiện một dòng chữ. Log cardio (thời lượng, quãng đường) để V1.1. Mục tiêu quyết định số set, khoảng rep và nghỉ mặc định (bảng trong `docs/01`). Kinh nghiệm còn Mới bắt đầu / Đã tập. Cân nặng tùy chọn, chỉ lưu. Seed M2 điền enum dụng cụ (không null); M7 lọc bài theo bảng trong `docs/04`, có nút "Hiện cả bài cần dụng cụ khác". Dụng cụ không đổi nhóm cơ của ngày.

### [2026-11-04] M2 bám docs/05 (nhập set) và docs/06 (vòng đời buổi)

**Context:** M2 chưa có ngân sách chạm và vòng đời buổi dở. **Decision:** `docs/05` và `docs/06` đã chốt làm nguồn cho M2 (câu hỏi mở ở cuối hai file vẫn giữ). Một buổi `in_progress`, "Lưu set" ghi ngay, hủy/kết thúc theo `docs/06`, cột "Lần trước" theo `docs/03` mục 5 nhưng chưa hiện trend ±2%. Đồng hồ nghỉ cơ bản (±15 giây) thuộc M2. Phần lịch tuần trong `docs/06` mục 2 có hiệu lực từ M5.

### [2026-11-04] Buổi tham chiếu theo từng bài, thêm groupVolume theo nhóm cơ

**Context:** Buổi nhiều nhóm cơ đang chặn M3. **Decision:** Với mỗi bài, buổi tham chiếu là buổi `completed` gần nhất có đúng `exerciseId`, `endedAt` trước `startedAt` của buổi hiện tại. Buổi `in_progress` không phải tham chiếu. Hai buổi `completed` cùng ngày lịch vẫn so được. Thêm `groupVolume` (bỏ set kg = 0) và một trend theo nhóm cơ trên màn tóm tắt, không thay so sánh theo bài và không thêm chart mới. Chi tiết: `docs/03` mục 5–6.

### [2026-11-04] Khảo sát người tập + gợi ý lịch: quy tắc offline (M7), AI sau (M8)

**Context:** User muốn khảo sát người tập trước khi vào app để gợi ý lịch bằng AI; nhưng AI đang ở nhóm C, dự án không có backend, và không được nhúng API key vào app. **Decision:** Khảo sát 5 câu bắt buộc (mục tiêu, kinh nghiệm, số buổi/tuần, thời lượng, dụng cụ) + câu tùy chọn (nhóm ưu tiên, chỗ đau, cân nặng, năm sinh); không hỏi chiều cao; luôn bỏ qua được. M7: `RuleBasedScheduleSuggester` offline theo `docs/04-schedule-suggestion-rules.md`, áp dụng vào lịch M5. M8 (sau MVP): AI qua server trung gian giữ key, kết quả phải qua bước kiểm tra `docs/04` mục 5, lỗi thì dùng bộ quy tắc. Gợi ý lịch bằng AI rời nhóm C; AI coach trong lúc tập vẫn ở nhóm C.

---

### [2026-11-04] Một ngày lịch / một buổi tập có nhiều muscle group

**Context:** Lịch gợi ý cần ngày kiểu Push = Chest + Shoulders + Triceps. **Decision:** Lịch tuần lưu nhiều muscle group / ngày (có thứ tự); buổi tập gắn nhiều muscle group qua bảng nối `workout_muscle_groups`; exercise vẫn thuộc đúng một muscle group. **Còn chặn M3:** định nghĩa buổi tham chiếu khi buổi có nhiều nhóm phải chốt trong `docs/03` mục 5 (đề xuất: theo từng bài, lấy buổi gần nhất có cùng bài).

---

### [2026-10-26] Exercise: seed nguồn mở + custom theo muscle group

**Context:** Cần thư viện bài đủ dùng ngay + linh hoạt khi thiếu bài. **Decision:** (1) **Seed** exercises từ nguồn mở, map vào muscle groups cố định, ship offline trong Drift. (2) User **tạo custom exercise** với tên tự đặt, bắt buộc gắn `muscleGroupId` đang chọn (không tạo region/group mới). Field `isCustom` (và có thể `sourceId` cho bài seed). Có từ **M2**. Nguồn/số lượng seed cụ thể chốt lúc implement.

---

### [2026-10-26] Catalog: region → muscle group → exercise (cố định)

**Context:** Cần taxonomy bài tập kiểu Hevy (nhóm cơ giải phẫu), không dùng PPL làm cây chính. **Decision:** Ba **region** cố định — Upper body, Lower body, Other. Trong mỗi region là **muscle groups** cố định (Upper: Abdominals, Biceps, Chest, Forearms, Lats, Lower back, Neck, Shoulders, Traps, Triceps, Upper back; Lower: Abductors, Adductors, Calves, Glutes, Hamstrings, Quadriceps; Other: Cardio, Full body, Others). Exercise thuộc một muscle group. UI chọn: region → group → exercises. So sánh / lịch / set-volume theo **muscle group**, không theo region. Chi tiết slug: `docs/01-business-analysis.md`.

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
