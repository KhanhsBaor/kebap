# M5 — Lịch tuần theo nhóm cơ

**Trạng thái:** todo  
**Phụ thuộc:** M2  
**Demo cuối milestone:** Gán một hoặc nhiều **muscle group** (từ catalog region → group trong `01`) cho các ngày → Home/Start hiện “Hôm nay: Chest, Shoulders, Triceps” → một chạm bắt đầu buổi với các nhóm đó (vẫn log/compare như M2–M3).

## Mục tiêu và giá trị

Hoàn thiện bước 1 của luồng MVP: setup lịch tuần, giảm ma sát khi bắt đầu buổi.  
**Giá trị:** vào phòng tập → mở app → biết hôm nay tập gì → start nhanh (ít chạm hơn chọn tay mỗi lần).

## Trong phạm vi

- Model lịch: map `weekday` → **danh sách** `muscleGroupId` có thứ tự (ngày không có nhóm = nghỉ); cùng định dạng đầu ra của `docs/04` mục 1 để M7 áp dụng thẳng
- CRUD/setup lịch tuần (UI đơn giản)
- Home: gợi ý buổi hôm nay theo lịch
- Start workout prefill nhóm cơ từ lịch; vẫn cho đổi / tập ad-hoc
- Drift table + watch stream

## Ngoài phạm vi

- Lịch nhiều tuần / periodization phức tạp
- Nhắc thông báo push theo giờ tập
- Đồng bộ lịch với Google Calendar
- Template chương trình (PPL 6 ngày thương mại, v.v.) ngoài seed mặc định

## Checklist task (1 chat / task)

- [ ] Schema: `weekly_schedule_entries` (weekday, muscleGroupId, position; nhiều dòng / ngày; không có dòng = nghỉ) + migration
- [ ] Domain entity + repository contract
- [ ] Repository impl + seed lịch mặc định (vd. trống hoặc vài ngày mẫu: Chest / Quadriceps)
- [ ] Providers: watch schedule; `todayMuscleGroupsProvider`
- [ ] UI: `ScheduleSetupScreen` (7 ngày; mỗi ngày chọn một hoặc nhiều muscle group, hoặc nghỉ)
- [ ] UI: Home — card “Hôm nay” + CTA start
- [ ] Wire `StartWorkoutScreen`: nhận danh sách `muscleGroupId` từ lịch
- [ ] Test DAO/repo: weekday → nhiều group đúng thứ tự; rest day
- [ ] Demo: đổi lịch → Home đổi theo ngày giả lập hoặc mock clock nếu cần

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | `WeeklyScheduleEntries` |
| Providers | `scheduleRepositoryProvider`, `todayScheduleProvider` |
| Màn hình | `ScheduleSetupScreen`; cập nhật `HomeScreen` / start flow |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh; migration test nếu đổi schema
- [ ] Demo: set lịch → vào đúng weekday → start buổi đúng nhóm cơ trong ≤ 2 chạm từ Home
- [ ] Ngày nghỉ: UI rõ, không force start
- [ ] Ad-hoc start (M2) vẫn hoạt động

## Rủi ro và câu hỏi còn mở

- (Đã chốt 2026-11-04) Một ngày được có nhiều nhóm cơ.
- Tuần bắt đầu Monday hay Sunday? (locale)
- Lịch có “hiệu lực từ ngày” hay chỉ một template tuần lặp?
- Timezone khi xác định “hôm nay”?
