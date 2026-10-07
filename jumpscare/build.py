#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
جامپ‌اسکر رو از قالب می‌سازه و خروجی‌ها رو توی پوشهٔ docs/ می‌ریزه
(پوشهٔ docs همان چیزی است که GitHub Pages از آن سایت می‌سازد).

خروجی‌ها:
  docs/index.html              -> نسخهٔ آنلاین (با تصاویر باکیفیت جدا)
  docs/assets/*                -> همان تصاویر
  docs/jumpscare-single.html   -> تک‌فایل (تصاویر سبک، base64 داخل خودش)

نکته: برای تک‌فایل از assets/light/ استفاده می‌شود تا حجم کم بماند؛
      اگر light نبود، همان تصاویر اصلی استفاده می‌شوند.

اجرا:  python3 jumpscare/build.py
"""
import base64
import io
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
TPL = os.path.join(HERE, "src", "template.html")
ASSETS = os.path.join(HERE, "assets")
LIGHT = os.path.join(ASSETS, "light")
DOCS = os.path.join(ROOT, "docs")

# توکن قالب -> (نام فایل مطلوب, جایگزین‌های قابل قبول)
IMAGES = {
    "{{IMG_CAT}}":     ["photo-cat.jpg", "photo-cat.png"],
    "{{IMG_PUPPY}}":   ["photo-puppy.jpg", "photo-puppy.png"],
    "{{IMG_FRIENDS}}": ["photo-friends.jpg", "photo-friends.png"],
    "{{IMG_ROOM}}":    ["room-dark.jpg", "room-dark.png"],
    "{{FACE1}}":       ["scare_face.jpg", "scare_face.png"],
    "{{FACE2}}":       ["scare_face2.jpg", "scare_face2.png"],
}


def read(path):
    with io.open(path, "r", encoding="utf-8") as fh:
        return fh.read()


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with io.open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    return path


def pick(names, light=False):
    """مسیر فایل را از بین نام‌های ممکن پیدا می‌کند (اول نسخهٔ سبک)."""
    for base in ([LIGHT, ASSETS] if light else [ASSETS]):
        for n in names:
            p = os.path.join(base, n)
            if os.path.exists(p):
                return p
    return None


def data_uri(path):
    mime = "image/png" if path.lower().endswith(".png") else "image/jpeg"
    with open(path, "rb") as fh:
        return "data:%s;base64,%s" % (mime, base64.b64encode(fh.read()).decode("ascii"))


def kb(path):
    return os.path.getsize(path) / 1024.0


def main():
    if not os.path.exists(TPL):
        raise SystemExit("قالب پیدا نشد: %s" % TPL)

    tpl = read(TPL)
    os.makedirs(os.path.join(DOCS, "assets"), exist_ok=True)

    # ---- خروجی ۱: نسخهٔ آنلاین ----
    online = tpl
    for token, names in IMAGES.items():
        src = pick(names, light=False)
        if not src:
            raise SystemExit("تصویر پیدا نشد برای %s (%s)" % (token, names))
        dst = os.path.join(DOCS, "assets", os.path.basename(src))
        shutil.copyfile(src, dst)
        online = online.replace(token, "assets/" + os.path.basename(src))
    out_online = write(os.path.join(DOCS, "index.html"), online)

    # ---- خروجی ۲: تک‌فایل ----
    single = tpl
    for token, names in IMAGES.items():
        src = pick(names, light=True)
        if not src:
            raise SystemExit("تصویر پیدا نشد برای %s (%s)" % (token, names))
        single = single.replace(token, data_uri(src))
    out_single = write(os.path.join(DOCS, "jumpscare-single.html"), single)

    print("ساخته شد:")
    for p in (out_online, out_single):
        print("  %-42s %8.0f KB" % (os.path.relpath(p, ROOT), kb(p)))

    leftovers = [t for t in IMAGES if t in online or t in single]
    if leftovers:
        print("قالب‌جای‌گیر‌نشده:", leftovers, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
