//
//  NSColor+Hex.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Cocoa

extension NSColor {
    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)

        return hexString as String
    }
}

extension NSColor {
    /// Initialises NSColor from a hexadecimal string. Color is clear if string is invalid.
    /// - Parameter fromHex: supported formats are "#RGB", "#RGBA", "#RRGGBB", "#RRGGBBAA", with or without the # character
    public convenience init(fromHex:String) {
        var r = 0, g = 0, b = 0, a = 255
        let offset = fromHex.hasPrefix("#") ? 1 : 0
        let ch = fromHex.map{$0}

        switch(ch.count - offset) {
        case 8:
            a = 16 * (ch[offset+6].hexDigitValue ?? 0) + (ch[offset+7].hexDigitValue ?? 0)
            fallthrough
        case 6:
            r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
            g = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
            b = 16 * (ch[offset+4].hexDigitValue ?? 0) + (ch[offset+5].hexDigitValue ?? 0)
            break
        case 4:
            a = 16 * (ch[offset+3].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
            fallthrough
        case 3:  // Three digit #0D3 is the same as six digit #00DD33
            r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+0].hexDigitValue ?? 0)
            g = 16 * (ch[offset+1].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
            b = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+2].hexDigitValue ?? 0)
            break
        default:
            a = 255
            break
        }

        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
}
