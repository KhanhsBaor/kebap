# M7 — Khảo sát người tập + lịch gợi ý offline

**Trạng thái:** todo  
**Phụ thuộc:** M5 (cần lịch tuần nhiều nhóm cơ / ngày để áp dụng gợi ý)  
**Demo cuối milestone:** Cài app mới → khảo sát 5 câu (+ câu tùy chọn) → xem trước lịch gợi ý → "Áp dụng" → Home hiện "Hôm nay: Chest, Shoulders, Triceps" → bắt đầu buổi như M5. Bỏ qua khảo sát thì app vẫn vào Home như cũ.

**Nguồn sự thật:** câu hỏi ở `docs/01-business-analysis.md` § Khảo sát người tập · quy tắc ở `docs/04-schedule-suggestion-rules.md`.

## Mục tiêu và giá trị

Người mới không phải tự nghĩ lịch tập: trả lời vài câu là có lịch tuần hợp lý, sửa lại được.  
**Giá trị:** giảm ma sát lần đầu dùng app; đổ dữ liệu vào lịch M5 để luồng "Hôm nay tập gì" có ngay từ ngày đầu.

## Trong phạm vi

- Hồ sơ người tập lưu local (một dòng duy nhất), sửa được trong Cài đặt
- Luồng khảo sát ở lần mở đầu tiên: mỗi màn một câu, có Bỏ qua, có Quay lại (ý nghĩa Bỏ qua: `docs/01` § Khảo sát người tập)
- `RuleBasedScheduleSuggester` thuần Dart theo `docs/04`
- Màn xem trước lịch gợi ý → Áp dụng (ghi đè lịch M5, xác nhận nếu lịch đang có dữ liệu); hiện một dòng giải thích cho mỗi điều chỉnh của bộ quy tắc (vd. giới hạn về 4 buổi, bỏ shoulders vì đau vai)
- Cờ cảnh báo "đau gối" hiển thị trên ngày có quadriceps
- Mục tiêu Giảm mỡ: một dòng chữ gợi ý cardio trên màn lịch tuần, không thêm nhóm `cardio` vào lịch
- Mặc định set / rep / nghỉ theo bảng mục tiêu ở `docs/01` (M2 đọc khi prefill)
- Lọc danh sách bài theo bảng dụng cụ ở `docs/04`: khi thêm bài vào buổi và ở màn thư viện, kèm nút "Hiện cả bài cần dụng cụ khác". Bài custom luôn hiện

## Ngoài phạm vi

- Gợi ý bằng AI (M8)
- Gợi ý bài tập cụ thể (số set / khoảng rep / nghỉ mặc định thì thuộc phạm vi, theo `docs/01`)
- Theo dõi cân nặng theo thời gian (nhóm C); cân nặng chỉ lưu
- Log cardio thời lượng / quãng đường (V1.1)
- Onboarding marketing / giới thiệu tính năng (nhóm B)

## Checklist task (1 chat / task)

- [ ] Drift: bảng `user_profiles` (một dòng) + migration + test migration
- [ ] Domain: entity `UserProfile` + enum (goal, experience gồm Mới bắt đầu / Đã tập, equipment, limitation) freezed; `UserProfileRepository` contract
- [ ] Data: repository impl + mapper; test DAO memory
- [ ] Domain: `ScheduleSuggester` contract + `RuleBasedScheduleSuggester` + bước kiểm tra mục 5 `docs/04`
- [ ] Unit test: đủ các ví dụ mục 6 `docs/04` + giới hạn 4 buổi + Khỏe tổng quát ≤ 3 buổi + kiểm tra kết quả sai
- [ ] Router: lần đầu chưa có hồ sơ và chưa từng bỏ qua → chuyển sang khảo sát (`go_router` redirect)
- [ ] UI: `OnboardingSurveyScreen` (một câu / màn, Bỏ qua, Quay lại)
- [ ] UI: `SuggestedScheduleScreen` — xem trước, Áp dụng → ghi vào lịch M5; mục tiêu Giảm mỡ hiện dòng chữ cardio (không phải nhóm cơ)
- [ ] Lọc bài theo `docs/04` ở danh sách thêm bài và màn thư viện + nút "Hiện cả bài cần dụng cụ khác"; test map gym / tạ đơn / không dụng cụ và custom luôn hiện
- [ ] UI: sửa hồ sơ trong Cài đặt + nút "Tạo lại lịch gợi ý"; câu cân nặng và năm sinh bỏ qua được từng câu
- [ ] Demo: cài mới → khảo sát → áp dụng → Home đúng lịch; cài mới → bỏ qua → Home bình thường

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | `UserProfiles` (goal, experience, sessionsPerWeek, sessionMinutes, equipment, priorityGroups, limitations, weightKg?, birthYear?, onboardingSkipped, updatedAt) |
| Providers | `userProfileRepositoryProvider`, `userProfileProvider` (stream), `scheduleSuggesterProvider`, `suggestedScheduleProvider` |
| Màn hình | `OnboardingSurveyScreen`, `SuggestedScheduleScreen`, mục hồ sơ trong `SettingsScreen` |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh; migration test cho `user_profiles`
- [ ] Unit test khớp toàn bộ ví dụ trong `docs/04` mục 6
- [ ] Bỏ qua khảo sát không làm hỏng luồng M2–M5; không hỏi lại ở lần mở sau
- [ ] Áp dụng lịch gợi ý ghi đúng vào lịch M5; Home hiện đúng nhóm cơ của hôm nay
- [ ] Không gọi mạng; presentation không chứa quy tắc gợi ý

## Rủi ro và câu hỏi còn mở

- Ngưỡng 60 tuổi và cách xử lý đau gối/vai là quy tắc đơn giản — cần bạn xác nhận trước khi code
- (Đã chốt) Áp dụng gợi ý ghi đè toàn bộ lịch M5, có xác nhận nếu lịch đang có dữ liệu.
- (Đã chốt 2026-11-04) Giảm mỡ chỉ hiện dòng chữ cardio; kinh nghiệm còn 2 mức; cân nặng tùy chọn, chỉ lưu; dụng cụ lọc bài theo `docs/04`.
- Đơn vị cân nặng: chỉ kg (theo `docs/03`)
