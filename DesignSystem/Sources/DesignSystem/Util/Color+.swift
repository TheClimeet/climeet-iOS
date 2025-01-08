import SwiftUI

extension Color {
    public init?(hex: String) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0
                    self.init(red: r, green: g, blue: b, opacity: a)
                    return
                }
            }
        }
        return nil
    }
}

#if os(iOS)
extension Color {
    // Common
    public static let climeetBackground = Color(.climeetBackground)
    public static let climeetMain = Color(.climeetMain)
    public static let errorText = Color(.errorText)
    public static let grayButton = Color(.grayButton)
    public static let textSpaceHolder = Color(.textSpaceHolder)
    
    // Level
    public static let levelBlack = Color(.levelColorBlack)
    public static let levelBlue = Color(.levelColorBlue)
    public static let levelBrown = Color(.levelColorBrown)
    public static let levelDarkBlue = Color(.levelColorDarkBlue)
    public static let levelGray = Color(.levelColorGray)
    public static let levelGreen = Color(.levelColorGreen)
    public static let levelOrange = Color(.levelColorOrange)
    public static let levelPink = Color(.levelColorPink)
    public static let levelPurple = Color(.levelColorPurple)
    public static let levelRed = Color(.levelColorRed)
    public static let levelSkyBlue = Color(.levelColorSkyblue)
    public static let levelWhite = Color(.levelColorWhite)
    public static let levelYellow = Color(.levelColorYellow)
    
    // Shorts
    public static let shorsUploadPartialBackground = Color(.shorsUploadPartialBackground)
    
    // Star
    public static let starFilledEyes = Color(.starFilledEyes)
    public static let starFilled = Color(.starFilled)
    public static let starNotFilledEyes = Color(.starNotfilledEyes)
    public static let starNotFilled = Color(.starNotfilled)
    
    // Text
    public static let text00 = Color(.textWhite)
    public static let text01 = Color(.text01)
    public static let text02 = Color(.text02)
    public static let text03 = Color(.text03)
    public static let text04 = Color(.text04)
    public static let text05 = Color(.text05)
    public static let text06 = Color(.text06)
    public static let text06_5 = Color(.text65)
    public static let text07 = Color(.text07)
    public static let text08 = Color(.text08)
    public static let text09 = Color(.text09)
    
    // unnamed
    public static let gray72 = Color(.unnamedGray72)
    public static let gray103 = Color(.unnamedGray103)
    public static let gray217 = Color(.unnamedGray217)
}
#endif
