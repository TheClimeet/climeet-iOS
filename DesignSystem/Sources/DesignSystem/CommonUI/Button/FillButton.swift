import SwiftUI

public struct FillButton: View {
    var size: CGFloat
    var text: String
    var font: Font
    var action: () -> Void
    var disabled: Bool
    
    private var backgroundColor: Color { disabled ? Color.climeetMain : Color.text03 }
    
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
                .foregroundStyle(Color.text09)
                .frame(maxWidth: .infinity)
                .frame(height: size)
                .background(backgroundColor)
        }
        .clipShape(.rect(cornerRadius: 8))
        .disabled(disabled)
    }
}
