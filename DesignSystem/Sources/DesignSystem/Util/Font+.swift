import SwiftUI

#if os(iOS)
extension Font {
    public static func climeetFontTitle1() -> Self {
        Self.custom("Pretendard-Bold", size: 30)
    }
    
    public static func climeetFontTitle2() -> Self {
        Self.custom("Pretendard-Bold", size: 28)
    }
    
    public static func climeetFontTitle3() -> Self {
        Self.custom("Pretendard-Bold", size: 20)
    }
    
    public static func climeetFontTitle3_5() -> Self {
        Self.custom("Pretendard-SemiBold", size: 20)
    }
    
    public static func climeetFontTitle4() -> Self {
        Self.custom("Pretendard-Bold", size: 18)
    }
    
    public static func climeetFontTitle4_5() -> Self {
        Self.custom("Pretendard-SemiBold", size: 18)
    }
    
    public static func climeetFontParagraph1() -> Self {
        Self.custom("Pretendard-SemiBold", size: 16)
    }
    
    public static func climeetFontParagraph2() -> Self {
        Self.custom("Pretendard-Medium", size: 16)
    }
    
    public static func climeetFontParagraph3() -> Self {
        Self.custom("Pretendard-Regular", size: 16)
    }
    
    public static func climeetFontParagraph4() -> Self {
        Self.custom("Pretendard-SemiBold", size: 14)
    }
    
    public static func climeetFontParagraph5() -> Self {
        Self.custom("Pretendard-Medium", size: 14)
    }
    
    public static func climeetFontParagraph6() -> Self {
        Self.custom("Pretendard-Regular", size: 14)
    }
    
    public static func climeetFontCaptionText1() -> Self {
        Self.custom("Pretendard-SemiBold", size: 12)
    }
    
    public static func climeetFontCaptionText2() -> Self {
        Self.custom("Pretendard-Medium", size: 12)
    }
    
    public static func climeetFontCaptionText3() -> Self {
        Self.custom("Pretendard-Regular", size: 12)
    }
    
    public static func climeetFontCustom(size: CGFloat, weight: Font.Weight) -> Self {
        switch weight {
        case .bold:
            Self.custom("Pretendard-Bold", size: size)
        case .semibold:
            Self.custom("Pretendard-SemiBold", size: size)
        case .medium:
            Self.custom("Pretendard-Medium", size: size)
        case .regular:
            Self.custom("Pretendard-Regular", size: size)
        default:
            Font.system(size: size, weight: weight)
        }
    }
}
#endif
