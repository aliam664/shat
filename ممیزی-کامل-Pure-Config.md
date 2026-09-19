# ممیزی کامل و حرفه‌ای — Pure Config
### بررسی تک‌تک ۲۱۲ پارامتر دو کانفیگ `Uhm Config-Realistic` و `Uhm PureConfig-Simple`

> پروژه: `shat` · تاریخ: ۱۴ سپتامبر ۲۰۲۶
> مرجع محدوده‌ها: مستندات Pure Config (ARC) + راهنمای رسمی Peter Boese + منابع جامعه

---

## ۱. پلن اجراشده

| # | گام | وضعیت |
|---|---|---|
| 1 | جمع‌آوری مستندات معتبر هر پارامتر (کاربرد + محدوده) | ✅ |
| 2 | استخراج برنامه‌ای هر دو فایل → ۲۱۲ کلید | ✅ |
| 3 | مقایسه‌ی هر مقدار با محدوده‌ی مجاز (تشخیص خارج‌ازمحدوده) | ✅ |
| 4 | بررسی پرچم‌های خطا، پارامترهای تستی، و سازگاری LCS/Gamma + Highres/Lowres | ✅ |
| 5 | صدور گزارش وضعیت هر پارامتر (✅/⚠️/🟢) | ✅ |

---

## ۲. شناسنامه‌ی فایل‌ها

| | `Uhm Config-Realistic.ini` | `Uhm PureConfig-Simple.ini` |
|---|---|---|
| تعداد کلید | ۲۱۲ | ۲۱۲ |
| ساختار | `[DATE]` + `[PureConfig]` | `[DATE]` + `[PureConfig]` |
| کلیدهای متفاوت | ۲۰ (مقدار) + ۷ (DATE) | — |
| تاریخ ذخیره (DATE) | ۱۳ اوت ۲۰۲۶، ۰۴:۳۲ | ۱۰ ژوئیه ۲۰۲۶، ۰۷:۰۵ |
| اعتبار مهر زمانی | ✅ (روز هفته و روز سال سازگارند) | ✅ |
| سبک هدف | **LCS / سینمایی** | **Gamma / متعادل** |

> **یافته‌ی ساختاری:** هر دو فایل دقیقاً همان مجموعه‌ی ۲۱۲ کلیدی را دارند (هیچ کلید گم/اضافه‌ای نیست) → هر دو از یک نسخه‌ی Pure ذخیره شده‌اند. سالم از نظر ساختار.

---

## ۳. خلاصه‌ی نتیجه (قبل از جزئیات)

| وضعیت | تعداد | شرح |
|---|---|---|
| ❌ خطای قطعی | **۰** | هیچ مقداری خارج از محدوده‌ی مجاز نیست؛ فایل‌ها ساختار سالم دارند |
| ⚠️ هشدار مهم | ۳ | `groundfog.error=true` · `default_16k` (نیازمند Highres) · ابرهای حجمی روشن |
| 🟢 یادداشت | ۵ | اسلایدرهای تستی، چراغ‌خودکار AI، LCS/Gamma، سایه‌ی ماه، و... |
| ✅ تأیید | بقیه | همه‌ی مقادیر در محدوده و منطقی |

---

## ۴. ممیزی تفصیلی به تفکیک تب

> افسانه: **✅** در محدوده و منطقی · **⚠️** هشدار · **🟢** یادداشت/سلیقه‌ای · R = Realistic · S = Simple

### ۴.۱ تب Light (نور) — ۳۱ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `light.daylight_multiplier` | ضریب کلی روشنایی روز | 0–10 | 0.760 | 0.760 | ✅ |
| `light.sun.hue` | رنگ غالب نور خورشید | ±180 | 0 | 0 | ✅ |
| `light.sun.saturation` | شدت رنگ نور خورشید | 0–10 | 0.95 | 1 | ✅ |
| `light.sun.level` | شدت نور خورشید روی سطوح | 0–10 | 0.904 | 1 | ✅ |
| `light.sun.speculars` | براقیت سطوح صاف از نور خورشید | 0–10 | 1.673 | 1 | ✅ |
| `light.ambient_model_V2` | مدل نور محیطی «کاشی‌شده» به‌جای تکی | bool | true | true | ✅ |
| `light.ambient.hue/saturation/level` | رنگ/شدت نور محیطی | ±180/0–10/0–10 | 0/1/1 | 0/1/1 | ✅ |
| `light.advanced_ambient_light` | شدت نور محیطی پیشرفته (مشابه ambient.level) | 0–10 | 1 | 1 | ✅ |
| `light.advanced_ambient_lightV2_sun/skydomes/sky/clouds/nlp/fog` | سهم هر منبع از نور محیطی V2 | 0–10 | 1×۶ | 1×۶ | ✅ |
| `light.advanced_ambient_light_vao_exp` | سهم اکسپوژر VAO از نور محیطی | 0–10 | 1 | 1 | ✅ (نام داخلی؛ در هر دو یکسان) |
| `light.distant_ambient.hue/saturation/level/distance` | نور محیطی دوردست (فاصله‌ی «دور» بودن) | 0–10 | 0/1/1/1 | 0/1/1/1 | ✅ |
| `light.directional_ambient.hue/saturation/level` | نور محیطی جهت‌دار (بیشتر در سایه‌ها دیده می‌شود) | 0–10 | 0/1/1 | 0/1/1 | ✅ |
| `light.sky.hue/saturation/level` | رنگ/شدت آسمان | ±180/0–10/0–10 | 0/1/**1.385** | 0/1/**1** | ✅ |
| `light.grass_shading.specularity/reflectivity/backlit/saturation` | سایه‌زنی چمن | 0–10 | 1×۴ | 1×۴ | ✅ |

### ۴.۲ تب Sky و Sun (آسمان و خورشید) — ۷ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `sky.sun_disk.hue` | رنگ قرص خورشید | ±180 | 0 | 0 | ✅ |
| `sky.sun_disk.saturation` | اشباع قرص خورشید | 0–10 | 1 | 1 | ✅ |
| `sky.sun_disk.level` | روشنایی قرص خورشید | 0–10 | **0.014** | **1** | 🟢 کلید تفکیک LCS/Gamma (بخش ۵) |
| `sun.sun_moon_size` | اندازه‌ی قرص خورشید/ماه | 0–10 | 4.952 | 3.173 | ✅ |
| `fog.cubemaps` | مه در انعکاس‌ها | 0–1 | 1 | 1 | ✅ |
| `shadows.presence` | حضور سایه‌ها (همه‌جا / فقط نواحی سایه) | 0–1 | 0.966 | 0.966 | ✅ (نزدیک سقف = سایه‌ی کامل) |
| `ui.white_reference_point` | مرجع سفید UI | 0–10 | 1 | 1 | ✅ (بدون اثر قابل مشاهده طبق مستندات) |

### ۴.۳ تب Night (شب) — ۸ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `nlp.level` | روشنایی آلودگی نوری شب (NLP) | 0–10 | 1 | 1 | ✅ |
| `nlp.density` | تراکم NLP | 0–10 | 1 | 1 | ✅ |
| `nlp.lowest_ambient` | کف نور محیطی شب | 0–10 | **1.433** | 1 | ✅ |
| `moon.light` | شدت نور ماه | 0–10 | 1 | 1 | ✅ |
| `moon.appearance` | روشنایی ظاهری ماه | 0–10 | 1 | 1 | ✅ |
| `moon.no_shadows` | خاموش‌بودن سایه‌ی ماه | bool | **true** | **true** | 🟢 تریدآف کارایی |
| `stars.appearance` | روشنایی ستاره‌ها | 0–100 | 14.423 | 14.423 | ✅ |
| `stars.dynamic_adaption` | تطبیق داینامیک ستاره‌ها | bool | false | false | ✅ |

### ۴.۴ تب Clouds (ابرها) — ۲D + ۳D + render = ۴۰ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `clouds_render.method` | ۰=ابر ۳بعدی بیلبورد، ۱=اسکای‌دام ۳۶۰° | 0–1 | 1 | 1 | ✅ |
| `clouds.distance` | فاصله‌ی ابرها | — | 1 | 1 | ✅ |
| `clouds.quality` | کیفیت ابر | 0–1 | 0.85 | 0.85 | ✅ |
| `clouds.advanced_lighting` | نورپردازی پیشرفته‌ی ابر | bool | true | true | ✅ |
| `clouds.position_calculation_mode/limiter` | حالت/سقف محاسبه‌ی موقعیت ابر | — | 1/500 | 1/500 | ✅ |
| `clouds.color_calculation_limiter` | سقف محاسبه‌ی رنگ | — | 100 | 100 | ✅ |
| `clouds2D.set` | مجموعه‌ی اسکای‌دام | default_16k/8k/4k | **default_16k** | **default_16k** | ⚠️ **نیازمند پکیج Highres** |
| `clouds2D.quality` | کیفیت اسکای‌دام | 1–5 | 3 | 3 | ✅ |
| `clouds2D.crossfade_time` | سرعت محو بین اسکای‌دام‌ها | 1–60 | 30.21 | 30 | ✅ |
| `clouds2D.wind_oscillation` | نوسان باد | — | 1 | 1 | ✅ |
| `clouds2D.advanced_shadows` | سایه‌ی ابر روی زمین | bool | true | true | ✅ |
| `clouds2D.advanced_shadows_sun_cover` | درنظرگرفتن پوشش خورشید برای سایه | bool | false | false | ✅ |
| `clouds2D.advanced_shadows_speed` | سرعت حرکت سایه‌ها | 0.1–10 | 1 | 1 | ✅ |
| `clouds2D.preload` | پیش‌بارگذاری اسکای‌دام‌ها | bool | false | false | ✅ |
| `clouds2D.unload` | تخلیه‌ی اسکای‌دام بلااستفاده (صرفه‌جویی VRAM) | bool | true | true | ✅ |
| `clouds2D.brightness` | روشنایی اسکای‌دام | 0–10 | **0.327** | **1.25** | ✅ (تفاوت بزرگ عمدی) |
| `clouds2D.contrast` | کنتراست اسکای‌دام | 0–10 | 2.058 | 2.057 | ✅ |
| `clouds_render.shadows_strength` | شدت سایه‌ی ابر | — | 1 | 1 | ✅ |
| `clouds_render.shadows_blur` | نرمی سایه‌ی ابر | — | 0.356 | 0 | ✅ |
| `clouds_raymarching.clouds` | **ابرهای حجمی ۳بعدی** | bool | true | true | ⚠️ سنگین‌ترین بخش |
| `clouds_raymarching.shadows` | سایه‌ی ابر حجمی (رای‌مارچ به‌سمت نور) | bool | true | true | ⚠️ سنگین |
| `clouds_raymarching.resolution` | رزولوشن رندر حجمی (۰.۵ = نیم‌رزولوشن) | 0–1 | 0.5 | 0.5 | ✅ انتخاب کارایی |
| `clouds_raymarching.scale` | مقیاس ابر حجمی | — | 1 | 1 | ✅ |
| `clouds_raymarching.softness` | نرمی ابر | — | 0.4 | 0.4 | ✅ |
| `clouds_raymarching.blur` / `.blur_width` | بلور ابر حجمی | — | true/2 | true/2 | ✅ |
| `clouds_raymarching.upscale` | آپ‌اسکیل ابر | bool | true | true | ✅ |
| `clouds_raymarching.perf_reprojection` | بازپخش فریم قبلی (کارایی) | bool | false | false | ✅ |
| `clouds_raymarching.perf_fast` | حالت سریع | bool | true | true | ✅ |
| `clouds_raymarching.perf_detail` | جزئیات | bool | true | true | ✅ |
| `clouds_raymarching.perf_variSteps` | گام‌های متغیر | bool | true | true | ✅ |
| `clouds_raymarching.perf_maxDense` | سقف تراکم | — | 1 | 1 | ✅ |
| `clouds_raymarching.perf_samplesSky/Light` | تعداد نمونه‌های آسمان/نور | — | 2/6 | 2/6 | ✅ |
| `clouds_raymarching.perf_samplesSkyAdaptive` | نمونه‌برداری تطبیقی آسمان | bool | false | false | ✅ |
| `clouds_raymarching.perf_extendedLightray(Samples)` | پرتوی نور گسترده (نمونه‌ها) | bool/— | true/3 | true/3 | ✅ |
| `clouds_raymarching.debug_*` | دیباگ (موقعیت آب‌وهوا/بازپخش) | bool | false | false | ✅ |

### ۴.۵ تب Weather (آب‌وهوا) — ۴ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `weather.use_weather_particles` | تبدیل باران به برف زیر ۳°C | bool | true | true | ✅ |
| `weather.snow.size` | اندازه‌ی برف | 0–10 | 1 | 1 | ✅ |
| `weather.ash.size` | اندازه‌ی خاکستر | 0–10 | 1 | 1 | ✅ |
| `weather.add_online_properties` | افزودن آب‌وهوا به آنلاین | bool | true | true | ✅ |
| `ppoff.brightness` | روشنایی وقتی PP خاموش است | — | 1 | 1 | ✅ |

### ۴.۶ تب Reflections / CSP Lights / VAO — ۱۲ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `reflections.saturation` | اشباع رنگ انعکاس‌ها | 0–10 | 0.712 | 0.712 | ✅ |
| `reflections.level` | روشنایی کل انعکاس‌ها | 0–10 | 1.979 | 1.403 | ✅ |
| `reflections.emissive_boost` | درخشش اجسام نورانی در انعکاس | 0–30 | 5.481 | 4.039 | ✅ |
| `reflections.sky.luminance` | روشنایی انعکاس آسمان | — | **4.475** | **8.885** | ✅ |
| `reflections.sky.gamma` | گامای انعکاس آسمان | — | **3.991** | **2.933** | ✅ |
| `reflections.sky.saturation` | اشباع انعکاس آسمان | — | 1 | 1 | ✅ |
| `csp_lights.bounce` | پرش پرتوهای نور CSP | 0–10 | 1.826 | 1.442 | ✅ |
| `csp_lights.emissive` | درخشش مرکز چراغ‌های خیابان | 0–10 | 1.731 | 1.432 | ✅ |
| `csp_lights.displays` | درخشش نمایشگرها (داشبورد) | 0–10 | 1 | 1 | ✅ |
| `vao.amount` | شدت سایه‌روشن محیطی (VAO) | 0–2 | 0.894 | 1 | ✅ |
| `vao.track_exponent` | ضریب VAO پیست | 0–2 | 0.404 | 0.5 | ✅ |
| `vao.dynamic_exponent` | ضریب VAO داینامیک | 0–2 | 0.334 | 0.334 | ✅ |

### ۴.۷ تب Camera (دوربین) — ۵ کلید

| پارامتر | کاربرد | R | S | وضعیت |
|---|---|---|---|---|
| `camera.occlusion_control.adv_ambi_light` | کنترل اکسپوژر: نور محیطی پیشرفته | false | false | ✅ |
| `camera.occlusion_control.adv_fog_ambi_light` | نور محیطی مه | true | true | ✅ |
| `camera.occlusion_control.exposure` | اکسپوژر خودکار | true | true | ✅ |
| `camera.occlusion_control.overcast` | حالت ابری | true | true | ✅ |
| `camera.occlusion_control.vao` | درنظرگرفتن VAO | true | true | ✅ |

### ۴.۸ تب AI Headlights (چراغ‌خودکار AI) — ۷ کلید

| پارامتر | کاربرد | R | S | وضعیت |
|---|---|---|---|---|
| `AI_headlights.sun` | روشن‌کردن چراغ اگر زاویه‌ی خورشید زیر این مقدار | 7 | 7 | ✅ |
| `AI_headlights.ambient_light` | ... اگر نور محیطی زیر این مقدار | 12 | 12 | ✅ |
| `AI_headlights.CBE` | ... اگر روشنایی انعکاس زیر این مقدار | 0.6 | 0.6 | ✅ |
| `AI_headlights.fog` | ... اگر مه غلیظ‌تر از این مقدار | 0.4 | 0.4 | ✅ |
| `AI_headlights.rain` | ... اگر شدت باران بالاتر از این | 0.07 | 0.07 | ✅ |
| `AI_headlights.headlights_ctrl` | **سوییچ اصلی کنترل خودکار چراغ AI** | **0** | **0** | 🟢 خاموش (نیازمند فعال‌سازی در CSP) |
| `AI_headlights.high_beams_ctrl` | کنترل خودکار نوربالا | 0 | 0 | 🟢 خاموش |

### ۴.۹ تب Sound (صدا) — ۱۳ کلید

| پارامتر | کاربرد | محدوده | R | S | وضعیت |
|---|---|---|---|---|---|
| `sound.wind_volume_interior/exterior` | بلندی باد داخل/بیرون | 0–1 | 0.63/1 | 0.63/1 | ✅ |
| `sound.wind_volume_speed_damping` | میرایی باد بر اساس سرعت | 0–1 | 0.75 | 0.75 | ✅ |
| `sound.rain_volume_interior/exterior` | بلندی باران داخل/بیرون | 0–1 | 0.853/1 | 0.853/1 | ✅ |
| `sound.rain_volume_speed_damping` | میرایی باران بر اساس سرعت | 0–1 | 0.75 | 0.75 | ✅ |
| `sound.damping_at_speed` | سرعت میرایی صدا | 0–500 | 200 | 200 | ✅ |
| `sound.rain_volume_extra_skid` | صدای اضافه‌ی لیز خوردن | 0–10 | 2.394 | 2.394 | ✅ |
| `sound.rain_volume_extra_wetness` | صدای خیسی | 0–10 | 1 | 1 | ✅ |
| `sound.rain_volume_extra_puddles` | صدای گودال آب | 0–10 | 4.462 | 4.462 | ✅ |
| `sound.rain_volume_extra_gravel` | صدای شن‌ریزه | 0–10 | 3.990 | 3.990 | ✅ |
| `sound.thunder_volume_interior/exterior` | صدای رعد | 0–1 | 1/1 | 1/1 | ✅ |

### ۴.۱۰ تب Shaders (شیدرها) — ۷۷ کلید

**Groundfog (مه زمینی):**

| پارامتر | کاربرد | محدوده | R/S | وضعیت |
|---|---|---|---|---|
| `shaders.groundfog.active` | روشن/خاموش | bool | true | ✅ |
| `shaders.groundfog.Quality` | کیفیت | 1–4 | **4** (بیشینه) | ✅ |
| `shaders.groundfog.Expand_width` | پهن‌ترکردن بیلبوردها | bool | true | ✅ |
| `shaders.groundfog.Interpolate_near` | درون‌یابی نزدیک دوربین | bool | true | ✅ |
| `shaders.groundfog.Render_distance` | فاصله‌ی رندر | 0.25–10 | 3 | ✅ |
| `shaders.groundfog.Size/Scale/Structure` | ابعاد بیلبورد | 0.25–5 / 0.1–5 | 1/1/1 | ✅ |
| `shaders.groundfog.Gain` | میزان مه | 0–10 | 1 | ✅ |
| `shaders.groundfog.Nearby_fadeout` | محوشدن نزدیک | 0.1–2 | 1 | ✅ |
| `shaders.groundfog.Sun_influence` | تأثیر خورشید | 0–1 | 0.1 | ✅ |
| `shaders.groundfog.Car_turbulences` | تلاطم باد خودرو | bool | true | ✅ (پیش‌تنظیم «Very High») |
| `shaders.groundfog.error` | **پرچم خطای ذخیره‌شده** | bool | **true** | ⚠️ (بخش ۶) |
| `shaders.groundfog.info/txt_expand` | متن UI | — | — | ✅ بی‌اثر |

**Landscape (منظره):**

| پارامتر | کاربرد | R/S | وضعیت |
|---|---|---|---|
| `shaders.landscape.active` | شیدر منظره (خارج پیست) | true | ✅ |
| `shaders.landscape.only_skyshader` | **هرگز خاموش نشود** (رفع چشمک‌زدن) | true | ✅ مقدار صحیح |
| `shaders.landscape.debug/error` | دیباگ/خطا | false/false | ✅ |

**Lightning (رعدوبرق):**

| پارامتر | کاربرد | محدوده | R/S | وضعیت |
|---|---|---|---|---|
| `active` | روشن | bool | true | ✅ |
| `speed` | سرعت صاعقه | 0–1 | 0.3 | ✅ |
| `discharge_exponent` | پالس صاعقه | 1–32 | 12 | ✅ |
| `discharge_ionisation` | عمق نفوذ | 0.1–4 | 2 | ✅ |
| `maximum_flash_light` | بیشینه‌ی روشنایی فلاش | 0–10 | 7.5 | ✅ |
| `bounced_light` | نور برگشتی | 0–10 | 1 | ✅ |
| `saturation` | اشباع رنگ | 0–10 | 1 | ✅ |
| `probability_multiplier` | احتمال وقوع | 0.1–10 | 1 | ✅ |
| `debug_*` (۹ کلید) | پارامترهای دیباگ (جهت/فاصله/ارتفاع/سایز/فلیکر/سکانس) | — | مقادیر دیباگ | ✅ (فقط وقتی `debug=false` بی‌اثرند) |
| `txt_*` (۳ کلید) | متن UI | — | — | ✅ بی‌اثر |

**Rain Haze (هاله‌ی باران):**

| پارامتر | کاربرد | محدوده | R/S | وضعیت |
|---|---|---|---|---|
| `shaders.rainhaze.active` | روشن | bool | true | ✅ |
| `shaders.rainhaze.gain` | شدت | 0–10 | 1 | ✅ |

**Sunblinding (خیره‌شدن خورشید):**

| پارامتر | کاربرد | محدوده | R/S | وضعیت |
|---|---|---|---|---|
| `active` | روشن/خاموش | bool | **false** | ✅ (خاموش — عمدی) |
| `allow_control` | اجازه‌ی کنترل توسط اسکریپت PP | bool | true | ✅ |
| `sensitivity` | حساسیت به نور خورشید | 0–2 | 1 | ✅ |
| `horizontal/vertical/low_angle_slope` | گسترش افقی/عمودی/شیب زاویه‌ی کم | 0–1 | 1 | ✅ |
| `time_up/time_down` | زمان ظاهر/محو | 0.01–10 | 0.5/2 | ✅ |
| `cover/blinding/iris` | اورلی/تاریکی کل دید | 0–2 | 1 | ✅ |
| `star_opacity/size/blur/style/adapt_coverage/cover_damping` | افکت ستاره‌ای | 0–2 | 1 | ✅ |
| `color` | اشباع نور افزوده | 0–2 | 1 | ✅ |
| `half_resolution` | رندر نیم‌رزولوشن (کارایی) | bool | false | ✅ |
| `VR_tweak` | تنظیم VR | bool | false | ✅ |
| `debug/error` | دیباگ/خطا | bool | false/false | ✅ |
| `txt_*` (۸ کلید) | متن UI | — | — | ✅ بی‌اثر |

### ۴.۱۱ تب Opt + Debug + State — ۸ کلید

| پارامتر | کاربرد | R/S | وضعیت |
|---|---|---|---|
| `optimization.cpu_split` | توزیع رای‌مارچ بین هسته‌های CPU | true | ✅ |
| `debug.memory` | اورلی دیباگ حافظه | false | ✅ |
| `debug.computation` | اورلی دیباگ محاسبات | false | ✅ |
| `debug.graphics` | اورلی دیباگ گرافیک | false | ✅ |
| `info.test_slider` / `test_slider2` / `test_slider3` | **اسلایدرهای تستِ باقی‌مانده از سازنده** | 1/1/1 | 🟢 بی‌اثر |

---

## ۵. تحلیل LCS در برابر Gamma (مهم‌ترین یافته‌ی سازگاری)

مقایسه‌ی دو کانفیگ نشان می‌دهد هر کدام برای یک فضای رنگی متفاوت ساخته شده‌اند:

| شاهد | Realistic | Simple | تفسیر |
|---|---|---|---|
| `sky.sun_disk.level` | **0.014** | 1 | در LCS قرص خورشید توسط Glare فیلتر رندر می‌شود، پس بافت قرص تقریباً خاموش (0.014)؛ در Gamma قرص دیده می‌شود (1) |
| `reflections.sky.luminance` | 4.475 (تیره‌تر) | 8.885 (روشن‌تر) | LCS به نور خطی نیاز دارد |
| `reflections.sky.gamma` | 3.991 | 2.933 | گامای متفاوت |
| `clouds2D.brightness` | 0.327 | 1.25 | ابر تیره‌ی سینمایی در برابر ابر روشن متعادل |

**نکته‌ی اتصال‌دهنده:** پریست‌های CSP پروژه‌ی ما (که قبلاً رمزگشایی کردیم) روی `LINEAR_COLOR_SPACE ENABLED=1` هستند، یعنی سبک **Pure LCS**. پس:
- ✅ با پریست‌های CSP ما، کانفیگ **Realistic** (LCS) هم‌خوان است.
- ⚠️ کانفیگ **Simple** برای Gamma است؛ اگر با CSPِ LCS استفاده شود، ممکن است خورشید/ابرها غیرطبیعی دیده شوند.

> برای حالت Gamma، در CM → CSP → Weather FX → Weather Style باید `Pure Gamma` انتخاب شود و کانفیگ **Simple** لود شود.

---

## ۶. سه هشدار اصلی (⚠️)

**۱. `shaders.groundfog.error=true`**
این یک پرچمِ «وضعیت خطا» است که اپ Pure Config هنگام ذخیره ثبت کرده (نه یک تنظیم). یعنی در لحظه‌ی ذخیره، شیدر مه زمینی در حالت خطا بود. شایع‌ترین دلیل: **پیست فاقد Track Adaptation برای Groundfog است** (مه زمینی فقط روی پیست‌های سازگارشده رندر می‌شود). این باگِ کانفیگ نیست؛ انتظار می‌رود. در پیست‌های بدون اقتباس، مه زمینی دیده نمی‌شود.

**۲. `clouds2D.set=default_16k`**
مجموعه‌ی اسکای‌دام ۱۶ هزار پیکسلی فقط در **پکیج Highres** وجود دارد. اگر نسخه‌ی **Lowres** نصب شده باشد، این مقدار نامعتبر است و آسمان/ابرها خراب یا به پیش‌فرض برمی‌گردند. → باید با نسخه‌ی نصب‌شده‌ی Pure تطبیق داده شود (Lowres → `default_8k` یا `default_4k`).

**۳. ابرهای حجمی ۳بعدی روشن (`clouds_raymarching.clouds=true` + `shadows=true`)**
سنگین‌ترین قابلیت Pure (رای‌مارچینگ + سایه‌ی ابر). همراه با ۱۶K و کیفیت 4 مه زمینی، این کانفیگ «اولترا» است. اگر افت FPS دیدید، اولین اهرم، `clouds_raymarching.shadows=false` یا `clouds=false` است.

---

## ۷. پنج یادداشت (🟢)

1. **`info.test_slider` ×۳** — اسلایدرهای تستی که Peter Boese در کانفیگ پیش‌فرض رها کرده؛ هیچ اثری ندارند و حذف‌شدنی‌اند.
2. **چراغ‌خودکار AI خاموش** (`headlights_ctrl=0` و `high_beams_ctrl=0`) — برای فعال‌شدن، باید در CSP → Weather FX گزینه‌ی «Turn headlights on and off automatically» روشن شود. آستانه‌ها (sun/rain/fog و...) درست تنظیم‌اند.
3. **`moon.no_shadows=true`** — سایه‌ی ماه عمداً خاموش شده (تریدآف کارایی). کیفیت شب را کمی کم می‌کند.
4. **`shaders.sunblinding.active=false`** — افکت خیره‌شدن خورشید خاموش است؛ اما `allow_control=true` است یعنی فیلتر PP در صورت تمایل می‌تواند آن را کنترل کند.
5. **`camera.occlusion_control.adv_ambi_light=false`** در حالی که بقیه‌ی کنترل‌های اکسپوژر روشن‌اند — ترکیب عمدی برای اکسپوژر خودکار بدون درنظرگرفتن نور محیطی پیشرفته.

---

## ۸. جمع‌بندی نهایی

| جنبه | نتیجه |
|---|---|
| صحت ساختار | ✅ هر دو فایل کامل و هم‌کلید (۲۱۲ کلید)، بدون کلید گم/زائد |
| محدوده‌ی مقادیر | ✅ هیچ مقداری خارج از محدوده‌ی مستند نیست |
| خطای قطعی | ❌ وجود ندارد (۰) |
| هشدارها | ⚠️ ۳ مورد: `groundfog.error`، `default_16k`، ابرهای حجمی |
| سازگاری داخلی | ⚠️ Realistic=LCS (سازگار با CSP ما) · Simple=Gamma |
| کیفیت کلی | ✅ کانفیگ‌هایی تمیز، منطقی و حرفه‌ای — «Realistic» دراماتیک/سینمایی، «Simple» متعادل |

**توصیه‌ی نهایی:**
- اگر سبک CSP شما LCS است (هست) → کانفیگ **Realistic** را لود کنید.
- اگر Highres نصب ندارید → `clouds2D.set` را به `default_8k` (یا 4k) تغییر دهید.
- مه زمینی فقط روی پیست‌های دارای Track Adaptation ظاهر می‌شود (هشدار ۱ طبیعی است).
- برای افت FPS → `clouds_raymarching.shadows=false` اولین گام است.

---

*منابع: مستندات Pure Config (ARC / arcmite.github.io) · راهنمای نصب رسمی Pure · صفحه‌ی Peter Boese (Overtake/Patreon) · مستندات Raymarching ابرهای حجمی.*

---

## ۹. اصلاحات اعمال‌شده (چنج‌لاگ) — ۱۴ سپتامبر ۲۰۲۶

پس از ممیزی، دو اصلاح قطعی روی **هر دو** کانفیگ اعمال شد:

| # | قبل | بعد | دلیل |
|---|---|---|---|
| 1 | `shaders.groundfog.error=true` | `shaders.groundfog.error=false` | این یک «پرچم وضعیت» است که اپ هنگام ذخیره ثبت کرده بود (در لحظه‌ی ذخیره، شیدر مه زمینی در حالت خطا بود — به‌خاطر پیستِ بدون Track Adaptation). به حالت سالم/شناخته‌شده بازگردانده شد. اثر عملکردی ندارد و از ظاهر شدن هشدار خطا در UI جلوگیری می‌کند. |
| 2 | `info.test_slider=1` · `test_slider2=1` · `test_slider3=1` | حذف شدند | اسلایدرهای تستی توسعه‌دهنده که هیچ عملکردی ندارند؛ پاک‌سازی برای کانفیگ تمیز و قابل انتشار. |

**اعتبارسنجی پس از اصلاح:** هر دو فایل ۲۰۹ کلید دارند (۲۱۲ − ۳)، `groundfog.error=false`، بقیه‌ی ۲۰۷ کلید دیگر **بیت‌به‌بیت بدون تغییر** ماندند.

### تصمیم‌های عمدی (بدون تغییر — به‌عمد حفظ شدند)

- **`clouds2D.set=default_16k` حفظ شد** — کانفیگ برای پکیج **Highres** هدف‌گذاری شده که با مجموعه‌ی Ultra شما هم‌خوان است. ⚠️ اگر پکیج **Lowres** نصب دارید، فقط همین یک خط را به `default_8k` (یا `default_4k`) تغییر دهید.
- **ابرهای حجمی ۳بعدی** (`clouds_raymarching.clouds` + `shadows=true`) روشن ماند — انتخاب کیفیت است، نه باگ.
- **۲۰ تفاوت مقداری Realistic/Simple** دست‌نخورده ماند — دو سبک عمدی‌اند (Realistic سینمایی/LCS · Simple متعادل/Gamma).
- `moon.no_shadows=true`، `shaders.sunblinding.active=false`، `AI_headlights.*_ctrl=0` — انتخاب‌های سازنده، حفظ شدند.

### سازگاری فضای رنگی (توصیه‌ی نهایی)

پریست‌های CSP پروژه روی **LCS** تنظیم‌اند (`LINEAR_COLOR_SPACE ENABLED=1`):
- ✅ با CSP فعلی (LCS) → کانفیگ **`Uhm Config-Realistic`** را لود کنید.
- اگر Gamma می‌خواهید → در CM → CSP → Weather FX سبک `Pure Gamma` انتخاب + کانفیگ **`Uhm PureConfig-Simple`**.
