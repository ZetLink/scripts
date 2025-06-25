import requests
import re
import json
import os
import subprocess

TOKEN = '{TOKEN}'
CHANNEL_ID = '{CHANNEL_ID}' 
DEVICES = 'Moto G32 | G42 | G52'

def escape_md(text):
    return re.sub(r'([_\*\[\]\(\)~`>\#\+\-=|{}\.!])', r'\\\1', text)

# 📝 Ingreso de datos interactivos
print("🔧 Ingreso de datos para el mensaje de Telegram")

image_path = input("🖼️ Image Patch: ")

if not image_path.lower().endswith(".webp"):
    print("⚠️ La imagen no está en formato .webp. Se procederá a convertirla.")
    converted_image_path = "converted_image.webp"

    result = subprocess.run(
        ["python", "convert_to_webp.py", image_path, converted_image_path],
        capture_output=True,
        text=True
    )

    if result.returncode == 0:
        print(f"✅ Imagen convertida exitosamente: {converted_image_path}")
        image_path = converted_image_path
    else:
        print("❌ Error al convertir la imagen:")
        print(result.stderr)
        exit(1)
else:
    print("✅ La imagen ya está en formato .webp.")

rom_name = input("📱 ROM Name: ")
rom_version = input("🔢 ROM Version: ")
patch_date = input("📅 ROM Patch: ")

download_link_g32 = input("🔗 Download Link G32: ")
download_link_g42 = input("🔗 Download Link G42: ")
download_link_g52 = input("🔗 Download Link G52: ")

screenshots_link = input("🖼️ Screenshots Link: ")

rom_full_name = f"{rom_name} {rom_version}"

message = f"""*{escape_md(rom_full_name)}* \\| Android 15 QPR2
Supported Devices: {escape_md(DEVICES)}
Maintainer: [ZetLink](https://t.me/ZetLinkUwU)
Donations: [Here](https://linktr.ee/zetlink)

◾️Installation:
    \\- [English](https://android-guides.vercel.app/extra/install-rom)
    \\- [Español](https://android-guides.vercel.app/es/extra/install-rom)
◾️Changelogs:
    \\- Vanilla build
    \\- {escape_md(patch_date)} patch
    \\- Added KernelSU NEXT
    \\- Added Dolby Atmos
    \\- Added MotoCam"""

buttons = {
    "inline_keyboard": [
        [
            {"text": "⬇️ G32", "url": download_link_g32},
            {"text": "⬇️ G42", "url": download_link_g42},
            {"text": "⬇️ G52", "url": download_link_g52}
        ],
        [
            {"text": "🖼️ Screenshots", "url": screenshots_link}
        ]
    ]
}

url = f"https://api.telegram.org/bot{TOKEN}/sendPhoto"
with open(image_path, 'rb') as photo:
    files = {'photo': photo}
    data = {
        "chat_id": CHANNEL_ID,
        "caption": message,
        "parse_mode": "MarkdownV2",
        "reply_markup": json.dumps(buttons)
    }
    response = requests.post(url, data=data, files=files)

if response.status_code == 200:
    print("✅ Imagen enviada correctamente con mensaje y botones.")
else:
    print("❌ Error al enviar la imagen:")
    print(response.text)