# Quy tắc cho code tính toán

Pointer cho agent/developer. **Công thức đầy đủ:** `docs/03-calculation-rules.md` (nguồn sự thật duy nhất).  
Cursor rule: `.cursor/rules/calculation-rules.mdc`.

- Mọi công thức (load volume, set volume, 1RM Epley, so sánh buổi, chart) theo `docs/03-calculation-rules.md`.
- Đổi công thức / ngưỡng / set hợp lệ: cập nhật `03` và mục **Lịch sử thay đổi** trước, rồi sửa code + test cho khớp.
- Hàm thuần Dart trong `lib/features/*/domain/` (vd. `calculations/`), không import Flutter hay Drift.
- Unit test bắt buộc; dùng ví dụ trong `03` (vd. Bench 60×10×2 + 60×8 → 1680).
- Warmup (`isWarmup`) và set thiếu kg/reps: loại khỏi volume và 1RM; không tính 0.
- 1RM chỉ với `reps ≤ 10`; so sánh theo bài (volume + max 1RM), ngưỡng giữ nguyên ±2%.
- Code và `03` mâu thuẫn thì hỏi người dùng — không tự chọn.
