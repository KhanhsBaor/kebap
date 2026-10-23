# M5 — Lịch tuần theo nhóm cơ

**Trạng thái:** todo  
**Phụ thuộc:** M2  
**Demo cuối milestone:** Gán nhóm cơ cho các ngày trong tuần → Home/Start hiện “Hôm nay: Pull” → một chạm bắt đầu buổi với nhóm cơ đó (vẫn log/compare như M2–M3).

## Mục tiêu và giá trị

Hoàn thiện bước 1 của luồng MVP: setup lịch tuần, giảm ma sát khi bắt đầu buổi.  
**Giá trị:** vào phòng tập → mở app → biết hôm nay tập gì → start nhanh (ít chạm hơn chọn tay mỗi lần).

## Trong phạm vi

- Model lịch: map `weekday` → `muscleGroupId` (và ngày nghỉ)
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

- [ ] Schema: `weekly_schedule_entries` (weekday, muscleGroupId nullable = rest) + migration
- [ ] Domain entity + repository contract
- [ ] Repository impl + seed lịch mặc định (vd. PPL hoặc trống)
- [ ] Providers: watch schedule; `todayMuscleGroupProvider`
- [ ] UI: `ScheduleSetupScreen` (7 ngày, chọn nhóm cơ)
- [ ] UI: Home — card “Hôm nay” + CTA start
- [ ] Wire `StartWorkoutScreen`: nhận `muscleGroupId` từ lịch
- [ ] Test DAO/repo: weekday → group; rest day
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

- Một ngày một nhóm cơ hay cho phép nhiều nhóm / split?
- Tuần bắt đầu Monday hay Sunday? (locale)
- Lịch có “hiệu lực từ ngày” hay chỉ một template tuần lặp?
- Timezone khi xác định “hôm nay”?
