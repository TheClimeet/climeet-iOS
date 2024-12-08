//
//  ShortsButton.swift
//  Climeet-iOS
//
//  Created by mac on 11/22/24.
//

import Foundation
import SwiftUI

struct ShortsDefaultButton: View {
    let title: String
    let foregroundColor: Color
    let backgroundColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.climeetFontTitle4())
                .foregroundStyle(foregroundColor)
        })
        .frame(height: 41)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(5)
    }
}

#Preview {
    HStack(spacing: 10) {
        ShortsDefaultButton(title: "취소",
                            foregroundColor: .white,
                            backgroundColor: .text065) {
           // dismiss()
        }
        
        ShortsDefaultButton(title: "적용하기",
                            foregroundColor: .black,
                            backgroundColor: .climeetMain) {
            
        }
    }
    .padding()
}
