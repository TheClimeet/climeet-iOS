import SwiftUI

/// SearchBar UI (회원가입/로그인)
public struct AuthSearchBar: View {
    var placeholder: String
    @Binding var text: String
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.levelWhite)
                .frame(width: 14, height: 14)
            
            HStack {
                TextField(
                    placeholder,
                    text: $text,
                    prompt: Text(placeholder).foregroundColor(Color.text02)
                )
                .autocorrectionDisabled(true)
                .foregroundColor(Color.levelWhite)
                
                Image(.highlightOff)
                    .foregroundStyle(Color.levelWhite)
                    .opacity(text.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        text = ""
                        UIApplication.shared.endEditing()
                    }
            }
        }
        .font(.climeetFontParagraph5())
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.text06)
        )
    }
}
