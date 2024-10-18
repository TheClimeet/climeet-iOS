//
//  ClimbingSetupButton.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/13/24.
//

import SwiftUI
import DesignSystem

struct ClimbingSetupButton: View {
    var placeholderText: String
    var text: String
    var isEmpty: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Text(isEmpty ? placeholderText : text)
                    .font(.climeetFontParagraph2())
                    .foregroundColor(
                        isEmpty ? .starNotFilledEyes : .levelWhite
                    )
                    .padding(.leading, 18)
                
                Spacer()
                
                Image(uiImage: UIImage(named: "activity_arrow_right") ?? UIImage())
                    .padding(.trailing, 20)
            }
        })
        .frame(maxWidth: .infinity, minHeight: 48)
        .background(Color.text08)
        .cornerRadius(5)
    }
}
