//
//  ClimbingSetupView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/13/24.
//

import SwiftUI
import DesignSystem

struct ClimbingSetupView: View {
    var placeholderText: String
    var text: String
    var isEmpty: Bool
    
    var body: some View {
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
    }
}
