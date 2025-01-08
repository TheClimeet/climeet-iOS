import SwiftUI

public struct FollowButton: View {
    var text: String
    var isFollow: Bool
    var action: () -> Void
    
    private var bgColor: Color { isFollow ? Color.climeetMain : Color.text03 }
    private var textColor: Color { isFollow ? Color.text09 : Color.levelWhite }
    
    public init(text: String, isFollow: Bool, action: @escaping () -> Void) {
        self.text = text
        self.isFollow = isFollow
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.climeetFontParagraph5())
                .kerning(0.2)
                .multilineTextAlignment(.center)
                .foregroundStyle(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 5.5)
                .background(bgColor)
        }
        .clipShape(.rect(cornerRadius: 8))
    }
}
