import SwiftUI

public struct BorderButton: View {
    var size: CGFloat
    var text: String
    var font: Font
    var action: () -> Void
    var disabled: Bool
    
    private var textColor: Color { disabled ? Color.text05 : Color.text00 }
    
    public init(size: CGFloat, text: String, font: Font, action: @escaping () -> Void, disabled: Bool) {
        self.size = size
        self.text = text
        self.font = font
        self.action = action
        self.disabled = disabled
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(font)
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: size)
                .background(.clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.text05, lineWidth: 1)
                }
        }
        .disabled(disabled)
    }
}
