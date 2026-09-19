# تحلیل فنی عمیق و کامل — فایل‌های گرافیکی Assetto Corsa
### (CSP Presets · Video Settings · PURE Config · PPFilter)

> نسخه‌ی ۲ — تحلیل تخصصی، بخش‌به‌بخش، با اعتبارسنجی تک‌تک مقادیر
> پروژه: `shat` · تاریخ: ۱۳ سپتامبر ۲۰۲۶

---

## فهرست

- [A. روش‌شناسی و موجودی فایل‌ها](#a)
- [B. تحلیل عمیق پریست‌های CSP (تمام ۱۲۵ سکشن)](#b)
- [C. جدول کامل تفاوت‌های ۵ پریست CSP](#c)
- [D. تحلیل عمیق پریست‌های ویدیویی](#d)
- [E. تحلیل عمیق کانفیگ‌های PURE](#e)
- [F. تحلیل عمیق PPFilter](#f)
- [G. ماتریس سازگاری و ناسازگاری‌های زنجیره](#g)
- [H. جدول نهایی یافته‌ها با اولویت و راه‌حل دقیق](#h)
- [I. دستورالعمل اصلاح (مقادیر دقیق)](#i)

---

<a id="a"></a>
## A. روش‌شناسی و موجودی فایل‌ها

**روش تحلیل:** هر فایل به‌صورت کامل پارس شد (سکشن‌ها + کلید/مقدار)، هر ۵ پریست با هم مقایسه شدند (diff کامل روی *تمام* کلیدها)، بلوک‌های Base64 رمزگشایی شدند، و مقادیر در برابر دانش فنی AC/CSP/PURE اعتبارسنجی شدند.

**موجودی فایل‌ها:**

| فایل | خطوط | فرمت / انکودینگ | ماهیت |
|---|---|---|---|
| `CSP {Low,Medium,High,VeryHigh,Ultra}.ini` (×۵) | ۷۴۴–۷۸۲ | INI، UTF-8 با BOM، CRLF | پریست CSP ذخیره‌شده توسط Content Manager |
| `video {Low,...,Ultra}.cmpreset` (×۵) | ۱ خط JSON | JSON (سه INI داخل آن) | پریست ویدیوی Content Manager |
| `UhmFilter.ini` | ۲۹۴ | INI | فیلتر PP (نسخه‌ی ویرایش‌شده‌ی NFS 2015 ساخته‌ی Vatsky) |
| `Uhm Config-Realistic.ini` / `Uhm PureConfig-Simple.ini` | ~۲۵۰ | INI (فرمت اپ Pure Config) | کانفیگ PURE |

**یافته‌ی ساختاری مهم:** پریست‌های CSP همگی یک «اسکلت» مشترک دارند (بخش‌های فیزیک/FFB/AI/NECK/VR و... **دقیقاً یکسان** در هر ۵ فایل) و فقط بخش‌های گرافیکی پلکانی بالا می‌روند. این یعنی سازنده پریست‌ها را به‌صورت حرفه‌ای از یک «پایه» مشترک مشتق کرده است.

---

<a id="b"></a>
## B. تحلیل عمیق پریست‌های CSP (تمام سکشن‌ها)

> مقادیر ذکرشده مربوط به پریست **Ultra** (مرجع) است؛ اختلاف‌های سایر پریست‌ها در بخش C آمده.
> علامت‌ها: ✅ = درست/بهینه · ⚠️ = قابل بحث · ❌ = اشتباه/خطر

### B1. متادیتا — `[CONFIGURATION]`

`AFFECTED_SECTIONS` فهرست ۴۴ نام افزونه‌ای است که پریست «اعمال» می‌کند. **۸ افزونه در این فهرست هستند اما هیچ سکشنی در بدنه‌ی فایل ندارند:**

> `G27_LIGHTS`, `SURFACES_FX`, `FREER_CAMERA`, `TRIPLE_CUSTOM`, `CAR_INSTRUMENTS`, `TYRES_FX`, `TASKBAR`, `MUSIC`

**تفسیر:** وقتی پریست را اعمال می‌کنید، CM این ۸ افزونه را هم «تحت تأثیر» می‌داند ولی هیچ مقداری برایشان نمی‌نویسد؛ یعنی عملاً روی **مقادیر پیش‌فرض CSP** قرار می‌گیرند. این رفتار عمدی (برای تمیز نگه‌داشتن پریست) یا سهوی است؛ اثر منفی خاصی ندارد ولی باید بدانید پریست، چراغ‌های G27، دوربین آزاد، تریپل و... را دست نمی‌زند. ⚠️

### B2. بخش `GENERAL` (وصله‌های عمومی)

| کلید | مقدار | معنی | وضعیت |
|---|---|---|---|
| `INPUTS_REMAP: SKIP_THROTTLE_CURVES / OVERRIDE_CAR_FFMULT / OVERRIDE_CAR_STEERASSIST` | 0/0/0 | اجازه‌ی بازنگاشت پدال/FFB/کمک‌فرمان خودرو | ✅ پیش‌فرض امن |
| `CONTROL: RELEASE_DPAD / RELOAD_ON_FOCUS / DISCORD_HOOK_FIX2 / FIX_ORDER2` | 1/1/1/1 | رفع باگ D-pad، بارگذاری مجدد هنگام فوکوس، فیکس هوک دیسکورد | ✅ |
| `REPLAY: EXT_LOAD / EXT_RECORD / EXT_SAVE` | 1/1/1 | افزونه‌های ریپلی | ✅ |
| `CONFIGURATIONS: HTTP_FLAGS=HTTP2,TLS13` | — | پروتکل HTTP برای به‌روزرسانی‌ها | ✅ |
| `CONFIGURATIONS: FILE_OP_HOOK` | `C:/Users/illvd/...cspdecryptexample.dll,FileOpHook` | **هوک DLL محلی از کامپیوتر سازنده** | ❌ **حذف شود** (بخش H-3) |
| `CUSTOM_FONTS_RENDERING: ENABLED=1, HARDWARE_ACCELERATION=1` | — | رندر جدید فونت با شتاب سخت‌افزاری | ✅ |
| `CAR_CAMERAS: SHAKING_BONNET/BUMPER=0,0` | — | لرزش دوربین کاپوت/سپر خاموش | ✅ سلیقه‌ای |
| `OPTIMIZATIONS: ALLOW_TEARING=1` | — | اجازه‌ی پارگی تصویر برای کاهش تاخیر | ✅ (سیم‌ریسینگ) |
| `OPTIMIZATIONS: EARLY_CULL_CHECK / FORCE_UAV_SUPPORT` | 1/1 | حذف زودهنگام هندسه‌ی نامرئی + UAV | ✅ |
| `FPS_LIMIT_TWEAKS: USE_ADJUSTED_FRAME_TIME=1, USE_SLEEP=1` | — | تایمینگ دقیق‌تر محدودکننده‌ی فریم | ✅ |
| `OPTIMIZATIONS_CPU: LIMIT_GENERAL/SHADOWS=1, LIMIT_SMOKE=3, MERGE_MESHES=1, FLATTEN_NODES=0, HYPERTHREADING_FIX=1, LIMIT_AUDIO=0` | — | کاهش بار CPU؛ `FLATTEN_NODES=0` یعنی این گزینه خاموش | ⚠️ بیشتر راهنماها `FLATTEN_NODES` را روشن توصیه می‌کنند |
| `PHYSICS_EXPERIMENTS_DONE` / `PHYSICS_EXPERIMENTS` | ~۲۰ کلید فعال | فیکس‌های برخورد/تایر (RIM_COLLISION، SLIDING_FIX، BRAKES_LIMIT و...) | ✅ مجموعه‌ی استاندارد «تست‌شده» |
| `SHARED_MEMORY: REDUCE_GFORCES_WHEN_SLOW=1` | — | کاهش G در سرعت پایین (برای اپ‌های موشن) | ✅ |
| `DEV: DX_DEVICE_PRIORITY=7, GRACEFUL_START=3, CAR_PAINT_TEXTURE_NAMES=...` | — | تنظیمات توسعه‌دهنده؛ GRACEFUL_START=3 حالت شروع نرم | ✅ |
| `OPTIMIZATIONS_GPU: OPTIMIZE_MESHES_MORE, QUERY_BASED_MAPPING, SEPARATE_SHADOW_MESHES, UPGRADE_TEXTURES, USE_NEW_DDS_LOADER, BC7_CACHE` | 1 | بهینه‌سازی GPU **بدون افت کیفیت** (طبق Hint خود CSP) | ✅ |
| `AUDIO: FMOD_FLAGS=4, USE_EXTERIOR_SKIDS=1, CUSTOM_UPDATE=1` | — | صدای FMOD و صدای سُر خوردن بیرون خودرو | ✅ |
| `PHYSICS: LIMIT_CONTACTS=1, USE_TEMPORAL_CACHE=1, CUSTOM_RAYCASTING=0` | — | فیزیک بهینه | ✅ |
| `QOS_TWEAKS` | QWAVE_TYPE=5 و... | QoS شبکه (برای آنلاین) | ✅ بی‌اثر در آفلاین |
| `PHYSICS_SHADOWS: TEMPERATURE_MULT=1` | — | ضریب سایه‌ی فیزیک (تغییر دمای تایر) | ✅ |

### B3. `FFB_TWEAKS` و `GAMEPAD_FX`

| کلید | مقدار | معنی | وضعیت |
|---|---|---|---|
| `FFB_TWEAKS:GYRO2: ENABLED=1` | 1 | افکت ژیروسکوپی (گشتاور ژیرو) در فرمان | ✅ سلیقه‌ای |
| `GAMEPAD_FX:JOYPAD_ASSIST: ENABLED=1, IMPLEMENTATION=Advanced Gamepad Assist` | — | کمک‌رانندگی پیشرفته‌ی دسته | ✅ |
| `GAMEPAD_FX:__PLUGINS: JOYPAD_ASSIST_SETTINGS=` (خالی) | — | تنظیمات پلاگین = پیش‌فرض | ✅ |

### B4. `NEW_BEHAVIOUR` (هوش مصنوعی)

| کلید | مقدار | معنی |
|---|---|---|
| `AI_TWEAKS: STOP_TELEPORTING_STUCK=1` | — | جلوگیری از «تلپورت» AI گیرکرده |
| `RAIN: AVOID_PUDDLES=1` | — | AI در باران از گودال‌ها اجتناب می‌کند |
| `AI_RACE_RETIREMENT: REJOIN=1` | — | بازگشت AI پس از کناره‌گیری |
| `WRONG_WAY: ALLOW_IN_TRACKDAY=0` | — | در Trackday حرکت خلاف ممنوع |
| `AI_FLOOD: SPEED_LIMIT=150,250` | — | محدودیت سرعت AI در آب‌گرفتگی |
| `AI_RACE_RUBBERBANDING: INCREASE_BEHIND=0.15, DECREASE_AHEAD=0` | — | کش‌لاسیتک ملایم (فقط وقتی عقب‌ترند کمی سریع‌تر) |
| `AI_SPLINES: SAFE_NORMALS_RAYCASTING=1` | — | محاسبه‌ی امن نرمال‌ها |

### B5. `RAIN_FX`

| کلید | مقدار | معنی | وضعیت |
|---|---|---|---|
| `SCREEN_DROPS: STYLE_*=DISTANT` | — | سبک قطرات روی لنز دوربین | ✅ |
| `VISUAL_TWEAKS: HITS_INTENSITY=2, DEBLUR_PAUSED_RAINDROPS=1` | — | شدت برخورد قطرات | ✅ |
| `VISUAL_TWEAKS: RAIN_MAPS_QUALITY` | Low=2، بقیه=0 | کیفیت نقشه‌ی باران | ⚠️ **ناهماهنگ** (بخش C) |
| `RACING_LINE_DEV: ENABLED=1, SPLASH_MULT=0.15` | — | خط مسابقه + پاشش آب | ✅ |

### B6. `GRAPHICS_ADJUSTMENTS` (ریزتنظیم‌های بصری)

| کلید | مقدار (Ultra) | معنی | وضعیت |
|---|---|---|---|
| `ADAPTIVE_CLIP_PLANES: FAR_PLANE=20000,30000 / NEAR_PLANE=0.1,10 / FOV_RANGE=0.5,12` | — | صفحات برش تطبیقی (رفع z-fighting) | ✅ |
| `ANTIALIASING: QUALITY=ULTRA, FFXCAS_SHARPNESS=1` | — | ارتقای FXAA→SMAA/CAS با شارپنس | ✅ (نیازمند FXAA=1 در ویدیو) |
| `COLOR_BUFFER2: ACTIVE=1, FULL_RESOLUTION=1, EXTRAFX_INTEGRATION=1` | — | بافر رنگ کامل برای انکسار | ✅ سنگین‌تر ولی باکیفیت |
| `CUSTOM_BLOOM_DEV: ENABLED=0` | — | بلوم سفارشی خاموش | ✅ |
| `FSR: QUALITY2=-1` | — | **آپ‌اسکیل FSR/DLSS خاموش** | ✅ (رندر خام) |
| `FSR: DLSS_PRESET=13, QUALITY_DLSS=1, QUALITY_SGSR2=1, OLD_IMPLEMENTATION=3` | — | ذخیره‌شده ولی **بی‌اثر** چون QUALITY2=-1 | 🟢 |
| `HUMAN_SHADER: ENABLED=1` | — | شیدر جدید راننده | ✅ |
| `LODS: CARS_DISTANCE_MULT=1.15, TRACK_DISTANCE_MULT=1.99, TREES_DISTANCE_MULT=1.95, HIDE_DISTANT_DRIVERS=0` | — | فاصله‌ی LOD بیشتر (فقط Ultra) | ⚠️ هزینه‌بر |
| `MOTION_BLUR: EXTERIOR_MULT=1.2, INTERIOR_MULT=1.4` | — | ضریب موشن‌بلور درونی | ✅ |
| `RENDER_SCALE: SCALE=1.5, SCREENSHOTS_SCALE=2, QUALITY=2` | — | **رندر ۱۵۰٪ (سوپرسمپلینگ)** | ❌ فقط برای اسکرین‌شات (بخش H-5) |
| `SCRIPTABLE_FILTER: ENABLED=1, IMPLEMENTATION=pure` | — | فیلتر اسکریپتی PURE | ✅ |
| `SHADER_REPLACEMENTS: ALLOW_TAG_PBR/NEW_WATER/NEW_CARPAINT=1` | — | شیدرهای جدید بدنه/آب | ✅ |
| `TWEAKS: REORDER_DRIVER_RENDERING2=1, SRV_OUTPUT=1` | — | ترتیب رندر راننده + SRV | ✅ |
| `VISIBLE_CARS` | GBUFFER=2,4,8,12 و... | تعداد خودرو در پاس‌های مختلف | ✅ متعادل |

### B7. `EXTRA_FX` (افکت‌های سنگین)

| کلید | مقدار (Ultra) | معنی | وضعیت |
|---|---|---|---|
| `GBUFFER: USE_DEPTH_PREPASS=0` | — | پیش‌پاس عمق خاموش | ✅ |
| `MOTION_BLUR: ENABLED=1, MULT=0.42, QUALITY_2=2, JITTER_MULT=0.01` | — | موشن‌بلور CSP | ✅ |
| `SSLR: STEPS_HIZ=300, STEPS_SIMPLE=300, TRACING_QUALITY=2/3/4` | — | انعکاس Screen-Space (کیفیت بالا) | ⚠️ سنگین |
| `DEPTH_REDUCTION: ENABLED=1, READBACK_DELAY=5` | — | کاهش عمق | ✅ |
| `SSAO: SCALE=1` | — | سایه‌روشن محیطی | ✅ |
| `SSGI: ENABLED=1, SCALE=1` | — | **روشنایی سراسری Screen-Space** | ⚠️ **در همه‌ی پریست‌ها فعال است (حتی Low!)** |
| `BASIC: ENABLED=1, ALLOW_IN_TRIPLE=1` | — | فعال‌سازی Extra FX | ✅ |
| `TAA: EXTRA_SHARPEN_PASS=0.05, HISTORY_SHARPEN=0` | — | ضد دندانه‌ی زمانی | ✅ |
| `HBAO: ENABLED=1, OPACITY=1` | — | Ambient Occlusion افقی | ⚠️ در همه‌ی پریست‌ها فعال |
| `FOG_BLUR: ENABLED=0, DISTANCE_MULT=1.45` | — | بلور مه **خاموش** (مقدار بی‌اثر) | ✅ |
| `ASSAO: OPACITY=0.6, QUALITY=3` | — | AO الگوریتم AS (فقط Low/Ultra صریح) | ⚠️ ناهماهنگ |
| `VOLUMETRIC_LIGHTS: SCALE=0.32, INTENSITY_MULT=2` | — | نور حجمی | ✅ |

**نکته‌ی کلیدی درباره‌ی پریست Low:** SSGI، HBAO، SSLR، موشن‌بلور و Depth Reduction در Low هم روشن‌اند؛ Low فقط گام‌های ردیابی و شدت‌ها را کم می‌کند. یعنی این پریست‌ها برای **سیستم‌های واقعاً ضعیف** مناسب نیستند — «Low» در عمل یک «Medium-» است.

### B8. `LIGHTING_FX`

| کلید | مقدار (Ultra) | معنی |
|---|---|---|
| `BASIC` | ۱۵ ضریب (SPECULAR_MULT=0.75، BOUNCED_LIGHT_MULT=0.25، EMISSIVE_CAMERA_GAIN=2 و...) | نورپردازی داینامیک: بازتاب نور، نور برگشتی، نور انتشار |
| `SHADOWS: ENABLED=1, HIGH_QUALITY_HEADLIGHT_SHADOWS=1, CARS_SHADOWS=3, DETAILED_SHADOWS_FROM_CARS_NEARBY=2, SPECTATING_CARS_SHADOWS=5` | — | سایه‌ی خودروها و چراغ‌ها (فقط High+ کیفیت چراغ؛ فقط Ultra سایه‌ی ۳ و تماشاگری ۵) |
| `PERFORMANCE: ENABLE_REARVIEWMIRROR_LIGHT=2, CARS_WITH_LIGHTS=15` | — | نور در آینه‌ی عقب + تعداد خودروهای دارای نور فعال (فقط VeryHigh/Ultra) |

### B9. `PARTICLES_FX`

| گروه | مقدار (Ultra) | معنی |
|---|---|---|
| `SMOKE_DEV` | SPAWN_MULT=1، LIMIT=8000 | دود نرم |
| `MIRAGEDISRUPTION` | ENABLED=1، LIMIT=4000 | موج گرمای اختلال دید |
| `FLAMES` | LIMIT=2000، FLAMING_WHEELS=0 | شعله |
| `SPARKS` / `SPARKS_DEV` | SPAWN_RATE=2000 + ۲۰ پارامتر فیزیک جرقه (GRAVITY=-9.81، LIFESPAN و...) | جرقه با فیزیک کامل |
| `SMOKE` | QUANTITY_SCALE=1.2، CLIP_BY_GLASS=1، HEATING_EXTRA=0.05 | دود |
| `MARBLES` (قدیمی) / `MARBLES_2` (جدید) | MARBLES فعال (LIMIT=80000)، MARBLES_2 خاموش | سنگریزه — سیستم قدیمی فعال است |
| `WINDSCREEN` | ENABLED=1، LIMIT=100000 | قطره/آلودگی شیشه |
| `PIECES` | USE_COLLIDER_MESH=1، COLLIDE_WITH_CARS=1 | خرده‌های بدنه با برخورد |
| `OILSPILL` / `SKIDWET` / `CARDROPS` / `TRACES` / `FIREWORKS` | فعال با LIMIT | لکه‌روغن، رد لاستیک خیس، افتادن اجزا، رد ترمز، آتش‌بازی |

### B10. `REFLECTIONS_FX`

| کلید | مقدار (Ultra) | معنی |
|---|---|---|
| `LOCAL_CUBEMAPS_CARS2 / TRACKS2: ENABLED=1, ALLOW_DYNAMIC=1` | — | مکعب‌های انعکاس محلی داینامیک خودرو/پیست |
| `GBUFFER: USE_COLOR_MSAA_RESOLVE=1` | — | حل رنگ با MSAA برای انعکاس |
| `WINDSCREEN: FOG_LINEAR=280, FOG_COLOR=0,0,0` | — | مه در انعکاس شیشه |
| `MAIN_CUBEMAP: RESOLUTION=1024, RESOLUTION2=2048, USE_64BPP_2=0` | — | انعکاس اصلی (Ultra=2048) |
| `BASIC: ENABLED=1`، `MOTION_BLUR: MULT=0.05` | — | پایه + موشن‌بلور انعکاس |

### B11. `SMART_SHADOWS`

`USE_DISC_SHADOWS=AUTO`, `ANISOTROPY=1`, `AUTOMATIC_SPLITS_DISTANCE=400`, `AUTOMATIC_SPLITS_LAMBDA=1` — تقسیم خودکار آبشار سایه با فاصله‌ی ۴۰۰ متر. ✅

### B12. `WEATHER_FX` — **یافته‌ی کلیدی رمزگشایی‌شده**

| کلید | مقدار | معنی |
|---|---|---|
| `BASIC: IMPLEMENTATION=pure, CONTROLLER=pureCtrl static` | — | سبک آب‌وهوا = **PURE** با کنترلر static |
| `__PLUGINS: IMPLEMENTATION_SETTINGS` (Base64) | رمزگشایی شد → | `[LINEAR_COLOR_SPACE]` / `ENABLED=1` |

**نتیجه‌ی قطعی:** پریست‌های CSP این پروژه برای **Pure LCS (فضای رنگ خطی)** تنظیم شده‌اند، نه Pure Gamma. این یک انتخاب «حرفه‌ای‌تر ولی سخت‌گیرتر» است: LCS نیازمند فیلتر سازگار با LCS و `DISABLE_LEGACY_HDR=1` در ویدیو است (که پریست Ultra ویدیو آن را ندارد! → بخش G/H).

| کلید | مقدار | معنی |
|---|---|---|
| `PP_FIRST_PERSON_VIEW: NO_CHROMATIC_ABERRATION=1` | — | حذف انحراف رنگی در دید اول‌شخص |
| `NOISE_VOLUME: DEPTH=128, RESOLUTION=512` | — | بافت نویز ابر |
| `PERFORMANCE: DETAILED_CLOUD_SHADOWS=0` | — | سایه‌ی جزئی ابر خاموش (کارایی) ✅ |
| `STATIC_REFLECTIONS: INCLUDE_EMISSIVES=1, REFRESH_FACE_DELAY=0.5` | — | انعکاس استاتیک + اجسام نورانی |
| `MISCELLANEOUS: USE_MIRAGE_REFLECTIONS=1, FORCE_HEADLIGHTS=1` | — | انعکاس سراب + چراغ‌ها همیشه روشن |

### B13. `CHASER_CAMERA` و `NECK`

- **Chaser Camera:** `IMPLEMENTATION=kirbycam`, `ENABLED=1` — دوربین تعقیبی خارجی «kirbycam». ✅
- **Neck FX پایه:** فعال (`ENABLED=1`) با G-Forces (LIMIT=0.12)، تراز با فرمان (ALIGN_WITH_STEERING=0.6) و Lookahead خاموش (GAIN=0).
- **Neck اسکریپت:** `IMPLEMENTATION=ac-head-physics` اما **`ENABLED=0`** (خاموش!). تنظیمات کامل این اسکریپت (رمزگشایی‌شده) ذخیره شده ولی فعال نیست:

```
[PITCH/ROLL/YAW/FORWARD/HORIZONTAL/VERTICAL PHYSICS]  → فیزیک حرکت سر (دمپینگ 0.85)
[LOOK AHEAD]  MAX_SPEED=0, STEER_SCALE=0.1, TRACK_DISTANCE=2
[EFFECTS]  GEAR_BUCK_*  → تکان سر هنگام تعویض دنده (ENABLED=1)
[ADVANCED PARAMETERS]  ADVANCED_MODE=1, HORIZONTAL_YAW_PIVOT=25 ...
```

یعنی «فیزیک سر» واقعی خاموش است و فقط Neck پایه کار می‌کند. اگر بخواهید حرکت سر هنگام تعویض دنده را ببینید، باید `NECK:SCRIPT: ENABLED=1` شود. 🟢

### B14. `VR_TWEAKS`

`SINGLE_PASS_STEREO: ENABLED=0, USE_VRS=0` → رندر تک‌پاس و VRS خاموش. `VR_MIRRORING_STABILIZER: ENABLED=1`، `SEPARATE_EYES=3`. مخصوص VR — بدون VR بی‌اثر. ✅

### B15. `SMART_MIRROR` / `WINDSCREEN_FX` / `GRASS_FX` / `SKIDMARKS_FX` / `TRACK_ADJUSTMENTS`

| بخش | مقدار | معنی |
|---|---|---|
| `SMART_MIRROR:REAL_MIRRORS: ENABLED=1, ACTIVE_ON_FOCUSED=1, ALTER_FOV=1` | — | آینه‌ی واقعی (فقط آینه‌ی فوکوس‌شده، با اصلاح FOV) ✅ |
| `WINDSCREEN_FX: REFLECTION ENABLED=1, INTENSITY_MULT=1; SHADOWS BLUR_MULT=2` | — | انعکاس و سایه روی شیشه |
| `GRASS_FX: QUALITY=4 (High+), CAST_SHADOWS=1 (Med+), EXTRAFX_PASS=1 (High+)` | — | چمن با سایه |
| `SKIDMARKS_FX: ADVANCED_BLENDING=1, RESET_WITH_RESTART=1` | — | رد لاستیک با ترکیب پیشرفته |
| `TRACK_ADJUSTMENTS: CREW HIDE_ENTIRELY=1, SPECTATORS HIDE_ALL=1, SEASONS ALLOW_ADJUSTMENTS=2` | — | **حذف خدمه و تماشاگران** (افزایش FPS) + فصول |
| `TRACK_ADJUSTMENTS:FIXES: DOUBLESIDED_SHADOWS=1, FIX_GROOVES_RENDERING_ORDER=1` | — | فیکس سایه و شیار پیست |

### B16. `GUI` / `CHAT` / `SPLASHSCREEN` / `DXGI` / `NICE_SCREENSHOTS` / `SMALL_TWEAKS`

| بخش | مقدار | معنی | وضعیت |
|---|---|---|---|
| `GUI:HIDE: HIDE_CONSOLE=1, HIDE_CPU_OCCUPANCY_MESSAGE=1` | — | مخفی‌کردن کنسول و پیام CPU | ✅ |
| `GUI:NEW_UI_2: APP_*_DEBUG=1` | — | **اپ‌های دیباگ** گراس/لایتینگ/پارتیکل/اکسترافکس در UI | ⚠️ سلیقه‌ای (برای کاربر عادی اضافی) |
| `GUI:NEW_UI: UI_SCALE=1.5` | فقط Ultra | مقیاس UI | ⚠️ ناهماهنگ بین پریست‌ها |
| `CHAT_SHORTCUTS: ENABLED=1` | — | میان‌برهای چت | ✅ |
| `SPLASHSCREEN: ENABLED=1, INTERVAL=5, SMOOTH_FADE_IN=1` | — | اسلایدشوی صفحه‌ی شروع | ✅ |
| `DXGI_TWEAKS: SELECT_ADAPTER=NVIDIA?` | — | انتخاب آداپتور گرافیکی | ❌ **مقدار مشکوک** (بخش H-8) |
| `NICE_SCREENSHOTS: ACCUMULATION_AA (DISABLE_FXAA=1, MIP_LOD_BIAS=-4), ACCUMULATION_DOF=1, ACCUMULATION_BLUR (ITERATIONS_MULT=9, TIME_MS=32), BRIGHTNESS_BOOST HDR=2, ALLOW_PNG_FORMAT=1, WIC QUALITY=100` | — | موتور اسکرین‌شات حرفه‌ای (جمع‌آوری AA برای عکس بدون دندانه) | ✅ عالی |
| `SMALL_TWEAKS: RECONNECT_WHEEL_ON_APP_RESTORE=1` | — | اتصال مجدد فرمان | ✅ |

---

<a id="c"></a>
## C. جدول کامل تفاوت‌های ۵ پریست CSP

> «—» یعنی کلید در آن پریست غایب است (= مقدار پیش‌فرض CSP). **همه‌ی بخش‌های دیگر (GENERAL/FFB/AI/NECK/VR و...) بین ۵ پریست یکسان‌اند.**

| کلید | Low | Medium | High | VeryHigh | Ultra | تفسیر |
|---|---|---|---|---|---|---|
| GRAPHICS_ADJUSTMENTS:ANTIALIASING:QUALITY | — | ULTRA | ULTRA | ULTRA | ULTRA | از Medium به بالا AA ارتقایافته |
| GRAPHICS_ADJUSTMENTS:LODS:TRACK_DISTANCE_MULT | 2 | 2 | 2 | 2 | 1.99 | تقریباً یکسان |
| GRAPHICS_ADJUSTMENTS:LODS:CARS/TREES_DISTANCE_MULT | — | — | — | — | 1.15/1.95 | فقط Ultra فاصله‌ی LOD را زیاد می‌کند |
| GRAPHICS_ADJUSTMENTS:RENDER_SCALE:SCALE | — | — | — | — | **1.5** | فقط Ultra سوپرسمپلینگ |
| GRAPHICS_ADJUSTMENTS:RENDER_SCALE:SCREENSHOTS_SCALE | — | — | — | 1.3 | 2 | اسکرین‌شات |
| EXTRA_FX:MOTION_BLUR:MULT | 0.75 | 0.7 | 0.7 | 0.45 | 0.42 | شدت موشن‌بلور کم می‌شود (طبیعی: FPS بالاتر → بلور کمتر) |
| EXTRA_FX:MOTION_BLUR:QUALITY_2 | — | — | 2 | 2 | 2 | کیفیت از High |
| EXTRA_FX:MOTION_BLUR:JITTER_MULT | 0 | 0 | 0 | 0 | 0.01 | فقط Ultra جیتر |
| EXTRA_FX:SSLR:STEPS_HIZ | 100 | 100 | 200 | 200 | 300 | گام ردیابی انعکاس |
| EXTRA_FX:SSLR:TRACING_QUALITY3 | 1 | — | 4 | 4 | 4 | کیفیت ردیابی |
| EXTRA_FX:SSLR:SCALE | — | 0.95 | — | — | — | فقط Medium صریح (عجیب) |
| EXTRA_FX:SS_LIGHTING:SCALE | — | 0.9 | — | — | — | **فقط Medium** — سکشن سرگردان ⚠️ |
| EXTRA_FX:HBAO:OPACITY | 0.4 | 0.65 | 0.6 | 0.6 | 1.0 | شدت HBAO |
| EXTRA_FX:ASSAO:OPACITY/QUALITY | 0.7/— | — | — | — | 0.6/3 | فقط Low و Ultra صریح |
| EXTRA_FX:VOLUMETRIC_LIGHTS:SCALE | 0.15 | 0.185 | 0.26 | 0.276 | 0.32 | نور حجمی |
| EXTRA_FX:VOLUMETRIC_LIGHTS:INTENSITY_MULT | — | — | — | 1.6 | 2 | |
| EXTRA_FX:TAA:EXTRA_SHARPEN_PASS | 0 | 0 | 0 | 0 | 0.05 | شارپنس TAA فقط Ultra |
| EXTRA_FX:FOG_BLUR:DISTANCE_MULT | — | — | — | — | 1.45 | بی‌اثر (FOG_BLUR خاموش) |
| LIGHTING_FX:SHADOWS:CARS_SHADOWS | 1 | — | — | — | 3 | سایه‌ی خودرو |
| LIGHTING_FX:SHADOWS:FULL_RESOLUTION | 0 | — | — | — | — | فقط Low صریح (خاموش) |
| LIGHTING_FX:SHADOWS:HIGH_QUALITY_HEADLIGHT_SHADOWS | — | — | 1 | 1 | 1 | از High به بالا |
| LIGHTING_FX:SHADOWS:DETAILED/SPECTATING | — | — | — | — | 2/5 | فقط Ultra |
| LIGHTING_FX:PERFORMANCE:CARS_WITH_LIGHTS / REARVIEWMIRROR | — | — | — | 15/2 | 15/2 | از VeryHigh |
| PARTICLES_FX:SPARKS:SPAWN_RATE | 500 | — | 2000 | 2000 | 2000 | |
| PARTICLES_FX:SMOKE:HEATING_EXTRA | — | — | — | — | 0.05 | فقط Ultra |
| PARTICLES_FX:TRACES:LIMIT/MULT_BRAKES | — | — | — | — | 9000/40 | فقط Ultra |
| PARTICLES_FX:FIREWORKS:LIMIT/LIMIT_SMOKE | 20000/500 | — | — | — | — | فقط Low صریح ⚠️ |
| REFLECTIONS_FX:MAIN_CUBEMAP:RESOLUTION2 | — | 1024 | 2048 | 2048 | 2048 | انعکاس اصلی |
| WEATHER_FX:PERFORMANCE:DETAILED_CLOUD_SHADOWS | 0 | 0 | — | — | 0 | همه خاموش (در عمل) |
| WEATHER_FX:STATIC_REFLECTIONS:REFRESH_FACE_DELAY | — | — | — | — | 0.5 | فقط Ultra |
| WEATHER_FX:MISCELLANEOUS:FORCE_HEADLIGHTS | — | — | — | — | 1 | فقط Ultra |
| RAIN_FX:VISUAL_TWEAKS:RAIN_MAPS_QUALITY | **2** | — | 0 | 0 | 0 | ⚠️ ناهماهنگ (Low=2، بقیه=0) |
| GRASS_FX:BASIC:QUALITY | — | — | 3 | 4 | 4 | چمن |
| GRASS_FX:RENDERING:CAST_SHADOWS / EXTRAFX_PASS | —/— | 1/— | 1/1 | 1/1 | 1/1 | سایه‌ی چمن |
| GUI:NEW_UI:UI_SCALE | — | — | — | — | 1.5 | فقط Ultra ⚠️ |

**الگوهای قابل توجه:**
1. پلکانی‌بودن منطقی در اکثر افکت‌ها ✅
2. چند «سکشن سرگردان» (فقط در یک پریست): `EXTRA_FX:SS_LIGHTING` (فقط Medium)، `PARTICLES_FX:TRACES` (فقط Ultra)، `PARTICLES_FX:FIREWORKS` (Low/Ultra) — نشانه‌ی ویرایش دستی سازنده است، نه باگ بحرانی.
3. `RAIN_MAPS_QUALITY` در Low برابر ۲ و در High/Ultra برابر ۰ است — احتمالاً وارونگی/باقی‌مانده‌ی اشتباه. باید در همه یکسان باشد.

---

<a id="d"></a>
## D. تحلیل عمیق پریست‌های ویدیویی (`.cmpreset`)

### D1. ساختار

هر `.cmpreset` یک JSON است با سه بخش: `VideoData` (video.ini)، `GraphicsData` (graphics.ini)، `OculusData` (oculus.ini). این دقیقاً ساختار پریست ویدیوی Content Manager است.

### D2. جدول کامل مقایسه

| پارامتر | Low | Medium | High | VeryHigh | Ultra |
|---|---|---|---|---|---|
| WORLD_DETAIL | 1 | 2 | 3 | 4 | 5 (حداکثر) |
| SHADOW_MAP_SIZE | 512 | 1024 | 2048 | 2048 | 4096 |
| AASAMPLES (MSAA) | 2 | 4 | 4 | 4 | 8 |
| **AAQUALITY** | 0 | 0 | 0 | 0 | **غایب ⚠️** |
| ANISOTROPIC | 4 | 8 | 8 | 16 | 16 |
| CUBEMAP SIZE | 512 | 1024 | 1024 | 1024 | 2048 |
| CUBEMAP FACES_PER_FRAME | 2 | 2 | 2 | 4 | 6 |
| CUBEMAP FARPLANE | 810 | 990 | 2500 | 2400 | 2400 |
| MIRROR SIZE | 1024 | 1024 | 1024 | 1024 | 2048 |
| MIRROR HQ | 0 | 1 | 1 | 1 | 1 |
| POST_PROCESS QUALITY | 2 | 2 | 3 | 4 | 5 |
| POST_PROCESS GLARE | 1 | 2 | 3 | 4 | 5 |
| POST_PROCESS DOF | 2 | 2 | 3 | 4 | 5 |
| SMOKE | 2 | 3 | 3 | 3 | 5 |
| REFRESH | 60 | 60 | 90 | 90 | 120 |
| **FPS_CAP_MS** | 0 | 0 | 0 | 0 | **16.67 (=۶۰fps) ⚠️** |
| VSYNC | 0 | 0 | 0 | 0 | 0 |
| **DISABLE_LEGACY_HDR** | **1** | **1** | **1** | **1** | **غایب ❌** |
| SKYBOX_REFLECTION_GAIN | 1 | 1 | 2 | 2 | 3 |
| **MAXIMUM_FRAME_LATENCY** | 0 | 0 | 0 | 0 | **6 ⚠️** |
| MIP_LOD_BIAS | 0 | 0 | 0 | 0 | 0 |
| PIXEL_PER_DISPLAY (VR) | 1 | 1 | 1 | 1 | **2.5 ⚠️** |
| `_EXT_PLACEMENT` | — | — | — | — | **دارد ⚠️** |

مقادیر مشترک: `FULLSCREEN=1`، `FILTER=NFS 2015 Edited By Uhm`، `SATURATION=100`، `HEAT_SHIMMER=1`، `RAYS_OF_GOD=1`، `RENDER_SMOKE_IN_MIRROR=1`، `DISABLE_LEGACY_HDR=1` (به‌جز Ultra)، `SHADOW_MAP_BIAS_0/1/2` استاندارد، `ALLOW_UNSUPPORTED_DX10=0`.

### D3. یافته‌های کلیدی پریست ویدیو

1. **❌ Ultra فاقد `DISABLE_LEGACY_HDR=1` است** — در حالی که CSP روی **Pure LCS** تنظیم شده. با فعال‌ماندن HDR قدیمی، تصویر زیر LCS دچار نوردهی مضاعف/رنگ شسته می‌شود. این جدی‌ترین ناسازگاری داخلی مجموعه است.
2. **⚠️ Ultra فاقد `AAQUALITY=0` و `[EFFECTS] FXAA=0`** — دو مورد کوچک‌تر؛ احتمالاً به پیش‌فرض‌ها برمی‌گردد اما برای یکدستی بهتر است اضافه شوند.
3. **⚠️ `FPS_CAP_MS=16.67` در Ultra** = محدودیت ۶۰ فریم روی پریستی که رفرش ۱۲۰ دارد — تناقض آشکار؛ احتمالاً اشتباه در ذخیره.
4. **⚠️ `MAXIMUM_FRAME_LATENCY=6` در Ultra** = صف ۶ فریمی GPU → تاخیر ورودی بالا، بد برای سیم‌ریسینگ.
5. **🟢 `_EXT_PLACEMENT` در Ultra** = اطلاعات جای‌گذاری پنجره/چندمانیتوره که CM هنگام ذخیره ثبت کرده (نشانه‌ی سیستم چندمانیتوره‌ی سازنده). روی سیستم شما بی‌اثر/قابل حذف است.

---

<a id="e"></a>
## E. تحلیل عمیق کانفیگ‌های PURE

### E1. ساختار

فرمت اپ **Pure Config** (پوشه‌ی `extension/config-ext/Pure`). شامل `[DATE]` (مهر زمانی ذخیره — فاقد اثر عملکردی) و `[PureConfig]` (تمام پارامترها). هر دو فایل ساختار یکسان دارند.

### E2. جدول گروه‌های پارامتر (هر دو کانفیگ)

| گروه | معنی | مقدار مشترک |
|---|---|---|
| `light.*` | نور خورشید/آسمان/محیط | `daylight_multiplier=0.76`، `ambient_model_V2=true`، تمام `advanced_ambient_lightV2_*` فعال (خورشید/اسکای‌دام/آسمان/ابر/NLP/مه) |
| `shadows.presence` | حضور سایه‌ها | 0.966 |
| `csp_lights.*` | نور برگشتی/انتشار/نمایشگرها | bounce/emissive/displays (در دو کانفیگ متفاوت — جدول E3) |
| `reflections.*` | انعکاس‌ها | saturation=0.712، + sky.* |
| `vao.*` | Ambient Occlusion | amount/track_exponent/dynamic_exponent |
| `nlp.*` | نور آسمان شب (Night Light Pollution) | level=1, density=1 |
| `moon.*` / `stars.*` | ماه و ستاره‌ها | `moon.no_shadows=true`، `stars.appearance=14.42`، `stars.dynamic_adaption=false` |
| `camera.occlusion_control.*` | اکسپوژر خودکار دوربین | adv_ambi_light=false، adv_fog_ambi_light=true، exposure=true، overcast=true، vao=true |
| `sky.sun_disk.*` / `sun.sun_moon_size` | قرص خورشید و اندازه‌ی آن | در دو کانفیگ متفاوت |
| `fog.cubemaps` | مه در انعکاس | 1 |
| `clouds_render.*` | رندر ابر | method=1، quality=0.85، advanced_lighting=true، distance=1 |
| `clouds2D.*` | ابرهای ۲بعدی اسکای‌باکس | `set=default_16k` ⚠️، `quality=3`، `advanced_shadows=true`، `wind_oscillation=1` |
| `clouds_raymarching.*` | **ابرهای حجمی ۳بعدی** | `clouds=true`، `shadows=true`، `resolution=0.5`، `perf_fast/detail/variSteps=true`، `samplesLight=6` |
| `weather.*` | برف/خاکستر/آنلاین | snow.size=1، ash.size=1، add_online_properties=true |
| `ppoff.brightness` | روشنایی بدون PP | 1 |
| `sound.*` | باد/باران/رعد | wind_volume_interior=0.63، rain_volume_interior=0.853 و... (در هر دو **یکسان**) |
| `debug.*` / `optimization.cpu_split` | دیباگ / توزیع CPU | false / true |
| `shaders.groundfog` | مه زمینی | active=true، Quality=4، error=true ⚠️ |
| `shaders.landscape` | منظره | active=true، only_skyshader=true |
| `shaders.lightning` | رعدوبرق | active=true، speed=0.3، probability_multiplier=1 |
| `shaders.rainhaze` | هاله‌ی باران | active=true |
| `shaders.sunblinding` | خیره‌شدن خورشید | **active=false** (خاموش) |

### E3. ۲۰ تفاوت عددی دقیق (Realistic در برابر Simple)

| پارامتر | Realistic | Simple | تفسیر |
|---|---|---|---|
| `light.sun.level` | 0.904 | 1 | خورشید کمی ملایم‌تر |
| `light.sun.saturation` | 0.95 | 1 | |
| `light.sun.speculars` | 1.673 | 1 | براقیت خورشید بیشتر |
| `light.sky.level` | 1.385 | 1 | آسمان روشن‌تر |
| `csp_lights.bounce` | 1.826 | 1.442 | نور برگشتی قوی‌تر |
| `csp_lights.emissive` | 1.731 | 1.432 | چراغ‌ها درخشان‌تر |
| `reflections.level` | 1.979 | 1.403 | انعکاس قوی‌تر |
| `reflections.emissive_boost` | 5.481 | 4.039 | چراغ‌ها در انعکاس |
| `reflections.sky.luminance` | 4.475 | 8.885 | انعکاس آسمان تیره‌تر (دراماتیک‌تر) |
| `reflections.sky.gamma` | 3.991 | 2.933 | گامای انعکاس آسمان |
| `vao.amount` | 0.894 | 1 | AO کمی ملایم‌تر |
| `vao.track_exponent` | 0.404 | 0.5 | |
| `nlp.lowest_ambient` | 1.433 | 1 | شب روشن‌تر |
| `sky.sun_disk.level` | **0.014** | 1 | **تفاوت بزرگ** — قرص خورشید تقریباً محو (مقدار مناسب LCS) |
| `sun.sun_moon_size` | 4.952 | 3.173 | قرص خورشید/ماه بزرگ‌تر |
| `clouds2D.brightness` | 0.327 | 1.25 | ابرهای ۲بعدی تیره‌تر/کنتراست‌تر |
| `clouds2D.contrast` | 2.058 | 2.057 | (تقریباً یکسان) |
| `clouds2D.crossfade_time` | 30.21 | 30 | (تقریباً یکسان) |
| `clouds_render.shadows_blur` | 0.356 | 0 | سایه‌ی ابر نرم‌تر |

**تحلیل:** «Realistic» یک کانفیگ دراماتیک/سینمایی و **هماهنگ با LCS** است (شاهد: `sky.sun_disk.level=0.014` که در فضای خطی، خورشید فیزیکی-درخشان را از دیسک مجزا می‌کند). «Simple» به پیش‌فرض PURE نزدیک‌تر و متعادل‌تر است (`sun_disk.level=1` حال‌وهوای Gamma). **اگر CSP روی LCS است (که هست)، کانفیگ Realistic سازگارتر است؛ Simple برای حالت Gamma مناسب‌تر است.**

---

<a id="f"></a>
## F. تحلیل عمیق PPFilter (`UhmFilter.ini`)

**هویت:** `AUTHOR=Vatsky`, `CSP_EDITOR=3749`, `VERSION=1.2` → فیلتر NFS 2015 (نسخه‌ی ویرایش‌شده با ویرایشگر CSP).

| سکشن / کلید | مقدار | معنی | وضعیت |
|---|---|---|---|
| `[ABOUT]` | CSP_EDITOR=3749 | ذخیره‌شده با ویرایشگر CSP (نسخه‌ی قدیمی ~0.1.7x) | 🟢 |
| `[YEBIS] ENABLED=1` | — | موتور پست‌پراسس روشن | ✅ |
| `[OPTIMIZATIONS] FIXED_WIDTH=1280` | — | رندر افکت‌ها با بافر ۱۲۸۰ (کم‌هزینه) | ✅ |
| `[AUTO_EXPOSURE]` | MIN=0.25, MAX=0.6, TARGET=0.30, DELAY=0.1 | اکسپوژر خودکار با هدف ۰.۳۰ (کمی تیره/سینمایی) | ✅ |
| `[EXT_AUTO_EXPOSURE] METERING_AREA_SIZE=0.9,0.52` | — | ناحیه‌ی نورسنجی مرکز-پایین | ✅ |
| `[COLOR]` | BRIGHTNESS=1.7, SATURATION=0.85, HUE=0.1, SEPIA=0.15, COLOR_TEMP=6500, WHITE_BALANCE=6250 | رنگ گرم/سینمایی | ✅ |
| `[TONEMAPPING]` | EXPOSURE=0.3, GAMMA=1.35, FUNCTION=2, HDR=1, MAPPING_FACTOR=32 | تون‌مپ (FUNCTION=2 = منحنی LogLu) | ✅ |
| `[EXT_HDR] FILMIC_CONTRAST=0.7` | — | کنتراست فیلمی | ✅ |
| `[GLARE]` | ENABLED=1, QUALITY=8, LUMINANCE=3, THRESHOLD=0.3, USE_CUSTOM_SHAPE=1, GHOST=1, SHAPE_STAR_LENGTH=0.21, SHAPE_BLOOM_LUMINANCE=0.07 | بلوم/لنزفلر سفارشی با هاله و ستاره‌ی ۷پر | ✅ (امضای NFS) |
| `[DOF]` | ENABLED=1, QUALITY=7, F_NUMBER=16, BASE_FOV=75 | عمق میدان با دیافراگم f/16 | ⚠️ سلیقه‌ای |
| `[GODRAYS]` | ENABLED=1, LENGTH=10, GLARE_RATIO=0.3, DIFFRACTION_RING=0.15 | اشعه‌ی خورشید + حلقه‌ی دیفراکشن | ✅ |
| `[CHROMATIC_ABERRATION]` | ENABLED=0 | انحراف رنگی خاموش | ✅ |
| `[VIGNETTING]` | STRENGTH=0.6, FOV_DEPENDENCE=0 | وینیت ثابت ۰.۶ | ✅ |
| `[HEAT_SHIMMER]` | ENABLED=1 | موج گرما | ✅ |
| `[LENSDISTORTION]` | ENABLED=0 | اعوجاج لنز خاموش | ✅ |
| `[DIAPHRAGM]` | TYPE=2, ROTATE_OFFSET=10 | شکل دیافراگم | ✅ |
| `[AIRYDISC]` | ENABLED=1, WAVELENGTH=499 | پراش نور | ✅ |
| `[ANTIALIAS]` | ENABLED=1, START_DISTANCE=0.1, END_DISTANCE=1000 | AA فیلتر | ✅ |
| `[FEEDBACK]` | ENABLED=0 | بازخورد تصویر خاموش | ✅ |
| `[EXT_COLOR_GRADING]` | ENABLED=1, FILE=`\extension\textures\color_grading\NFS2015W.png`, STRENGTH=0.6 | **LUT گرم NFS 2015 با شدت ۰.۶** — امضای اصلی فیلتر | ⚠️ فایل LUT باید موجود باشد |
| `[EXT_GLARE]` | ANAMORPHIC_PARAM_0/1 | لنزفلر آنامورفیک | ✅ |

**دو نکته‌ی فنی:**
1. `CSP_EDITOR=3749` یعنی فیلتر با CSP حدود 0.1.7x ساخته شده (دوران Sol/Gamma). این فیلتر **اسکریپت LCS ندارد** → احتمال زیاد **فقط برای Pure Gamma** درست کار می‌کند (بخش G).
2. `FILE='\extension\...\NFS2015W.png'` — اگر این LUT در سیستم موجود نباشد، Color Grading بی‌صدا اعمال نمی‌شود و «حال‌وهوای NFS» از بین می‌رود.

---

<a id="g"></a>
## G. ماتریس سازگاری و ناسازگاری‌های زنجیره

| لایه | وضعیت در این مجموعه | سازگاری |
|---|---|---|
| CSP WeatherFX | **Pure LCS** (رمزگشایی: `LINEAR_COLOR_SPACE ENABLED=1`) | — |
| Video: `DISABLE_LEGACY_HDR` | Low/Med/High/VHigh = 1 ✅ · **Ultra = غایب ❌** | با LCS فقط وقتی `DISABLE_LEGACY_HDR=1` باشد درست است |
| PPFilter NFS 2015 | فیلتر ۲۰۲۱ (CSP_EDITOR=3749) — احتمالاً **Gamma-era** | ⚠️ احتمال ناسازگاری با LCS |
| Pure Config | «Realistic» هماهنگ با LCS · «Simple» نزدیک به Gamma | ⚠️ باید با سبک انتخابی هماهنگ شود |
| FILTER نام | پریست‌ها می‌گویند `NFS 2015 Edited By Uhm` · فایل `UhmFilter.ini` | ❌ نام منطبق نیست → فیلتر لود نمی‌شود |

**نتیجه‌ی اصلی:** این مجموعه یک «سیستم LCS» است که دو نقطه‌ی شکست دارد: (۱) پریست ویدیوی Ultra که HDR قدیمی را خاموش نمی‌کند، و (۲) فیلتر NFS 2015 که احتمالاً برای Gamma ساخته شده. طبق منابع جامعه، «فیلتر بدون اسکریپت LCS زیر حالت LCS افتضاح دیده می‌شود». بنابراین **دو مسیر درست وجود دارد:**

- **مسیر A (پیشنهادی برای حداکثر سازگاری):** همه‌چیز را روی **Pure Gamma** ببرید → در CSP WeatherFX سبک Gamma را انتخاب کنید (یا `LINEAR_COLOR_SPACE ENABLED=0`)، کانفیگ «Simple» را لود کنید، و فیلتر NFS 2015 را نگه دارید.
- **مسیر B (کیفیت LCS):** روی LCS بمانید، ولی فیلتر را به یک فیلتر **سازگار با LCS** (مثل Pure Linear یا C13 Aegis نسخه‌ی LCS) تغییر دهید و `DISABLE_LEGACY_HDR=1` را به پریست Ultra اضافه کنید.

---

<a id="h"></a>
## H. جدول نهایی یافته‌ها — اولویت و راه‌حل دقیق

| # | شدت | یافته | فایل‌(ها) | راه‌حل دقیق |
|---|---|---|---|---|
| 1 | 🔴 | نام فیلتر در پریست‌ها (`NFS 2015 Edited By Uhm`) با نام فایل (`UhmFilter.ini`) نمی‌خواند → فیلتر لود نمی‌شود | هر ۵ `.cmpreset` + `UhmFilter.ini` | نام فایل را به `NFS 2015 Edited By Uhm.ini` تغییر دهید **یا** در همه‌ی پریست‌ها `FILTER=UhmFilter` کنید |
| 2 | 🔴 | پریست ویدیوی Ultra فاقد `DISABLE_LEGACY_HDR=1` است → با Pure LCS نوردهی مضاعف | `video{Ultra}.cmpreset` | در `[VIDEO]` مقدار `DISABLE_LEGACY_HDR=1` اضافه کنید |
| 3 | 🟠 | `FILE_OP_HOOK=C:/Users/illvd/...cspdecryptexample.dll` (هوک محلی سازنده) | هر ۵ پریست CSP | حذف کامل خط `FILE_OP_HOOK` (در CSP → General → پاک‌کردن هوک) |
| 4 | 🟠 | CSP روی **Pure LCS** است ولی فیلتر NFS 2015 احتمالاً Gamma-era | CSP + PPFilter | مسیر A یا B از بخش G |
| 5 | 🟠 | `RENDER_SCALE SCALE=1.5` در پریست CSP Ultra (سوپرسمپلینگ ۱۵۰٪ + ناسازگار با Fullscreen) | `CSP{Ultra}.ini` | برای رانندگی: `SCALE=1` (و `SCREENSHOTS_SCALE` را فقط برای عکس نگه دارید) |
| 6 | 🟠 | `MAXIMUM_FRAME_LATENCY=6` در ویدیوی Ultra (تاخیر ورودی) | `video{Ultra}.cmpreset` | `MAXIMUM_FRAME_LATENCY=0` یا `1` |
| 7 | 🟠 | `FPS_CAP_MS=16.67` (۶۰fps) در حالی که REFRESH=120 | `video{Ultra}.cmpreset` | `FPS_CAP_MS=0` (یا 8.33 برای ۱۲۰fps) |
| 8 | 🟡 | `SELECT_ADAPTER=NVIDIA?` (مقدار مشکوک با «?») | هر ۵ پریست CSP | اگر GPU شما NVIDIA است بگذارید `NVIDIA`؛ وگرنه حذف کنید |
| 9 | 🟡 | SSGI + HBAO + SSLR حتی در «Low» فعال‌اند → Low واقعاً سبک نیست | هر ۵ پریست CSP | برای سیستم ضعیف: SSGI و SSLR را در Low خاموش کنید |
| 10 | 🟡 | `clouds2D.set=default_16k` نیازمند PURE Highres | هر ۲ کانفیگ PURE | با Lowres: `default_8k` یا `default_4k` |
| 11 | 🟡 | `RAIN_FX RAIN_MAPS_QUALITY` در Low=2 و بقیه=0 (وارونگی محتمل) | پریست CSP Low | یکسان‌سازی با بقیه (0) |
| 12 | 🟡 | سکشن‌های سرگردان: `SS_LIGHTING` فقط در Medium، `TRACES` فقط در Ultra، `FIREWORKS` در Low/Ultra | پریست‌های CSP | بی‌خطر؛ در صورت وسواس، پاک‌سازی |
| 13 | 🟡 | `GUI:NEW_UI UI_SCALE=1.5` فقط در Ultra (UI بین پریست‌ها متفاوت می‌شود) | پریست CSP Ultra | در صورت تمایل به بقیه هم اضافه یا حذف کنید |
| 14 | 🟡 | `sky.sun_disk.level` در دو کانفیگ PURE متفاوت (0.014 در برابر 1) | هر ۲ کانفیگ | Realistic برای LCS، Simple برای Gamma |
| 15 | 🟡 | پریست ویدیوی Ultra فاقد `AAQUALITY=0` و `[EFFECTS] FXAA=0` | `video{Ultra}.cmpreset` | برای یکدستی اضافه کنید |
| 16 | 🟡 | `shaders.groundfog.error=true` (پرچم خطای ذخیره‌شده) | هر ۲ کانفیگ PURE | بی‌خطر؛ مه زمینی نیازمند Track Adaptation |
| 17 | 🟢 | `PIXEL_PER_DISPLAY=2.5` در ویدیوی Ultra (سوپرسمپلینگ سنگین VR) | `video{Ultra}.cmpreset` | فقط اگر VR ندارید بی‌اثر است؛ برای ریفت 1–1.5 |
| 18 | 🟢 | `_EXT_PLACEMENT` (جای‌گذاری پنجره از سیستم چندمانیتوره‌ی سازنده) | `video{Ultra}.cmpreset` | قابل حذف |
| 19 | 🟢 | اسکریپت head-physics ذخیره شده ولی `NECK:SCRIPT ENABLED=0` | پریست‌های CSP | برای فعال‌کردن تکان سر: ENABLED=1 |
| 20 | 🟢 | `[DATE]` در کانفیگ‌های PURE = مهر زمانی ذخیره | هر ۲ کانفیگ | بی‌اثر |

---

<a id="i"></a>
## I. دستورالعمل اصلاح (مقادیر دقیق)

**۱. هماهنگ‌کردن نام فیلتر (راه‌حل شماره ۱):**
```
گزینه‌ی ساده‌تر:  نام فایل را تغییر دهید
  assettocorsa/system/cfg/ppfilters/UhmFilter.ini
      →  assettocorsa/system/cfg/ppfilters/NFS 2015 Edited By Uhm.ini
```

**۲. اصلاح پریست ویدیوی Ultra (`video{Ultra}.cmpreset`) — داخل `[VIDEO]`:**
```
DISABLE_LEGACY_HDR=1        ← اضافه شود (حیاتی)
AAQUALITY=0                 ← اضافه شود
FPS_CAP_MS=0                ← به‌جای 16.6666666666667
MAXIMUM_FRAME_LATENCY=0     ← در [DX11] به‌جای 6
```
و در `[EFFECTS]`: `FXAA=0` اضافه شود.

**۳. پاک‌کردن هوک در هر ۵ پریست CSP:**
```
حذف خط:  FILE_OP_HOOK=C:/Users/illvd/source/repos/...cspdecryptexample.dll,FileOpHook
```

**۴. سبک‌کردن پریست CSP Ultra برای رانندگی:**
```
[GRAPHICS_ADJUSTMENTS:RENDER_SCALE]
SCALE=1            ← به‌جای 1.5
```

**۵. تصمیم LCS یا Gamma (راه‌حل شماره ۴):**
- **Gamma (ساده‌تر و سازگار با فیلتر فعلی):** در CM → CSP → Weather FX → Weather Style را `Pure Gamma` کنید؛ در بازی کانفیگ `Uhm PureConfig-Simple` را لود کنید.
- **LCS (کیفیت بالاتر):** فیلتر را به فیلتر LCS-سازگار تغییر دهید؛ کانفیگ `Uhm Config-Realistic` را لود کنید؛ حتماً مورد ۲ (DISABLE_LEGACY_HDR) را اصلاح کنید.

---

*پایان تحلیل. این سند بر اساس پارس کامل ۱۴ فایل + رمزگشایی بلوک‌های Base64 + مقایسه‌ی ۵‌گانه + اعتبارسنجی در برابر منابع AC/CSP/PURE تهیه شده است.*
