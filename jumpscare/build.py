#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
جامپ‌اسکر رو از قالب می‌سازه و خروجی‌ها رو توی پوشهٔ docs/ می‌ریزه
(پوشهٔ docs همان چیزی است که GitHub Pages از آن سایت می‌سازد).

خروجی‌ها:
  docs/index.html               -> نسخهٔ آنلاین (آدرس سایت: https://aliam664.github.io/shat/)
  docs/assets/*.jpg             -> تصاویر همان نسخه
  docs/jumpscare-single.html    -> نسخهٔ تک‌فایل (هم برای دانلود از همان سایت، هم برای فرستادن در چت)

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
DOCS = os.path.join(ROOT, "docs")

FACES = {
    "{{FACE1}}": ("scare_face.jpg", "scare_face.png"),
    "{{FACE2}}": ("scare_face2.jpg", "scare_face2.png"),
}


def read(path):
    with io.open(path, "r", encoding="utf-8") as fh:
        return fh.read()


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with io.open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    return path


def pick(*names):
    for n in names:
        p = os.path.join(ASSETS, n)
        if os.path.exists(p):
            return p
    raise SystemExit("فایل تصویر پیدا نشد: %s" % (names,))


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

    # ---- خروجی ۱: صفحهٔ آنلاین (تصاویر به صورت فایل جدا) ----
    online = tpl
    for token, names in FACES.items():
        src = pick(*names)
        dst = os.path.join(DOCS, "assets", os.path.basename(src))
        shutil.copyfile(src, dst)
        online = online.replace(token, "assets/" + os.path.basename(src))
    out_online = write(os.path.join(DOCS, "index.html"), online)

    # ---- خروجی ۲: تک‌فایل (تصاویر داخل خودش، برای چت و آفلاین) ----
    single = tpl
    for token, names in FACES.items():
        single = single.replace(token, data_uri(pick(*names)))
    out_single = write(os.path.join(DOCS, "jumpscare-single.html"), single)

    print("ساخته شد:")
    for p in (out_online, out_single):
        print("  %-46s %8.0f KB" % (os.path.relpath(p, ROOT), kb(p)))

    bad = [t for t in FACES if t in online or t in single]
    if bad:
        print("قالب‌جای‌گیر‌نشده:", bad, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
