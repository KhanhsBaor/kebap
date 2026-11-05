# Bảng ánh xạ seed bài tập Kebap

Nguồn: `exercises.csv` (1323 dòng). Kết quả: `exercises.filled.csv` (thêm cột cuối `reviewNote`). Script: `tools/fill.py`, `tools/write.py`.

Slug nhóm cơ và enum dụng cụ đã đối chiếu với `01-business-analysis.md` và `04-schedule-suggestion-rules.md`: khớp hoàn toàn với `seed-README.md`. Slug `others` hợp lệ nhưng không dòng nào dùng.

## 1. sourceMuscle → kebapMuscleGroup

| sourceMuscle | Số dòng | kebapMuscleGroup mặc định | Ghi chú |
|---|---|---|---|
| abs | 169 | abdominals |  |
| pectorals | 158 | chest |  |
| biceps | 151 | biceps |  |
| glutes | 144 | glutes |  |
| delts | 143 | shoulders |  |
| triceps | 141 | triceps |  |
| upper-back | 87 | upper_back |  |
| lats | 81 | lats |  |
| calves | 59 | calves |  |
| quads | 44 | quadriceps |  |
| forearms | 37 | forearms |  |
| cardio | 29 | cardio | giữ cardio |
| hamstrings | 28 | hamstrings |  |
| spine | 19 | lower_back |  |
| traps | 15 | traps |  |
| adductors | 6 | adductors |  |
| abductors | 5 | abductors |  |
| serratus-anterior | 5 | chest | gắn cờ: không có slug riêng |
| levator-scapulae | 2 | neck | gắn cờ: không có slug riêng |

Ngoại lệ theo dòng (ưu tiên theo thứ tự):

- `sourceCategory = cardio` → `cardio`.
- Bài toàn thân rõ ràng theo tên (snatch, clean, clean and jerk/press, thruster, Turkish get-up, farmers walk, lật lốp, búa tạ, battling ropes) → `full_body` (18 dòng, đều gắn cờ). Không tính các bài "clean grip".
- Tên là wrist curl nhưng nguồn ghi biceps → `forearms` (3 dòng, gắn cờ).
- Bài giãn cơ (stretching) giữ nhóm cơ theo nguồn.

## 2. sourceEquipment → kebapEquipment

| sourceEquipment | Số dòng | kebapEquipment |
|---|---|---|
| bodyweight | 458 | bodyweight |
| dumbbell | 287 | dumbbell |
| cable | 156 | cable |
| barbell | 148 | barbell |
| lever | 78 | machine |
| band | 62 | other |
| smith | 48 | machine |
| kettlebell | 41 | other |
| ez-bar | 23 | barbell |
| sled | 12 | machine |
| machine | 7 | machine |
| other | 3 | other |

Ngoại lệ: bài body weight cần bóng tạ / bóng tập / Bosu (trừ giãn cơ) → `other` (44 dòng, gắn cờ) để bộ lọc "Không dụng cụ" không hiện bài cần bóng; `Sledge Hammer` (nguồn ghi sled) → `other`; Front Lever / Back Lever / Front Lever Reps (nguồn ghi lever, thực ra là bài xà tự trọng) → `bodyweight` (3 dòng, gắn cờ); bài "weighted" nguồn ghi body weight giữ `bodyweight` nhưng gắn cờ.

## 3. Bảng thuật ngữ dịch

Quy ước: động tác tiếng Việt đứng đầu, sau đó tư thế/biến thể, cuối cùng là dụng cụ. Giữ từ mượn tiếng Anh phổ biến trong phòng gym Việt: Squat, Deadlift, Lunge, Plank, Curl, Dip, Pullover, Hip thrust, Glute bridge, Good morning, Smith, Snatch, Clean, Burpee, tên riêng (Arnold, Zottman, Romanian...). Các nhãn v2/v3/male/female bị bỏ; nếu trùng tên thì thêm hậu tố "(biến thể 2)", "(nam)", "(nữ)" hoặc số.

### Dụng cụ

| EN | VI |
|---|---|
| ez barbell | thanh EZ |
| low bar | thanh thấp |
| v bar | tay cầm chữ V |
| straight bar | thanh thẳng |
| resistance band | dây kháng lực |
| ez bar | thanh EZ |
| stability ball | bóng tập |
| bosu ball | bóng Bosu |
| medicine ball | bóng tạ |
| exercise ball | bóng tập |
| ab wheel | con lăn bụng |
| trap bar | thanh trap |
| cambered bar | thanh cong |
| dumbbell | tạ đơn |
| barbell | thanh đòn |
| cable | cáp |
| lever | máy |
| machine | máy |
| smith | máy Smith |
| band | dây kháng lực |
| kettlebell | tạ ấm |
| sled | máy sled |
| landmine | landmine |
| suspended | dây treo TRX |
| towel | khăn |
| roller | con lăn |
| wheel | con lăn |
| weighted | có tạ |

### Động tác chính

| EN | VI |
|---|---|
| bench press | Đẩy ngực |
| chest press | Đẩy ngực |
| floor press | Đẩy ngực sàn |
| push up | Hít đất |
| push-up | Hít đất |
| pushup | Hít đất |
| shoulder press | Đẩy vai |
| military press | Đẩy vai đứng |
| overhead press | Đẩy vai qua đầu |
| arnold press | Arnold press |
| z press | Đẩy vai ngồi sàn |
| landmine press | Đẩy landmine |
| leg press | Đạp đùi |
| hack squat | Hack squat |
| sissy squat | Sissy squat |
| pistol squat | Pistol squat |
| goblet squat | Goblet squat |
| front squat | Front squat |
| zercher squat | Zercher squat |
| split squat | Split squat |
| jump squat | Squat bật nhảy |
| sumo squat | Sumo squat |
| cossack squat | Cossack squat |
| squat | Squat |
| romanian deadlift | Romanian deadlift |
| stiff leg deadlift | Deadlift chân thẳng |
| sumo deadlift | Sumo deadlift |
| deadlift | Deadlift |
| good morning | Good morning |
| hip thrust | Hip thrust |
| glute bridge | Glute bridge |
| bridge | Nâng hông |
| hip abduction | Dạng hông |
| hip adduction | Khép hông |
| abduction | Dạng hông |
| adduction | Khép hông |
| leg extension | Đá đùi |
| leg curl | Móc đùi |
| lying leg curl | Móc đùi nằm |
| calf raise | Nhón bắp chân |
| calf press | Nhón bắp chân |
| donkey calf raise | Nhón bắp chân kiểu donkey |
| lunge | Lunge |
| step up | Bước bục |
| step-up | Bước bục |
| kickback | Đá tay sau |
| walking lunge | Lunge bước đi |
| hammer press | Đẩy tay trung tính |
| donkey kick | Đá chân sau |
| glute kickback | Đá mông |
| biceps curl | Curl tay trước |
| bicep curl | Curl tay trước |
| hammer curl | Curl búa |
| preacher curl | Curl ghế preacher |
| concentration curl | Curl tập trung |
| drag curl | Drag curl |
| zottman curl | Zottman curl |
| spider curl | Spider curl |
| reverse curl | Curl ngược tay |
| wrist curl | Curl cổ tay |
| wrist roller | Cuộn cổ tay |
| curl | Curl |
| triceps extension | Duỗi tay sau |
| tricep extension | Duỗi tay sau |
| triceps pushdown | Kéo cáp tay sau |
| pushdown | Kéo cáp tay sau |
| skull crusher | Skull crusher |
| skullcrusher | Skull crusher |
| french press | French press |
| jm press | JM press |
| dip | Dip |
| extension | Duỗi tay |
| lateral raise | Nâng vai ngang |
| front raise | Nâng vai trước |
| rear delt raise | Nâng vai sau |
| rear delt fly | Bay vai sau |
| rear delt row | Kéo vai sau |
| upright row | Kéo xà đứng |
| face pull | Face pull |
| shrug | Nhún vai |
| raise | Nâng |
| fly | Ép ngực |
| flye | Ép ngực |
| crossover | Ép ngực cáp chéo |
| pullover | Pullover |
| pec deck | Ép ngực máy |
| pulldown | Kéo xà |
| lat pulldown | Kéo xà |
| pull up | Hít xà |
| pull-up | Hít xà |
| chin up | Hít xà tay ngửa |
| chin-up | Hít xà tay ngửa |
| muscle up | Muscle up |
| bent over row | Gập người kéo tạ |
| pendlay row | Pendlay row |
| t bar row | Kéo T-bar |
| t-bar row | Kéo T-bar |
| inverted row | Kéo xà úp người |
| row | Kéo |
| hyperextension | Ưỡn lưng |
| back extension | Ưỡn lưng |
| superman | Superman |
| crunch | Gập bụng |
| crunches | Gập bụng |
| sit up | Gập bụng |
| sit-up | Gập bụng |
| russian twist | Russian twist |
| twist | Xoay người |
| leg raise | Nâng chân |
| knee raise | Nâng gối |
| plank | Plank |
| side plank | Plank nghiêng |
| v up | Gập bụng chữ V |
| v-up | Gập bụng chữ V |
| jackknife | Gập bụng jackknife |
| dead bug | Dead bug |
| mountain climber | Leo núi |
| flutter kick | Đá chân vẫy |
| scissor kick | Đá chân chéo kéo |
| windshield wipers | Gạt nước |
| rollout | Lăn bụng |
| rollerout | Lăn bụng |
| pallof press | Pallof press |
| woodchopper | Chặt củi |
| wood chop | Chặt củi |
| side bend | Gập sườn |
| stretch | Giãn cơ |
| burpee | Burpee |
| jumping jack | Jumping jack |
| jump rope | Nhảy dây |
| clean and jerk | Clean and jerk |
| power clean | Power clean |
| hang clean | Hang clean |
| clean | Clean |
| snatch | Snatch |
| jerk | Jerk |
| windmill | Cối xay gió |
| upright row | Kéo xà đứng |
| pistol | Pistol squat |
| cossack | Cossack squat |
| chin | Hít xà tay ngửa |
| chest dip | Dip ngực |
| bench dip | Dip trên ghế |
| handstand push up | Hít đất trồng chuối |
| jm bench press | JM press |
| skull press | Đẩy skull |
| neck stretch | Giãn cơ cổ |
| thruster | Thruster |
| swing | Swing |
| turkish get up | Turkish get-up |
| farmers walk | Farmer walk |
| farmer walk | Farmer walk |
| walk | Đi bộ |
| walking | Đi bộ |
| run | Chạy |
| sprint | Chạy nước rút |
| box jump | Bật nhảy bục |
| jump | Bật nhảy |
| hops | Bật nhảy |
| handstand | Trồng cây chuối |
| planche | Planche |
| l sit | L-sit |
| front lever | Front lever |
| back lever | Back lever |
| human flag | Human flag |
| bike | Đạp xe |
| stationary bike | Đạp xe tại chỗ |
| elliptical | Máy elliptical |
| treadmill | Máy chạy bộ |
| stepmill | Máy leo thang |
| ski ergometer | Máy ski |
| battling ropes | Đánh dây thừng |
| inchworm | Inchworm |
| bear crawl | Bò gấu |
| crawl | Bò |
| slam | Đập bóng |
| throw | Ném |
| carry | Mang tạ đi bộ |
| press | Đẩy |
| presses | Đẩy |
| rotation | Xoay |
| tap | Chạm |
| touch | Chạm |
| reach | Vươn tay |
| hang | Treo người |
| lift | Nâng |
| squeeze | Ép |
| hug | Ôm |
| march | Dậm chân |
| circles | Xoay tròn |
| wipers | Gạt nước |
| kick | Đá chân |
| climb | Leo |
| drive | Đẩy |
| pose | Tư thế |
| tilt | Nghiêng |
| flexion | Gập |
| bend | Gập người |
| toe touch | Chạm mũi chân |
| cobra | Tư thế rắn hổ mang |
| sphinx | Tư thế nhân sư |
| hindu push up | Hít đất Hindu |
| diamond push up | Hít đất kim cương |

### Tư thế / biến thể thường gặp

| EN | VI |
|---|---|
| incline | ghế dốc lên |
| decline | ghế dốc xuống |
| seated | ngồi |
| standing | đứng |
| lying | nằm |
| kneeling | quỳ |
| prone | nằm sấp |
| supine | nằm ngửa |
| hanging | treo xà |
| one arm | một tay |
| one leg | một chân |
| alternate | luân phiên |
| reverse grip | tay ngửa |
| close grip | tay hẹp |
| wide grip | tay rộng |
| neutral grip | tay trung tính |
| rear | sau |
| front | trước |
| side | nghiêng |
| lateral | ngang |
| overhead | qua đầu |
| bent over | gập người |
| straight leg | chân thẳng |
| assisted | có hỗ trợ |
| behind neck | sau gáy |
| floor | trên sàn |
| wall | dựa tường |

## 4. Tổng theo nhóm cơ

| kebapMuscleGroup | Số dòng |
|---|---|
| abdominals | 168 |
| chest | 163 |
| biceps | 147 |
| triceps | 141 |
| glutes | 140 |
| shoulders | 136 |
| upper_back | 87 |
| lats | 81 |
| calves | 59 |
| quadriceps | 42 |
| forearms | 39 |
| cardio | 29 |
| hamstrings | 26 |
| lower_back | 19 |
| full_body | 18 |
| traps | 15 |
| adductors | 6 |
| abductors | 5 |
| neck | 2 |
| others | 0 |

## 5. Tổng theo dụng cụ

| kebapEquipment | Số dòng |
|---|---|
| bodyweight | 417 |
| dumbbell | 287 |
| barbell | 171 |
| cable | 156 |
| other | 151 |
| machine | 141 |

## 6. Dòng cần xem lại

**133** dòng có `reviewNote`. Lý do chính: cần bóng tập/Bosu → other (33), bài weighted nguồn ghi body weight (30), tên Việt chưa chắc (27), full_body theo tên (18), cần bóng tạ → other (11), serratus-anterior → chest (5), wrist curl → forearms (3), dụng cụ nguồn là other (3), levator-scapulae → neck (2), front/back lever ghi lever → bodyweight (3), búa tạ ghi sled (1). Một dòng có thể có nhiều lý do.

Lưu ý: 56 tên tiếng Việt dài hơn 40 ký tự (dài nhất 55) vì tên gốc dài; không gắn cờ.

## 7. 15 dòng mẫu ngẫu nhiên (seed 7)

| nameEn | nameVi | Nhóm cơ | Dụng cụ |
|---|---|---|---|
| Dumbbell Squat | Squat tạ đơn | glutes | dumbbell |
| Ez Bar Biceps Curl With Arm Blaster | Curl tay trước đệm tay thanh EZ | biceps | barbell |
| Cable Underhand Pulldown | Kéo xà tay ngửa cáp | lats | cable |
| Jackknife Sit Up | Gập bụng gập bụng jackknife | abdominals | bodyweight |
| Smith Hip Raise | Nâng hông máy Smith | abdominals | machine |
| Band Close Grip Push Up | Hít đất tay hẹp dây kháng lực | triceps | other |
| Barbell Seated Close Grip Concentration Curl | Curl tập trung ngồi tay hẹp thanh đòn | biceps | barbell |
| Exercise Ball Seated Hamstring Stretch | Giãn cơ ngồi đùi sau bóng tập | hamstrings | bodyweight |
| Ez Bar Close Grip Bench Press | Đẩy ngực tay hẹp thanh EZ | triceps | barbell |
| Lying Leg Hip Raise | Nâng nằm chân hông | abdominals | bodyweight |
| Lever Alternate Leg Press | Đạp đùi luân phiên máy | quadriceps | machine |
| Barbell Upright Row | Kéo xà đứng thanh đòn | shoulders | barbell |
| Flexion Leg Sit Up Straight Arm | Gập bụng gập chân tay thẳng | abdominals | bodyweight |
| Cable Hip Adduction | Khép hông cáp | adductors | cable |
| Cable One Arm Lateral Bent Over | Nâng vai ngang gập người một tay cáp | chest | cable |
