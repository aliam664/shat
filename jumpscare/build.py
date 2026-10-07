#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
جامپ‌اسکر رو از قالب می‌سازه و دو خروجی می‌ده:

  1) jumpscare/jumpscare.html            -> نسخهٔ پوشه‌ای (تصاویر به صورت فایل جدا)
  2) jumpscare/dist/jumpscare-single.html -> نسخهٔ تک‌فایل (تصاویر به صورت base64 داخل خودش)

اجرا:  python3 jumpscare/build.py
"""
import base64
import io
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TPL = os.path.join(HERE, "src", "template.html")
ASSETS = os.path.join(HERE, "assets")
DIST = os.path.join(HERE, "dist")

FACES = {
    "{{FACE1}}": ("scare_face.jpg", "scare_face.png"),
    "{{FACE2}}": ("scare_face2.jpg", "scare_face2.png"),
}


def read(path):
    with io.open(path, "r", encoding="utf-8") as fh:
        return fh.read()


def write(path, text):
    with io.open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    return path


def pick(*names):
    """اولین فایل موجود از بین نام‌ها."""
    for n in names:
        p = os.path.join(ASSETS, n)
        if os.path.exists(p):
            return p
    raise SystemExit("فایل تصویر پیدا نشد: %s" % (names,))


def data_uri(path):
    name = os.path.basename(path).lower()
    mime = "image/png" if name.endswith(".png") else "image/jpeg"
    with open(path, "rb") as fh:
        return "data:%s;base64,%s" % (mime, base64.b64encode(fh.read()).decode("ascii"))


def main():
    if not os.path.exists(TPL):
        raise SystemExit("قالب پیدا نشد: %s" % TPL)

    tpl = read(TPL)
    os.makedirs(DIST, exist_ok=True)

    # ---- خروجی ۱: نسخهٔ پوشه‌ای (سبک‌تر، برای باز کردن روی کامپیوتر) ----
    folder = tpl
    for token, names in FACES.items():
        path = pick(*names)
        folder = folder.replace(token, "assets/" + os.path.basename(path))
    out1 = write(os.path.join(HERE, "jumpscare.html"), folder)

    # ---- خروجی ۲: نسخهٔ تک‌فایل (برای فرستادن در واتساپ/تلگرام) ----
    single = tpl
    sizes = {}
    for token, names in FACES.items():
        path = pick(*names)
        sizes[token] = os.path.getsize(path)
        single = single.replace(token, data_uri(path))
    out2 = write(os.path.join(DIST, "jumpscare-single.html"), single)

    print("ساخته شد:")
    for p in (out1, out2):
        print("  %-62s %8.0f KB" % (os.path.relpath(p, os.path.dirname(HERE)), os.path.getsize(p) / 1024.0))
    leftovers = [t for t in FACES if t in folder or t in single]
    if leftovers:
        print("قالب‌جای‌گیرنشده:", leftovers, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
