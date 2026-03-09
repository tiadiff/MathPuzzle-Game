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
