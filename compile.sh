#!/bin/bash
set -e

APP_NAME="NumGame"
BUNDLE_ID="com.example.NumGame"
APP_DIR="${APP_NAME}.app"
CONTENTS_DIR="${APP_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Creating App Bundle Structure..."
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "Compiling Swift Code..."
swiftc -parse-as-library GameApp.swift -o "$MACOS_DIR/$APP_NAME"

echo "Creating Info.plist..."
cat > "$CONTENTS_DIR/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
</dict>
</plist>
EOF

echo "Generating Emoji Icon with Transparency..."
# Create a swift script to render emoji to PNG
cat > render_icon.swift <<EOF
import AppKit

let emoji = "🔢"
let size: CGFloat = 1024

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
guard let context = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8, bytesPerRow: Int(size) * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { exit(1) }

let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
NSGraphicsContext.current = nsContext

let font = NSFont.systemFont(ofSize: size * 0.8)
let attributes: [NSAttributedString.Key: Any] = [.font: font]
let strObj = NSString(string: emoji)
let textSize = strObj.size(withAttributes: attributes)

let x = (size - textSize.width) / 2
let y = (size - textSize.height) / 2 - (size * 0.05)

strObj.draw(at: NSPoint(x: x, y: y), withAttributes: attributes)

guard let imageRef = context.makeImage() else { exit(1) }
let bitmapRep = NSBitmapImageRep(cgImage: imageRef)
guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else { exit(1) }
try? pngData.write(to: URL(fileURLWithPath: "icon.png"))
EOF

swift render_icon.swift

echo "Creating .icns file..."
mkdir -p icon.iconset
sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png

iconutil -c icns icon.iconset -o "$RESOURCES_DIR/AppIcon.icns"

echo "Cleaning up..."
rm -rf icon.iconset icon.png render_icon.py

echo "Done! You can now open $APP_DIR"
