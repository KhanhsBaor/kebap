# M8 — Gợi ý lịch tập bằng AI

**Trạng thái:** todo (sau MVP)  
**Phụ thuộc:** M7  
**Demo cuối milestone:** Người dùng đồng ý gửi hồ sơ → nhận lịch gợi ý từ AI kèm một câu giải thích ngắn → Áp dụng như M7. Tắt mạng hoặc AI lỗi → app tự dùng lịch từ bộ quy tắc, không báo lỗi chặn.

**Nguồn sự thật:** định dạng đầu ra và bước kiểm tra ở `docs/04-schedule-suggestion-rules.md` mục 1 và 5.

## Mục tiêu và giá trị

Lịch gợi ý linh hoạt hơn bộ quy tắc cố định (kết hợp mục tiêu, hạn chế, nhóm ưu tiên tự nhiên hơn) mà vẫn an toàn vì luôn có dự phòng offline.  
**Giá trị:** lịch "hợp người" hơn cho người có nhiều ràng buộc; không làm mất tính offline-first.

## Trong phạm vi

- Server trung gian nhỏ giữ API key của nhà cung cấp AI (app không chứa key)
- Server chỉ nhận hồ sơ dạng enum / số (không có trường văn bản tự do), kiểm tra hợp lệ đầu vào và tự dựng prompt; app không gửi prompt. Có trần số lần gọi toàn cục mỗi ngày; vượt trần → trả lỗi để app dùng bộ quy tắc
- Payload chỉ gồm các trường đầu vào ở `docs/04` mục 1; không gửi cân nặng; năm sinh đổi thành nhóm tuổi (< 60 / ≥ 60) trước khi gửi
- Prompt kèm danh sách slug nhóm cơ hợp lệ; yêu cầu trả JSON theo schema cố định
- `AiScheduleSuggester` ở tầng data, implement cùng contract `ScheduleSuggester` của M7
- Kiểm tra kết quả theo `docs/04` mục 5; sai / timeout / mất mạng → dùng `RuleBasedScheduleSuggester`
- Màn xin đồng ý trước khi gửi dữ liệu; tắt được trong Cài đặt
- Cập nhật privacy policy + khai báo dữ liệu trên App Store / Google Play

## Ngoài phạm vi

- AI coach trong lúc tập, gợi ý tăng tạ, chat với AI (vẫn nhóm C)
- Gửi lịch sử buổi tập lên server
- Tài khoản người dùng / sync

## Checklist task (1 chat / task)

- [ ] Chốt nhà cung cấp AI + nền tảng server trung gian; cập nhật `docs/02-tech-stack.md`. Tiêu chí: nhà cung cấp không dùng dữ liệu API để huấn luyện và nêu rõ thời hạn lưu; server không ghi request/response body vào log
- [ ] Server: endpoint nhận hồ sơ (không định danh), gọi AI, trả JSON; giới hạn tần suất gọi
- [ ] Prompt + JSON schema đầu ra; test với các ví dụ của `docs/04` mục 6
- [ ] Data: `AiScheduleSuggester` + timeout + dự phòng sang bộ quy tắc
- [ ] Unit test: JSON hợp lệ / slug lạ / sai số ngày / timeout → dùng bộ quy tắc
- [ ] UI: màn đồng ý + chỉ báo "Gợi ý bởi AI" / "Gợi ý theo quy tắc" trên màn xem trước
- [ ] Privacy policy + khai báo cửa hàng ứng dụng

## Drift table / provider / màn hình

| Loại | Dự kiến |
|------|---------|
| Drift | Thêm cờ `aiConsent` vào `UserProfiles` (+ migration) |
| Providers | `scheduleSuggesterProvider` chọn bản AI khi có đồng ý và có mạng, ngược lại bản quy tắc |
| Màn hình | `AiConsentScreen`; cập nhật `SuggestedScheduleScreen` |

## Definition of Done

- [ ] `flutter analyze` + `flutter test` xanh
- [ ] App không chứa API key (kiểm tra bằng tìm chuỗi trong bản build)
- [ ] Mất mạng / AI trả sai → vẫn có lịch gợi ý từ bộ quy tắc
- [ ] Không gửi dữ liệu khi chưa đồng ý
- [ ] Server từ chối request có trường lạ hoặc giá trị ngoài enum; payload không chứa cân nặng / năm sinh chính xác

## Rủi ro và câu hỏi còn mở

- Đi ngược quyết định "không có backend ở MVP" — vì vậy M8 nằm sau MVP
- Chi phí mỗi lần gọi AI và cách chống lạm dụng endpoint
- Dữ liệu sức khỏe (cân nặng, tuổi, chấn thương) gửi ra bên thứ ba: cần privacy policy rõ ràng
- AI có được đề xuất kiểu chia lịch ngoài các mẫu trong `docs/04` mục 2 không? (đề xuất: được, miễn qua bước kiểm tra)
