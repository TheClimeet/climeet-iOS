//
//  CustomEditor.swift
//  Climeet-iOS
//
//  Created by mac on 7/3/24.
//

import SwiftUI

struct CustomTextEditorStyle: ViewModifier {
    let placeholder: String
    @Binding var text: String
    
    let size: CGSize
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
            content
                .font(.climeetFontParagraph6())
                .lineSpacing(5)
                .frame(width: size.width * width,
                       height: size.height * height,
                   alignment: .leading)
                .background(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            //MARK: Padding for cursor alignment
                            .padding(.leading, 3)
                            .padding(.top, 5)
                            .foregroundColor(.text06)
                            .font(.climeetFontParagraph6())
                    }
                }
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .scrollContentBackground(.hidden)
                .background(.climeetBackground)
                .foregroundColor(.text06)
                .font(.climeetFontParagraph6())
    }
}

extension TextEditor {
    func customStyleEditor(placeholder: String, userInput: Binding<String>, 
                           size: CGSize, width: CGFloat, height: CGFloat) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput, size: size, width: width, height: height))
    }
}
