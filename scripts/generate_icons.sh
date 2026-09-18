#!/bin/bash
set -e

SRC="assets/icons/app_icon.png"
IOS_DIR="ios/Runner/Assets.xcassets/AppIcon.appiconset"
ANDROID_DIR="android/app/src/main/res"

echo "Generating iOS App Icons..."
sips -z 1024 1024 "$SRC" --out "$IOS_DIR/Icon-App-1024x1024@1x.png"
sips -z 20 20 "$SRC" --out "$IOS_DIR/Icon-App-20x20@1x.png"
sips -z 40 40 "$SRC" --out "$IOS_DIR/Icon-App-20x20@2x.png"
sips -z 60 60 "$SRC" --out "$IOS_DIR/Icon-App-20x20@3x.png"
sips -z 29 29 "$SRC" --out "$IOS_DIR/Icon-App-29x29@1x.png"
sips -z 58 58 "$SRC" --out "$IOS_DIR/Icon-App-29x29@2x.png"
sips -z 87 87 "$SRC" --out "$IOS_DIR/Icon-App-29x29@3x.png"
sips -z 40 40 "$SRC" --out "$IOS_DIR/Icon-App-40x40@1x.png"
sips -z 80 80 "$SRC" --out "$IOS_DIR/Icon-App-40x40@2x.png"
sips -z 120 120 "$SRC" --out "$IOS_DIR/Icon-App-40x40@3x.png"
sips -z 120 120 "$SRC" --out "$IOS_DIR/Icon-App-60x60@2x.png"
sips -z 180 180 "$SRC" --out "$IOS_DIR/Icon-App-60x60@3x.png"
sips -z 76 76 "$SRC" --out "$IOS_DIR/Icon-App-76x76@1x.png"
sips -z 152 152 "$SRC" --out "$IOS_DIR/Icon-App-76x76@2x.png"
sips -z 167 167 "$SRC" --out "$IOS_DIR/Icon-App-83.5x83.5@2x.png"

echo "Generating Android Icons..."
mkdir -p "$ANDROID_DIR/mipmap-mdpi" "$ANDROID_DIR/mipmap-hdpi" "$ANDROID_DIR/mipmap-xhdpi" "$ANDROID_DIR/mipmap-xxhdpi" "$ANDROID_DIR/mipmap-xxxhdpi"
sips -z 48 48 "$SRC" --out "$ANDROID_DIR/mipmap-mdpi/ic_launcher.png"
sips -z 72 72 "$SRC" --out "$ANDROID_DIR/mipmap-hdpi/ic_launcher.png"
sips -z 96 96 "$SRC" --out "$ANDROID_DIR/mipmap-xhdpi/ic_launcher.png"
sips -z 144 144 "$SRC" --out "$ANDROID_DIR/mipmap-xxhdpi/ic_launcher.png"
sips -z 192 192 "$SRC" --out "$ANDROID_DIR/mipmap-xxxhdpi/ic_launcher.png"

echo "All icons generated successfully!"
