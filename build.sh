#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
APP="build/老牧师桌宠.app"
for asset in Assets/face.png Assets/AppIcon.icns Assets/clips.json Assets/good-boy.mp3; do
  if [ ! -f "$asset" ]; then echo "缺少素材：$asset；请先阅读 README.md" >&2; exit 1; fi
done
for id in 01 02 03 04 05 06 07 08; do
  if [ ! -f "Assets/Clips/$id.m4a" ]; then echo "缺少语录：Assets/Clips/$id.m4a" >&2; exit 1; fi
done
for id in 6954 6957 6971 6958 6982 6983 6974 6978; do
  if [ ! -f "Assets/Expressions/IMG_$id.png" ]; then echo "缺少表情：Assets/Expressions/IMG_$id.png" >&2; exit 1; fi
done
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
swiftc -O -target arm64-apple-macosx14.0 -framework AppKit -framework AVFoundation Sources/main.swift Sources/SharedDance.swift Sources/UpdateChecker.swift -o "$APP/Contents/MacOS/LaomushiPet"
cp -R Assets/. "$APP/Contents/Resources/"
cp LICENSE-GoodThing "$APP/Contents/Resources/"
cp LICENSE-SunPet "$APP/Contents/Resources/"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>LaomushiPet</string>
<key>CFBundleIdentifier</key><string>local.laomushi.desktop-pet</string>
<key>CFBundleName</key><string>老牧师桌宠</string>
<key>CFBundleDisplayName</key><string>老牧师桌宠</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>CFBundleVersion</key><string>2</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>LSUIElement</key><true/>
<key>NSHighResolutionCapable</key><true/>
<key>CFBundleIconFile</key><string>AppIcon</string>
</dict></plist>
PLIST
codesign --force --sign - "$APP"
printf '已构建：%s\n' "$APP"
