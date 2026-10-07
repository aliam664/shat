/**
 * تست دودی (smoke test) برای صفحهٔ جامپ‌اسکر
 * -----------------------------------------------------------
 * کل مسیر صفحه را بدون مرورگر شبیه‌سازی می‌کند:
 *   دروازهٔ صدا → چت → شیت مجوز → ویدیو → جامپ‌اسکر → صفحهٔ پایان
 * و در همین حال:
 *   • یک AudioContext جعلی با اعتبارسنجی سخت‌گیرانه (NaN / رَمپ به صفر / زمان منفی)
 *   • تایمرهای جعلی تا کل تایم‌لاین ۳۵ ثانیه‌ای در چند میلی‌ثانیه اجرا شود
 *   • هر خطای uncaught را می‌گیرد و تست را fail می‌کند
 *
 * اجرا:
 *   cd jumpscare/test && npm i jsdom @sinonjs/fake-timers && node smoke.mjs
 *   (یا با NODE_PATH=/tmp/jstest/node_modules node jumpscare/test/smoke.mjs)
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { JSDOM, VirtualConsole } from "jsdom";
import FakeTimers from "@sinonjs/fake-timers";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const HTML = path.resolve(HERE, "../../docs/index.html");
const html = fs.readFileSync(HTML, "utf8");

const errors = [];
const audio = { osc: 0, gain: 0, buf: 0, filt: 0, conv: 0, panner: 0, comp: 0, shaper: 0, started: 0 };

/* ─────────── AudioContext جعلی با اعتبارسنجی ─────────── */
function makeAudioMock(){
  const bad = (msg) => { throw new Error("[AUDIO MOCK] " + msg); };
  const num = (v, where) => {            // برای زمان/مقدارهای عمومی: هر عدد متناهی مجاز است
    if (typeof v !== "number" || !isFinite(v)) bad(`${where}: مقدار نامعتبر ${v}`);
    return v;
  };
  const pos = (v, where) => {            // فقط رَمپ نمایی: باید > ۰ باشد
    num(v, where);
    if (v <= 0) bad(`${where}: رَمپ نمایی به صفر/منفی خطا می‌دهد: ${v}`);
    return v;
  };
  class Param{
    constructor(name){ this.name = name; this._v = 0; }
    get value(){ return this._v; }
    set value(v){ num(v, this.name + ".value"); this._v = v; }
    setValueAtTime(v,t){ num(v,this.name+".setValueAtTime"); num(t,this.name+".setValueAtTime(t)"); if(t<0) bad(this.name+".setValueAtTime: زمان منفی"); return this; }
    linearRampToValueAtTime(v,t){ num(v,this.name+".linearRamp"); num(t,this.name+".linearRamp(t)"); return this; }
    exponentialRampToValueAtTime(v,t){ pos(v,this.name+".expRamp"); num(t,this.name+".expRamp(t)"); return this; }
    setTargetAtTime(v,t,c){ num(v,this.name+".setTarget"); num(t,this.name+".setTarget(t)"); return this; }
    cancelScheduledValues(){ return this; }
  }
  const node = (extra = {}) => Object.assign({
    connect(dst){ return dst; },
    disconnect(){}, context: null,
  }, extra);

  class AudioContextMock{
    constructor(){ this.sampleRate = 48000; this.state = "running"; this._t0 = 0; }
    get currentTime(){ return num((Date.now() - this._t0) / 1000 + 0.001, "currentTime"); }
    resume(){ this.state = "running"; return Promise.resolve(); }
    close(){ this.state = "closed"; return Promise.resolve(); }
    createGain(){ audio.gain++; return node({ gain: new Param("gain") }); }
    createOscillator(){
      audio.osc++;
      return node({ type:"sine", frequency:new Param("frequency"), detune:new Param("detune"),
        start(t){ if(t!==undefined) num(t,"osc.start"); audio.started++; }, stop(t){ if(t!==undefined) num(t,"osc.stop"); } });
    }
    createBiquadFilter(){ audio.filt++; return node({ type:"lowpass", frequency:new Param("frequency"), Q:new Param("Q") }); }
    createBufferSource(){ audio.buf++; return node({ buffer:null, loop:false, start(t){ if(t!==undefined) num(t,"buf.start"); }, stop(){} }); }
    createBuffer(ch, len, rate){ num(len,"createBuffer.length"); return { length:len, numberOfChannels:ch, sampleRate:rate,
      getChannelData:() => new Float32Array(len) }; }
    createConvolver(){ audio.conv++; return node({ buffer:null }); }
    createWaveShaper(){ audio.shaper++; return node({ curve:null, oversample:"none" }); }
    createDynamicsCompressor(){ audio.comp++; return node({ threshold:new Param("threshold"), knee:new Param("knee"),
      ratio:new Param("ratio"), attack:new Param("attack"), release:new Param("release") }); }
    createStereoPanner(){ audio.panner++; return node({ pan:new Param("pan") }); }
  }
  return { AudioContextMock, destination: node({}) };
}

/* ─────────── راه‌اندازی jsdom ─────────── */
const vc = new VirtualConsole();
vc.on("jsdomError", (e) => { errors.push("jsdomError: " + (e.detail?.message || e.message)); });
vc.on("error", (...a) => { errors.push("console.error: " + a.join(" ")); });

const clock = FakeTimers.install({ toFake:["setTimeout","setInterval","clearTimeout","clearInterval","Date"], now: Date.UTC(2026,9,7,2,14,0) });

const { AudioContextMock } = makeAudioMock();
const dom = new JSDOM(html, {
  runScripts: "dangerously",
  pretendToBeVisual: true,
  url: "https://example.com/gift-cute/open",
  virtualConsole: vc,
  resources: "usable",
  beforeParse(win){
    win.AudioContext = AudioContextMock;
    win.webkitAudioContext = AudioContextMock;
    win.navigator.vibrate = () => true;
    win.matchMedia = () => ({ matches:false, addEventListener(){}, removeEventListener(){} });
    win.Element.prototype.requestFullscreen = function(){ win.document.fullscreenElement = this; return Promise.resolve(); };
    win.document.exitFullscreen = () => Promise.resolve();
    win.screen.orientation = { lock: () => Promise.resolve() };
    win.navigator.wakeLock = { request: () => Promise.resolve({ release(){} }) };
    win.URL.createObjectURL = () => "blob:mock";
    win.onerror = (msg) => { errors.push("window.onerror: " + msg); };
    win.addEventListener("unhandledrejection", e => errors.push("unhandledrejection: " + (e.reason?.message || e.reason)));
  },
});

const win = dom.window;
const doc = win.document;
const $ = (s) => doc.querySelector(s);
const on = (s) => !!$(s)?.classList.contains("on");
const wait = (ms) => clock.tickAsync(ms);

const results = [];
const check = (name, cond, extra="") => { results.push({ name, ok: !!cond, extra }); if(!cond) errors.push("CHECK FAILED: " + name + " " + extra); };

async function step(ms, chunk = 200){ for(let left = ms; left > 0; left -= chunk) await wait(Math.min(chunk, left)); }

(async () => {
  await wait(60);                                    // اسکریپت‌ها اجرا شوند

  /* ۱) دروازهٔ صدا */
  check("صفحهٔ اول (دروازهٔ صدا) دیده می‌شود", on("#gate"));
  check("تیتر صفحه واقع‌گرایانه است (پیام‌رسان)", doc.title === "پیام‌رسان", `title=${doc.title}`);

  /* ۲) ورود به چت */
  $("#gateBtn").dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  await step(400);
  check("اپ چت باز شد", on("#app"));
  check("دروازه بسته شد", !on("#gate"));

  /* ۳) داستان چت */
  await step(24000, 300);
  const bubbles = doc.querySelectorAll(".msg").length;
  const photos = doc.querySelectorAll(".bub img").length;
  const link = doc.querySelector(".linkcard");
  check("پیام‌های چت ساخته شدند (≥۷)", bubbles >= 7, `count=${bubbles}`);
  check("سه عکس (گربه/سگ/دوستان) نمایش داده شد", photos === 3, `imgs=${photos}`);
  check("کارت لینک ساخته شد", !!link);

  /* ۴) شیت مجوز */
  link.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  await step(300);
  check("شیت مجوز باز شد", on("#perm"));
  await step(4200, 500);
  check("شمارش معکوس تمام و دکمه فعال شد", $("#permGo").textContent.includes("شروع") && !$("#permGo").disabled);

  /* ۵) ویدیو */
  $("#permGo").dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  await step(900, 200);
  check("فاز ویدیوی found-footage شروع شد", on("#video"));
  check("تصویر اتاق ست شده", $("#room").src.includes("room-dark"));

  await step(11000, 400);
  check("زیرنویس‌های داستانی تایپ می‌شوند", ($("#caps").textContent || "").length > 0, `caps="${$("#caps").textContent}"`);
  check("شکل توی درگاه ظاهر شد (opacity>0)", parseFloat($("#roomGhost").style.opacity || "0") > 0, "ghost=" + $("#roomGhost").style.opacity);

  /* ۶) جامپ‌اسکر */
  await step(7500, 300);
  check("جامپ‌اسکر فعال شد", on("#scare"));
  check("چهرهٔ ۱ لود شد", /scare_face/.test($("#face").src), $("#face").src.slice(-30));

  await step(17000, 400);
  check("جامپ‌اسکر به پایان رسید", !on("#scare"));
  check("صفحهٔ پایان باز شد", on("#after"));
  check("شمارندهٔ قربانی پر شد", $("#stVictims").textContent === "1", `victims=${$("#stVictims").textContent}`);
  check("درصد شدت صدا گزارش شد", /\d+%/.test($("#stLoud").textContent), $("#stLoud").textContent);
  check("لینک دو نفره ساخته شد", $("#shareNote").innerHTML.includes("?r=1"));

  /* ۷) دکمهٔ تکرار */
  $("#againBtn").dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  await step(2500, 300);
  check("اجرای دوباره کار می‌کند", on("#scare"));

  /* ۸) آمار موتور صوتی */
  check("ریورب (Convolver) ساخته شد", audio.conv >= 1, `conv=${audio.conv}`);
  check("کمپرسور ساخته شد", audio.comp >= 1, `comp=${audio.comp}`);
  check("Soft-clip ساخته شد", audio.shaper >= 1, `shaper=${audio.shaper}`);
  check("پَنینگ استریو استفاده شد", audio.panner >= 1, `panner=${audio.panner}`);
  check("صدای کافی ساخته شد (≥۲۵ اسیلاتور)", audio.osc >= 25, `osc=${audio.osc}`);
  check("نویز بافر استفاده شد", audio.buf >= 3, `buf=${audio.buf}`);

  /* ─────────── گزارش ─────────── */
  const pass = results.filter(r => r.ok).length;
  console.log("\n────── نتیجهٔ تست ──────");
  for(const r of results) console.log(`${r.ok ? "✅" : "❌"} ${r.name}${r.extra ? "   [" + r.extra + "]" : ""}`);
  console.log(`\nموتور صدا: gain=${audio.gain} osc=${audio.osc} noise=${audio.buf} filter=${audio.filt} panner=${audio.panner} reverb=${audio.conv}`);
  console.log(`\n${pass}/${results.length} تست موفق`);
  if(errors.length){
    console.log("\n────── خطاها ──────");
    [...new Set(errors)].forEach(e => console.log("• " + e));
    process.exitCode = 1;
  } else {
    console.log("\n🎉 بدون هیچ خطای اجرایی");
  }
  clock.uninstall();
})().catch(e => { console.error("TEST CRASH:", e); process.exit(2); });
