# تحقیق جامع: گرافیک Assetto Corsa، تنظیمات ویدیویی CSP و کانفیگ PURE

> سند تحقیق + تحلیل کامل فایل‌های موجود در پروژه `shat`
> تاریخ تهیه: ۱۳ سپتامبر ۲۰۲۶

---

## فهرست

1. [مقدمه: زنجیره‌ی گرافیکی Assetto Corsa](#1-مقدمه)
2. [لایه‌ی ۱ — تنظیمات ویدیویی Assetto Corsa (Video Settings)](#2-تنظیمات-ویدیویی)
3. [لایه‌ی ۲ — Custom Shaders Patch (CSP)](#3-csp)
4. [لایه‌ی ۳ — PURE و فایل Pure Config](#4-pure)
5. [لایه‌ی ۴ — PPFilter (فیلتر پست‌پراسس)](#5-ppfilter)
6. [تحلیل کامل فایل‌های پروژه](#6-تحلیل-فایل‌ها)
7. [هشدارها و مشکلات یافت‌شده](#7-هشدارها)
8. [راهنمای نصب فایل‌ها](#8-راهنمای-نصب)
9. [منابع](#9-منابع)

---

<a id="1-مقدمه"></a>
## ۱. مقدمه: زنجیره‌ی گرافیکی Assetto Corsa

Assetto Corsa (بازی سال ۲۰۱۴ از استودیو Kunos Simulazioni) با موتور اختصاصی خودش و **DirectX 11** ساخته شده و گرافیک پایه‌ی آن نسبت به استانداردهای امروز قدیمی است. چیزی که این بازی را در سال ۲۰۲۶ همچنان از نظر بصری رقابتی نگه می‌دارد، یک **زنجیره‌ی چندلایه از مادهای گرافیکی** است که هر لایه روی لایه‌ی قبلی سوار می‌شود:

```
[۱] Assetto Corsa (موتور پایه، DX11)
        │
[۲] Content Manager (CM) — لانچر و مدیر ماد (ساخته‌ی x4fab)
        │
[۳] Custom Shaders Patch (CSP) — وصله‌ی گرافیکی/فیزیکی (ساخته‌ی Ilja "x4fab" Jusupov)
        │
[۴] Weather FX = سیستم آب‌وهوا → SOL (منسوخ) یا PURE (ساخته‌ی Peter Boese)
        │
[۵] PPFilter — فیلتر پست‌پراسس (YEBIS) → رنگ‌بندی نهایی تصویر
```

| لایه | وظیفه | مثال در پروژه‌ی شما |
|---|---|---|
| **Video Settings** | رزولوشن، MSAA، سایه‌ها، آینه‌ها، کیفیت پست‌پراسس | ۵ فایل `.cmpreset` |
| **CSP** | افکت‌های پیشرفته: SSAO/SSLR/SSGI، نورپردازی داینامیک، ذرات، چمن، باران، آینه‌ی واقعی | ۵ فایل `.ini` پریست |
| **PURE** | آب‌وهوا، آسمان، ابرهای حجمی، نور خورشید/ماه، چرخه‌ی شبانه‌روز | ۲ فایل کانفیگ PURE |
| **PPFilter** | رنگ نهایی، اکسپوژر، Bloom/Glare، تون‌مپینگ، وینیت | `UhmFilter.ini` |

نکته‌ی کلیدی: این چهار لایه **باید با هم هماهنگ باشند**. مثلاً فیلتر NFS 2015 که در این پروژه استفاده شده، برای کار با PURE باید از مسیر صحیح (Weather Style) فعال شود، وگرنه تصویر «شسته‌شده» یا «بیش از حد اشباع» دیده می‌شود (در ادامه توضیح داده می‌شود).

---

<a id="2-تنظیمات-ویدیویی"></a>
## ۲. لایه‌ی ۱ — تنظیمات ویدیویی Assetto Corsa (Video Settings)

### ۲.۱ فایل‌ها و ساختار

تنظیمات ویدیویی بازی در چند فایل INI در پوشه‌ی `Documents/Assetto Corsa/cfg` ذخیره می‌شود:
- `video.ini` — تنظیمات اصلی ویدیو
- `graphics.ini` — تنظیمات DX11 و بایاس سایه‌ها
- `oculus.ini` — تنظیمات VR (ریفت)

فرمت **`.cmpreset`** که در پروژه‌ی شما وجود دارد، **پریست ذخیره‌شده توسط Content Manager** است؛ یک فایل JSON که هر سه INI را داخل خودش نگه می‌دارد (`VideoData`, `GraphicsData`, `OculusData`). با انتخاب پریست در CM، این سه بخش روی همان سه INI اعمال می‌شوند.

### ۲.۲ معنی تک‌تک پارامترها (راهنمای حرفه‌ای)

| پارامتر (سکشن) | معنی و اثر | توصیه‌ی عمومی |
|---|---|---|
| `WORLD_DETAIL` (1–5) | جزئیات دنیا: اشیای کنار پیست، جمعیت تماشاگران. ۵ = Maximum | گران‌ترین آیتم پس از انعکاس‌ها؛ در سرعت بالا تفاوت کمی دیده می‌شود |
| `AASAMPLES` | تعداد نمونه‌های **MSAA** (2x / 4x / 8x). ضد دندانه‌ی هندسی | 4x نقطه‌ی تعادل؛ 8x فقط برای اسکرین‌شات |
| `AAQUALITY` | کیفیت حل MSAA (0 = بالاترین) | روی 0 نگه دارید |
| `ANISOTROPIC` | فیلتر ناهمسانگرد (4/8/16) برای بافت‌های مورب | 8–16؛ هزینه‌ی کم، سود زیاد |
| `SHADOW_MAP_SIZE` | رزولوشن نقشه‌ی سایه (512 تا 4096) | یکی از سنگین‌ترین آیتم‌ها؛ 1024–2048 متعادل |
| `[CUBEMAP] SIZE` | رزولوشن نقشه‌ی انعکاس بدنه‌ی خودرو (مکعب ۶ وجهی) | 1024 مناسب؛ 2048 فقط برای اسکرین‌شات |
| `[CUBEMAP] FACES_PER_FRAME` | چند وجه از مکعب انعکاس در هر فریم رندر شود (2/4/6). عدد کمتر = انعکاس با تاخیر ولی FPS بالاتر | 2 برای درایو؛ 6 برای کیفیت نهایی (پرهزینه‌ترین گزینه‌ی انعکاس) |
| `[CUBEMAP] FARPLANE` | فاصله‌ی رندر انعکاس (متر) | هرچه بیشتر = محیط دورتر هم در انعکاس دیده شود |
| `[MIRROR] SIZE` | رزولوشن آینه‌ها | 1024 خوب؛ 2048 سنگین |
| `[MIRROR] HQ` | آینه‌ی با کیفیت بالا (0/1) | 1 |
| `[POST_PROCESS] ENABLED` | فعال بودن پست‌پراسس (YEBIS) | حتماً 1 |
| `[POST_PROCESS] FILTER` | نام فیلتر PP فعال (بدون پسوند `.ini`) | **باید با نام فایل فیلتر یکی باشد** (هشدار در بخش ۷) |
| `[POST_PROCESS] QUALITY` | کیفیت کلی پست‌پراسس (1–5) | 3–5 |
| `[POST_PROCESS] GLARE` | کیفیت و شدت Glare/لنزفلر (1–5) | 3–5 |
| `[POST_PROCESS] DOF` | عمق میدان (1–5) | 0–2 (بسیاری آن را خاموش می‌کنند) |
| `[POST_PROCESS] FXAA` | ضد دندانه‌ی پست‌پراسس — **CSP روی همین سوییچ سوار می‌شود** | باید 1 بماند تا CSP بتواند آن را به SMAA/CAS ارتقا دهد |
| `[EFFECTS] FXAA` | FXAA قدیمی AC (سطح کیفیت) | 0 (در پریست‌ها 0 است؛ منطقی) |
| `[EFFECTS] SMOKE` | میزان تولید دود (1–5) | 3؛ با CSP Particles FX می‌توان دود نرم‌تر گرفت |
| `[EFFECTS] MOTION_BLUR` | موشن‌بلور بازی | 0 (موشن‌بلور CSP بهتر است) |
| `[EFFECTS] HEAT_SHIMMER` | موج گرمای هوا روی آسفالت | 1 |
| `[EFFECTS] RAYS_OF_GOD` | اشعه‌های خورشید (God Rays) | 1 |
| `[SATURATION] LEVEL` | اشباع رنگ | **۱۰۰** — رنگ را به PURE/فیلتر بسپارید |
| `[VIDEO] FULLSCREEN` | تمام‌صفحه | 1 (توجه: HDR و Render Scale با Fullscreen سازگار نیستند) |
| `[VIDEO] VSYNC` | همگام‌سازی عمودی | 0 (در AC معمولاً با FPS Cap جایگزین می‌شود) |
| `[VIDEO] FPS_CAP_MS` | محدودکننده‌ی فریم (میلی‌ثانیه)؛ 0 = بدون محدودیت | برای صفحه‌ی 120Hz مقدار 0 یا 8.3ms |
| `[VIDEO] REFRESH` | نرخ نوسازی مانیتور | = نرخ واقعی مانیتور |
| `[VIDEO] DISABLE_LEGACY_HDR` | غیرفعال کردن HDR قدیمی AC | **1 الزامی برای PURE** |
| `[DX11] MAXIMUM_FRAME_LATENCY` | تعداد فریم‌های صف GPU (0–6). عدد بیشتر = نرمی بیشتر ولی **تاخیر ورودی بیشتر** | 0 یا 1 برای سیم‌ریسینگ |
| `[DX11] MIP_LOD_BIAS` | بایاس LOD بافت‌ها (منفی = شارپ‌تر) | 0 |
| `[DX11] SHADOW_MAP_BIAS_0/1/2` | بایاس سایه برای رفع مصنوعات | دست نزنید (پیش‌فرض) |
| `[DX11] SKYBOX_REFLECTION_GAIN` | شدت انعکاس آسمان (skybox) در بدنه | 1–3 |
| `[SETTINGS] PIXEL_PER_DISPLAY` | سوپرسمپلینگ VR (ریفت) | 1–1.5؛ 2.5 بسیار سنگین |

---

<a id="3-csp"></a>
## ۳. لایه‌ی ۲ — Custom Shaders Patch (CSP)

### ۳.۱ معرفی

CSP ساخته‌ی **Ilja "x4fab" Jusupov** است و تقریباً همه‌ی جنبه‌ی گرافیکی بازی را بازنویسی می‌کند: سایه‌های بهتر، Ambient Occlusion، انعکاس‌های Screen-Space، نورپردازی داینامیک خودروها، ذرات نرم، چمن، باران و سیستم آب‌وهوای کاملاً جدید. بدون CSP، PURE اصلاً کار نمی‌کند؛ PURE در واقع یک «بسته‌ی محتوایی» است که به سیستم WeatherFX درون CSP وصل می‌شود.

- **دانلود/نصب:** از طریق Content Manager → Settings → Custom Shaders Patch → Install.
- **نسخه‌ها:** نسخه‌ی «recommended» قدیمی (0.1.79) است؛ برای PURE به نسخه‌های 0.2.x به بالا (و برای PURE 3.x به CSP 0.3 preview) نیاز دارید. در ۲۰۲۶ نسخه‌ی عمومی حدود 0.2.11 و پیش‌نمایش 0.3.0 است.

### ۳.۲ ماژول‌های گرافیکی مهم (بر اساس پریست‌های همین پروژه)

**General Patch Settings** — بهینه‌سازی‌ها:
- `OPTIMIZE_MESHES_MORE` (بهینه‌سازی مش‌ها)، `QUERY_BASED_MAPPING`، `SEPARATE_SHADOW_MESHES`، `UPGRADE_TEXTURES`، `USE_NEW_DDS_LOADER`، `BC7_CACHE` — همگی صرفاً کارایی را بهتر می‌کنند بدون افت کیفیت بصری.
- `MERGE_MESHES`، `FLATTEN_NODES`، `LIMIT_GENERAL/SHADOWS/SMOKE` — کاهش بار CPU.
- `ALLOW_TEARING=1` — اجازه‌ی پارگی تصویر برای کاهش تاخیر.

**Graphics Adjustments** — ریزتنظیم‌های بصری:
- `ANTIALIASING QUALITY=ULTRA` — ارتقای FXAA به SMAA/CAS؛ پیش‌نیاز: `FXAA` در تنظیمات ویدیو روشن باشد.
- `ADAPTIVE_CLIP_PLANES` — بهبود صفحات برش نزدیک/دور (رفع z-fighting).
- `LODS` (`CARS_DISTANCE_MULT`, `TRACK_DISTANCE_MULT`, `TREES_DISTANCE_MULT`) — فاصله‌ی تعویض LOD؛ عدد بالاتر = جزئیات دورتر می‌مانند ولی هزینه‌ی بیشتر.
- `FSR/DLSS` — آپ‌اسکیل AMD FSR یا NVIDIA DLSS (در پریست‌های این پروژه غیرفعال است: `QUALITY2=-1`).
- `RENDER_SCALE` — مقیاس رندر (بیش از ۱ = سوپرسمپلینگ؛ سازگار نبودن با Fullscreen).
- `SCRIPTABLE_FILTER IMPLEMENTATION=pure` — فیلتر اسکریپتی PURE (اتصال فیلتر به PURE).
- `SHADER_REPLACEMENTS` — تگ‌های PBR/آب/رنگ بدنه‌ی جدید.
- `VISIBLE_CARS` — تعداد خودروهای رندرشده در GBuffer/اصلی/سایه/آینه.

**Extra FX** — افکت‌های سنگین پیشرفته:
- `SSLR` (انعکاس‌های Screen-Space روی خیس‌ها و آسفالت) — `STEPS_HIZ/SIMPLE` کیفیت ردیابی.
- `SSAO / HBAO / ASSAO / SSGI` — سایه‌روشن محیطی و روشنایی غیرمستقیم.
- `TAA` — ضد دندانه‌ی زمانی.
- `MOTION_BLUR` — موشن‌بلور باکیفیت CSP.
- `VOLUMETRIC_LIGHTS` — نور حجمی (نور مه/چراغ‌ها در هوا).
- `FOG_BLUR`، `DEPTH_REDUCTION`.

**Lighting FX** — نورپردازی داینامیک:
- سایه‌ی خودروها (`CARS_SHADOWS`، `HIGH_QUALITY_HEADLIGHT_SHADOWS`)، نور برگشتی (`BOUNCED_LIGHT_MULT`)، بازتاب نور از بدنه.

**Particles FX** — ذرات نرم و سایه‌دار: دود (`SMOKE`)، جرقه (`SPARKS`)، شعله، سنگریزه (Marbles)، لکه‌ی روغن، قطره‌های شیشه (`WINDSCREEN`).

**Reflections FX** — بهبود انعکاس داخلی خودرو با ماسک سیلوئت داخلی + `MAIN_CUBEMAP RESOLUTION`.

**Smart Shadows** — تقسیم خودکار سایه‌ها (`AUTOMATIC_SPLITS_DISTANCE`).

**Weather FX** — قلب PURE:
- `BASIC IMPLEMENTATION=pure` و `CONTROLLER=pureCtrl static` → سبک آب‌وهوای PURE فعال است.

**سایر ماژول‌ها:** Smart Mirror (آینه‌ی واقعی)، Grass FX (چمن)، Skidmarks FX (لای ترمز)، Windscreen FX، Nice Screenshots (جمع‌آوری AA برای اسکرین‌شات بدون دندانه)، VR Tweaks.

---

<a id="4-pure"></a>
## ۴. لایه‌ی ۳ — PURE و فایل Pure Config

### ۴.۱ PURE چیست؟

PURE ساخته‌ی **Peter Boese** (همان سازنده‌ی SOL) است و عملاً جانشین رسمی SOL محسوب می‌شود. SOL در نسخه‌ی 2.2.9 متوقف شد، در حالی که PURE تا ۲۰۲۶ با نسخه‌ی 3.10+ فعالانه توسعه می‌یابد. PURE یک بازنویسی کامل است: آب‌وهوای داینامیک واقعی، چرخه‌ی کامل شبانه‌روز، باران واقعی (نه فقط ذره)، سایه‌رندر خطی (Linear Color Space) و ابرهای حجمی Raymarching.

- **دسترسی:** از Patreon پیتر بوزه (~۱.۵ دلار) یا Gumroad؛ دو نسخه‌ی **Highres** (بافت‌های آسمان 16k) و **Lowres** (برای سیستم‌های ضعیف).
- **نصب:** چهار پوشه‌ی `apps`, `content`, `extension`, `system` را در ریشه‌ی AC کپی کنید.

### ۴.۲ دو سبک آب‌وهوا: Pure LCS در برابر Pure Gamma

| | **Pure Gamma** | **Pure LCS** |
|---|---|---|
| فضای رنگی | Gamma | **Linear Color Space** |
| ظاهر | طبیعی، متعادل | جسورتر، دقیق‌تر از نظر فنی |
| کارایی | سبک‌تر | سنگین‌تر |
| سازگاری فیلتر | تقریباً همه‌ی PPFilter ها | فقط فیلترهای سازگار با LCS |
| توصیه | پیش‌فرض امن برای اکثر کاربران | برای حداکثر واقع‌گرایی |

پریست‌های CSP این پروژه روی `IMPLEMENTATION=pure` تنظیم شده‌اند؛ انتخاب دقیق «Gamma یا LCS» در منوی Quick Drive/Water FX انجام می‌شود.

### ۴.۳ اپ‌های PURE

- **Pure Config** — تنظیمات سراسری کیفیت و افکت‌ها + ذخیره/بارگذاری پریست (فایل‌های `.ini` بخش «Pure Config» این پروژه از همین اپ ذخیره شده‌اند).
- **Pure Planner** (Weather Planner) — تنظیم زنده‌ی آب‌وهوا و زمان شبانه‌روز.
- **Pure PP** — تنظیم زنده‌ی PPFilter.

### ۴.۴ راهنمای پارامترهای Pure Config.ini (بر اساس فایل‌های پروژه)

| گروه پارامتر | معنی |
|---|---|
| `light.sun.*` / `light.sky.*` / `light.ambient.*` | سطح/اشباع/هیو نور خورشید، آسمان و محیط؛ `daylight_multiplier` ضریب کلی نور روز |
| `light.advanced_ambient_lightV2_*` | مدل نور محیطی پیشرفته‌ی V2 (خورشید/آسمان/ابر/مه به تفکیک) |
| `shadows.presence` | شدت حضور سایه‌ها |
| `csp_lights.bounce/emissive/displays` | نور برگشتی، نور انتشار اجسام نورانی (چراغ‌ها، داشبورد) و نمایشگرها |
| `reflections.*` | اشباع/سطح انعکاس + `emissive_boost` (تقویت نور اجسام نورانی در انعکاس) + `reflections.sky.*` (روشنایی/گامای انعکاس آسمان) |
| `vao.amount / track_exponent / dynamic_exponent` | شدت Ambient Occlusion و رفتار آن روی پیست/آبجکت‌ها |
| `nlp.level / density / lowest_ambient` | نور مصنوعی آسمان شب (Night Light Pollution) — نور محیطی در شب |
| `moon.light / appearance / no_shadows` | نور و ظاهر ماه؛ `no_shadows=true` یعنی سایه‌ی ماه خاموش (سبک‌تر) |
| `stars.appearance` | میزان دیده‌شدن ستاره‌ها |
| `camera.occlusion_control.*` | کنترل خودکار اکسپوژر دوربین بر اساس نور محیط/ابر/VAO |
| `sky.sun_disk.*` | دیسک خورشید (سطح/اشباع)؛ `sun.sun_moon_size` اندازه‌ی قرص خورشید/ماه |
| `fog.cubemaps` | مه در انعکاس‌ها |
| `clouds_render.method` / `clouds.distance` / `clouds.quality` / `clouds.advanced_lighting` | روش و کیفیت رندر ابر |
| `clouds2D.*` | ابرهای ۲بعدی آسمان (اسکای‌باکس). `set=default_16k` یعنی بافت‌های 16k (نیازمند نسخه‌ی Highres). `advanced_shadows` = سایه‌ی ابر روی زمین |
| `clouds_raymarching.*` | ابرهای حجمی ۳بعدی (Raymarching) — جدیدترین و سنگین‌ترین بخش؛ `clouds=true`, `shadows=true`, `perf_*` گزینه‌های کارایی |
| `weather.snow/ash` | اندازه‌ی ذرات برف/خاکستر آتشفشانی |
| `ppoff.brightness` | روشنایی وقتی پست‌پراسس خاموش است |
| `sound.*` | صدای باد/باران/رعد (حجم داخل و بیرون خودرو، میرایی بر اساس سرعت) |
| `shaders.groundfog` | مه زمینی (روی پیست) — فعال و نیازمند Track Adaptation |
| `shaders.landscape` | شیدر منظره (کنترل توسط Track Adaptations) |
| `shaders.lightning` | رعد و برق (سرعت، یونیزاسیون، نور برگشتی، احتمال) |
| `shaders.rainhaze` | هاله‌ی باران |
| `shaders.sunblinding` | افکت خیره‌شدن توسط خورشید (در این کانفیگ‌ها غیرفعال) |
| `optimization.cpu_split` | توزیع پردازش Raymarching بین هسته‌های CPU |
| `[DATE]` | مهر زمانی ذخیره‌ی فایل توسط اسکریپت Lua (اثر عملکردی ندارد) |

---

<a id="5-ppfilter"></a>
## ۵. لایه‌ی ۴ — PPFilter (فیلتر پست‌پراسس)

PPFilter یک فایل `.ini` است که ظاهر نهایی تصویر را کنترل می‌کند (رنگ، اکسپوژر، Bloom، عمق میدان و...). این فایل‌ها بر پایه‌ی موتور **YEBIS** بازی کار می‌کنند و در `assettocorsa/system/cfg/ppfilters` قرار می‌گیرند. فیلترهای مدرنِ ساخته‌شده با CSP (که بخش `CSP_EDITOR` دارند) می‌توانند از LUT (بافت Color Grading) هم استفاده کنند.

### ۵.۱ سکشن‌های اصلی و معنی آن‌ها

| سکشن | معنی |
|---|---|
| `[TONEMAPPING]` | `EXPOSURE` (اکسپوژر ثابت)، `GAMMA`، `FUNCTION` (0=LINEAR, 1=LINEARSAT, 6=LOGLU و...)، `HDR=1` |
| `[AUTO_EXPOSURE]` | اکسپوژر خودکار: `MIN/MAX/TARGET` (روشنایی هدف 0–1)، ناحیه‌ی نورسنجی `METERING_*`. در بازی با PageUp/PageDown هم قابل تغییر است |
| `[COLOR]` | `BRIGHTNESS/SATURATION/HUE/CONTRAST/SEPIA/COLOR_TEMP/WHITE_BALANCE` |
| `[GLARE]` | Bloom و لنزفلر: `LUMINANCE`, `THRESHOLD`, `SHAPE`, `GHOST`, `STAR`, `BLOOM_NUM_LEVELS`, `PRECISION` و پارامترهای `SHAPE_*` (شکل سفارشی لنز) |
| `[DOF]` | عمق میدان: `APERTURE_F_NUMBER`, `QUALITY`, تعداد سطوح بوکه |
| `[GODRAYS]` | اشعه‌های نور (Light Shafts) و حلقه‌ی دیفراکشن |
| `[HEAT_SHIMMER]` | موج گرما |
| `[CHROMATIC_ABERRATION]` | انحراف رنگی لنز |
| `[VIGNETTING]` | تاریکی گوشه‌های تصویر |
| `[DIAPHRAGM]` / `[AIRYDISC]` | شکل دیافراگم لنز و پراش هوا |
| `[YEBIS]` | کلید اصلی روشن/خاموش موتور پست‌پراسس |
| `[OPTIMIZATIONS] FIXED_WIDTH` | رندر افکت‌ها با رزولوشن ثابت (مثلاً 1280) برای کارایی |
| `[EXT_COLOR_GRADING]` | اعمال LUT (مثلاً `NFS2015W.png`) با شدت مشخص — امضای بصری فیلتر |
| `[EXT_HDR] FILMIC_CONTRAST` | کنتراست فیلمی |

### ۵.۲ فیلتر NFS 2015 (Vatsky)

فیلتر `UhmFilter.ini` در پروژه‌ی شما، نسخه‌ی ویرایش‌شده‌ی فیلتر معروف **«NFS 2015 Night ppfilter» ساخته‌ی Vatsky** است (که در RaceDepartment / OverTake.gg منتشر شده). این فیلتر تلاش می‌کند حال‌وهوای گرافیکی بازی **Need for Speed 2015** را بازسازی کند: مخصوصاً برای **شب** طراحی شده، تون سبز فیلمی در برخی ساعات دارد و از LUT به نام `NFS2015W.png` استفاده می‌کند (دو LUT گرم و سرد همراه فیلتر اصلی ارائه می‌شود). نام «Edited By Uhm» یعنی یک نفر به نام Uhm آن را شخصی‌سازی کرده است.

---

<a id="6-تحلیل-فایل‌ها"></a>
## ۶. تحلیل کامل فایل‌های پروژه

### ۶.۱ ساختار پروژه و نگاشت به محل نصب

| پوشه در پروژه | محتوا | محل نصب در سیستم |
|---|---|---|
| `1 ~ CSP_Settings/` | ۵ پریست CSP (Low → Ultra) | پوشه‌ی پریست‌های CM: `%LOCALAPPDATA%\AcTools Content Manager\Presets\Custom Shaders Patch Presets\` (هر `.ini` در پوشه‌ای هم‌نام) |
| `2 ~ PPFilter/` | `UhmFilter.ini` | `assettocorsa/system/cfg/ppfilters/` + فایل LUT در `assettocorsa/extension/textures/color_grading/` |
| `3 ~ Pure_Config/` | ۲ کانفیگ PURE | `assettocorsa/extension/config-ext/Pure/` |
| `4 ~ Video_Settings/` | ۵ پریست ویدیو (Low → Ultra) | `%LOCALAPPDATA%\AcTools Content Manager\Presets\Video Settings\` |

### ۶.۲ تحلیل ۵ پریست ویدیویی (`.cmpreset`)

جدول مقایسه‌ی پارامترهای کلیدی:

| پارامتر | Low | Medium | High | VeryHigh | Ultra |
|---|---|---|---|---|---|
| WORLD_DETAIL | 1 | 2 | 3 | 4 | **5 (Maximum)** |
| SHADOW_MAP_SIZE | 512 | 1024 | 2048 | 2048 | **4096** |
| MSAA (AASAMPLES) | 2x | 4x | 4x | 4x | **8x** |
| ANISOTROPIC | 4x | 8x | 8x | 16x | **16x** |
| CUBEMAP SIZE | 512 | 1024 | 1024 | 1024 | **2048** |
| CUBEMAP FACES_PER_FRAME | 2 | 2 | 2 | 4 | **6** |
| CUBEMAP FARPLANE | 810 | 990 | 2500 | 2400 | **2400** |
| MIRROR SIZE | 1024 | 1024 | 1024 | 1024 | **2048** |
| MIRROR HQ | 0 | 1 | 1 | 1 | **1** |
| POST_PROCESS QUALITY | 2 | 2 | 3 | 4 | **5** |
| POST_PROCESS GLARE | 1 | 2 | 3 | 4 | **5** |
| POST_PROCESS DOF | 2 | 2 | 3 | 4 | **5** |
| SMOKE | 2 | 3 | 3 | 3 | **5** |
| REFRESH | 60 | 60 | 90 | 90 | **120** |
| FPS_CAP_MS | 0 | 0 | 0 | 0 | **16.67 ⚠️** |
| SKYBOX_REFLECTION_GAIN | 1 | 1 | 2 | 2 | **3** |
| MAXIMUM_FRAME_LATENCY | 0 | 0 | 0 | 0 | **6 ⚠️** |
| PIXEL_PER_DISPLAY (VR) | 1 | 1 | 1 | 1 | **2.5 ⚠️** |

مقادیر مشترک در هر ۵ پریست:
- `FULLSCREEN=1`, `VSYNC=0`, `DISABLE_LEGACY_HDR=1` ✅ (برای PURE صحیح)
- `SATURATION LEVEL=100` ✅ (روش درست: رنگ را به فیلتر/PURE بسپارید)
- `FILTER=NFS 2015 Edited By Uhm` ⚠️ (به بخش هشدارها مراجعه کنید)
- `HEAT_SHIMMER=1`, `RAYS_OF_GOD=1`, `RENDER_SMOKE_IN_MIRROR=1`
- `[EFFECTS] FXAA=0` و `[POST_PROCESS] FXAA=1` ✅ (سوییچ درست برای ارتقای AA توسط CSP)

**نتیجه‌گیری:** پله‌بندی Low → Ultra منطقی و حرفه‌ای است. پریست «Ultra» در سطح **اسکرین‌شات/بنچمارک** است (MSAA 8x + سایه‌ی 4096 + مکعب انعکاس کامل 6 وجه + آینه‌ی 2048). برای رانندگی روزمره، «High» یا «VeryHigh» نقطه‌ی تعادل خوبی است.

### ۶.۳ تحلیل ۵ پریست CSP (`.ini`)

هر پریست ~۷۵۰ خط دارد و تقریباً همه‌ی ماژول‌ها را شامل می‌شود (از فیزیک و FFB و AI گرفته تا گرافیک). بخش‌های گرافیکی بین ۵ پریست **به‌صورت پلکانی** بالا می‌رود (بقیه‌ی بخش‌ها یکسان‌اند — که نشانه‌ی دقت سازنده است). تفاوت‌های گرافیکی کلیدی:

| تنظیم | Low | Medium | High | VeryHigh | Ultra |
|---|---|---|---|---|---|
| AA کیفیت (Graphics Adjustments) | پیش‌فرض | ULTRA | ULTRA | ULTRA | ULTRA |
| LOD مسیر/درخت/خودرو (فاصله‌ی بیشتر) | — | — | — | — | فقط Ultra (×1.99/×1.95/×1.15) |
| Render Scale (سوپرسمپلینگ) | — | — | — | 1.3 (فقط اسکرین‌شات) | **1.5x ⚠️ سنگین** |
| Motion Blur (CSP) MULT | 0.75 | 0.70 | 0.70 | 0.45 | 0.42 |
| SSLR کیفیت ردیابی (STEPS_HIZ) | 100 | 100 | 200 | 200 | 300 |
| HBAO شدت | 0.4 | 0.65 | 0.6 | 0.6 | 1.0 |
| Volumetric Lights SCALE | 0.15 | 0.185 | 0.26 | 0.276 | 0.32 |
| سایه‌ی خودروها (CARS_SHADOWS) | 1 | — | — | — | 3 |
| سایه‌ی چراغ‌های باکیفیت | — | — | ✓ | ✓ | ✓ |
| چمن QUALITY | — | — | 3 | 4 | 4 |
| چمن CAST_SHADOWS | — | ✓ | ✓ | ✓ | ✓ |
| انعکاس مکعب اصلی (RESOLUTION) | 1024 | 1024 | 2048 | 2048 | 2048 |
| سایه‌ی ابر جزئی (Weather FX) | 0 | 0 | — | — | 0 (همه خاموش — انتخاب خوب برای کارایی) |
| Smoke ذرات / جرقه / Trace | سبک‌تر | پیش‌فرض | متوسط | متوسط | کامل‌تر |

نکات مثبت:
- `WEATHER_FX: BASIC IMPLEMENTATION=pure` و `CONTROLLER=pureCtrl static` → پریست‌ها **برای PURE تنظیم شده‌اند** ✅
- `GRAPHICS_ADJUSTMENTS: SCRIPTABLE_FILTER IMPLEMENTATION=pure` → فیلتر اسکریپتی PURE فعال ✅
- `FSR/DLSS` غیرفعال (`QUALITY2=-1`) → بدون آپ‌اسکیل (تصویر خام) ✅
- سایه‌ی ابر جزئی (DETAILED_CLOUD_SHADOWS) در همه خاموش → تعادل خوب کارایی ✅

### ۶.۴ تحلیل ۲ کانفیگ PURE

دو فایل تقریباً یکسان‌اند (هر دو بر پایه‌ی مقادیر پیش‌فرض PURE با تغییرات جزئی). تفاوت‌های اصلی:

| پارامتر | Simple | Realistic |
|---|---|---|
| `light.sun.level` | 1 | 0.904 |
| `light.sun.saturation` | 1 | 0.95 |
| `light.sky.level` | 1 | 1.385 (آسمان روشن‌تر) |
| `reflections.level` | 1.403 | 1.979 (انعکاس قوی‌تر) |
| `reflections.emissive_boost` | 4.04 | 5.48 (چراغ‌ها در انعکاس درخشان‌تر) |
| `csp_lights.bounce` | 1.442 | 1.826 |
| `csp_lights.emissive` | 1.432 | 1.731 |
| `reflections.sky.luminance` | 8.885 | 4.475 |
| `reflections.sky.gamma` | 2.933 | 3.991 |
| `sun.sun_moon_size` | 3.17 | 4.95 (قرص خورشید/ماه بزرگ‌تر) |
| `clouds2D.brightness` | 1.25 | 0.327 (ابرهای تیره‌تر/کنتراست‌تر) |
| `clouds2D.contrast` | 2.057 | 2.058 |
| `clouds2D.crossfade_time` | 30 | 30.2 |
| `nlp.lowest_ambient` | 1 | 1.433 (شب روشن‌تر) |
| `vao.amount` | 1 | 0.894 |

مقادیر مشترک مهم:
- `light.ambient_model_V2=true` + تمام `advanced_ambient_lightV2_*` فعال → مدل نور پیشرفته ✅
- `clouds2D.set=default_16k` و `clouds2D.quality=3` ⚠️ (نیازمند نسخه‌ی **Highres**؛ با Lowres باید به `default_4k/8k` تغییر کند)
- `clouds_raymarching.clouds=true` و `shadows=true` → **ابرهای حجمی ۳بعدی فعال** (سنگین‌ترین بخش PURE؛ اگر FPS پایین بود این را خاموش کنید)
- `moon.no_shadows=true` → سایه‌ی ماه خاموش (انتخاب کارایی) ✅
- `shaders.groundfog.active=true`، `shaders.lightning.active=true`، `shaders.rainhaze.active=true` فعال
- `shaders.sunblinding.active=false` → افکت خیره‌شدن خورشید خاموش

**نتیجه‌گیری:** «Simple» نزدیک‌تر به پیش‌فرض PURE و متعادل است؛ «Realistic» انعکاس‌ها و نورهای شب را قوی‌تر و ابرهای ۲بعدی را تیره‌تر/کنتراست‌تر می‌کند (حس دراماتیک‌تر، مخصوص شب و اسکرین‌شات). هر دو از ابرهای حجمی Raymarching استفاده می‌کنند، پس برای سیستم‌های ضعیف‌تر باید شخصی‌سازی شوند.

### ۶.۵ تحلیل PPFilter (`UhmFilter.ini`)

- **هویت:** `AUTHOR=Vatsky`, `CSP_EDITOR=3749`, `VERSION=1.2` → نسخه‌ی ویرایش‌شده‌ی فیلتر NFS 2015 با ویرایشگر CSP.
- **امضای بصری:** `[EXT_COLOR_GRADING] FILE='\extension\textures\color_grading\NFS2015W.png' STRENGTH=0.6` → LUT گرم NFS 2015 با شدت ۰.۶ (همان «تون فیلمی/سبز» معروف این فیلتر).
- **رنگ:** `BRIGHTNESS=1.7`, `SATURATION=0.85`, `HUE=0.1`, `SEPIA=0.15`, `COLOR_TEMP=6500`, `WHITE_BALANCE=6250`.
- **اکسپوژر خودکار:** `MIN=0.25 / MAX=0.6 / TARGET=0.30` (روشنایی هدف نسبتاً پایین → تصویر سینمایی/شب‌محور).
- **تون‌مپینگ:** `EXPOSURE=0.3`, `GAMMA=1.35`, `FUNCTION=2`, `HDR=1` + `EXT_HDR FILMIC_CONTRAST=0.7`.
- **Glare:** `USE_CUSTOM_SHAPE=1`, `QUALITY=8`, `LUMINANCE=3`, `THRESHOLD=0.3` → Bloom سفارشی با هاله‌ی لنز (حس NFS).
- **DOF فعال** (`F_NUMBER=16`, `QUALITY=7`) و **GODRAYS فعال** و **HEAT_SHIMMER فعال**.
- **کارایی:** `[OPTIMIZATIONS] FIXED_WIDTH=1280` → افکت‌ها با بافر ۱۲۸۰ پیکسل رندر می‌شوند (کم‌هزینه‌تر).

---

<a id="7-هشدارها"></a>
## ۷. هشدارها و مشکلات یافت‌شده در فایل‌ها ⚠️

بررسی دقیق فایل‌ها چند مورد قابل توجه را نشان داد که باید قبل از استفاده رفع شوند:

1. **عدم تطابق نام فیلتر (مهم‌ترین مورد):**
   در همه‌ی پریست‌های ویدیویی، `FILTER=NFS 2015 Edited By Uhm` است، اما نام فایل فیلتر `UhmFilter.ini` است. AC فیلتر را با **نام فایل** پیدا می‌کند؛ بنابراین فیلتر به‌درستی لود نمی‌شود. **راه‌حل:** یا فایل `UhmFilter.ini` را به `NFS 2015 Edited By Uhm.ini` تغییر نام دهید، یا در پریست‌ها `FILTER=UhmFilter` کنید.

2. **هوک فایل باقی‌مانده از دستگاه سازنده:**
   در همه‌ی پریست‌های CSP این خط وجود دارد:
   `FILE_OP_HOOK=C:/Users/illvd/source/repos/csp_decrypt_example/x64/Release/cspdecryptexample.dll,FileOpHook`
   این یک DLL محلی (هوک عملیات فایل) روی کامپیوتر شخصی سازنده‌ی پریست است و روی سیستم شما وجود ندارد. بی‌اثر است اما بهتر است **حذف شود** (در CSP → General Patch Settings → پاک کردن مسیر هوک).

3. **تناقض FPS Cap در پریست Ultra:**
   `FPS_CAP_MS=16.666...` یعنی محدودیت **۶۰ فریم**، در حالی که `REFRESH=120` است. احتمالاً خطای کپی‌کردن است؛ برای مانیتور 120Hz این را به `0` (یا `8.33`) تغییر دهید.

4. **تاخیر ورودی در پریست Ultra:**
   `MAXIMUM_FRAME_LATENCY=6` یعنی GPU تا ۶ فریم صف می‌گیرد — برای سیم‌ریسینگ تاخیر ورودی محسوسی ایجاد می‌کند. مقدار `0` یا `1` توصیه می‌شود.

5. **سنگین بودن پریست Ultra (دو لایه سوپرسمپلینگ):**
   CSP Ultra مقدار `RENDER_SCALE SCALE=1.5` (رندر ۱۵۰٪) دارد و پریست ویدیویی Ultra هم MSAA 8x + سایه 4096 + مکعب 6 وجهی. ترکیب این دو یعنی **۱۵۰٪ رندر + ۸x MSAA** که فقط مناسب اسکرین‌شات است، نه رانندگی. `RENDER_SCALE` با Fullscreen هم سازگار نیست (طبق Hint خود CSP).

6. **`SELECT_ADAPTER=NVIDIA?`:**
   مقدار `?` در انتخاب آداپتور گرافیکی در `[DXGI_TWEAKS]` غیرعادی است. اگر کارت شما NVIDIA نیست، این را حذف/تغییر دهید.

7. **فایل LUT فیلتر باید موجود باشد:**
   فیلتر به `extension/textures/color_grading/NFS2015W.png` ارجاع می‌دهد. اگر این فایل کنار فیلتر نصب نشود، Color Grading اعمال نمی‌شود (تصویر بی‌روح می‌شود). این LUT همراه دانلود اصلی فیلتر NFS 2015 ارائه می‌شود.

8. **ابرهای 16k نیازمند نسخه‌ی Highres هستند:**
   `clouds2D.set=default_16k` فقط با پکیج Highres PURE درست کار می‌کند. با Lowres، این را به `default_8k` یا `default_4k` تغییر دهید.

9. **`shaders.groundfog.error=true`:**
   پرچم خطا در هر دو کانفیگ PURE ثبت شده (وضعیت ذخیره‌شده‌ی اپ). مه زمینی برای دیده‌شدن درست نیازمند Track Adaptation است؛ اگر روی پیست دیده نشد طبیعی است و مشکل از کانفیگ نیست.

10. **هدف پریست‌ها سخت‌افزار سازنده است:**
    نام کاربری `illvd`، رزولوشن 1080p و رفرش 60–120 نشان می‌دهد این پریست‌ها برای یک سیستم مشخص ساخته شده‌اند. همیشه به‌عنوان **نقطه‌ی شروع** استفاده کنید و رزولوشن/رفرش را با مانیتور خودتان تطبیق دهید.

---

<a id="8-راهنمای-نصب"></a>
## ۸. راهنمای نصب و استفاده

1. **پیش‌نیازها:** نسخه‌ی اورجینال Assetto Corsa (Steam) → Content Manager → CSP نسخه‌ی 0.2.x/0.3 → PURE (Highres اگر سیستم قوی دارید).
2. **کپی فایل‌ها** طبق جدول بخش ۶.۱ (مسیر پریست‌های CM را با «ذخیره‌ی یک پریست تست» در CM پیدا کنید تا مسیر دقیق تایید شود).
3. **فیلتر:** `UhmFilter.ini` را در `system/cfg/ppfilters` بگذارید و **نام آن را با `FILTER=` در پریست ویدیو هماهنگ کنید** (هشدار ۱).
4. **LUT:** فایل `NFS2015W.png` را در `extension/textures/color_grading` قرار دهید.
5. **در CM:** پریست ویدیو و پریست CSP متناسب با سیستم را انتخاب کنید (برای شروع: Video=High و CSP=High).
6. **WeatherFX:** در CSP → Weather FX، سبک `Pure` را فعال کنید؛ در منوی Drive هم Weather Controller را `Pure` بگذارید.
7. **در بازی:** اپ `Pure Config` را باز کنید و کانفیگ `Uhm Config-Realistic` یا `Uhm PureConfig-Simple` را لود کنید (در صورت نیاز `default_16k` را مطابق هشدار ۸ تغییر دهید).
8. **اگر FPS پایین بود:** به‌ترتیب Raymarching ابرها را خاموش کنید → پریست ویدیو را یک پله پایین بیاورید → `FACES_PER_FRAME` را روی 2 بگذارید → سایه‌ها را 1024/2048 کنید.

---

<a id="9-منابع"></a>
## ۹. منابع و مراجع

**CSP و تنظیمات گرافیکی:**
- راهنمای نصب CSP — AC Supply: https://www.acsupply.cx/guides/custom-shaders-patch
- راهنمای بهینه‌سازی CSP (Reddit): https://www.reddit.com/r/assettocorsa/comments/bs9lhm/custom_shaders_patch_is_a_must_have_for/
- راهنمای VR برای AC و CSP (توضیح دقیق ماژول‌ها، LOD، VRS و...): https://github.com/Raptyyy/rapty_ac_vr_guide
- راهنمای گرافیک AC (Pure + PP Filter): https://steamcommunity.com/sharedfiles/filedetails/?id=3466754155
- تنظیمات گرافیکی و بهینه‌سازی AC 1.16.4 + CSP 0.1.79: https://www.overtake.gg/threads/ac-2023-1-16-4-csp-0-1-79-graphical-adjustments-and-optimization.261376/

**PURE:**
- راهنمای رسمی نصب Pure (Scribd/پیتر بوزه): https://www.scribd.com/document/669941545/Pure-Install-Guide
- راهنمای نصب Pure (arcmite): https://arcmite.github.io/arc-website/guides/setup/installing-pure.html
- SOL در برابر Pure (2026): https://simracingcockpit.gg/how-to-install-sol-assetto-corsa/
- Pure Weather Mod، نصب و اپ‌ها (2026): https://simracingcockpit.gg/what-is-the-pure-weather-mod-for-assetto-corsa-and-how-do-i-install-it/
- نصب CM + CSP + Pure: https://simracingcockpits.com/install-content-manager-custom-shaders-patch-pure-assetto-corsa/

**PPFilter:**
- مستندات پارامترهای PPFilter (سکشن‌های YEBIS): https://aloog.boards.net/thread/118
- مستندات کامل PPFilter (انجمن Steam): https://steamcommunity.com/app/244210/discussions/0/368542844478108617
- فیلتر NFS 2015 Night (ساخته‌ی Vatsky): https://www.overtake.gg/downloads/nfs-2015-night-ppfilter.35978/
- معرفی PPFilter (arcmite): https://arcmite.github.io/arc-website/guides/visuals/ppfilters.html

**تنظیمات ویدیویی (Cubemap / Faces per Frame / سایه‌ها):**
- Faces per Frame چیست؟ (Reddit): https://www.reddit.com/r/assettocorsa/comments/1bz4kr1/what_does_the_faces_per_frame_mean_in_assetto/
- Faces per Frame و Cubemap (OverTake): https://www.overtake.gg/threads/faces-per-frame.77630/
- Cubemap و Faces per Frame (انجمن Steam): https://steamcommunity.com/app/244210/discussions/0/35221584450559712/
- Cubemap resolution و Faces per Frame (RaceDepartment): https://www.racedepartment.com/threads/ac-what-is-cubemap-resolution-and-what-is-faces-per-frame-settings.88595/

---

*این سند بر اساس بررسی کامل ۱۴ فایل موجود در پروژه + منابع اینترنتی بالا تهیه شده است. برای هر سوال درباره‌ی یک پارامتر خاص یا شخصی‌سازی پریست برای سیستم خودتان، در خدمتم.*
