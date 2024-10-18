//
//  ShowAllButton.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct ShowAllButton: View {
    var body: some View {
        HStack(spacing: 6) {
            Text("전체보기")
                .font(.climeetFontCaptionText2())
                .foregroundStyle(Color.text00)
            Image(.homeArrowRight)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 12)
        }
    }
}

#Preview {
    ShowAllButton()
        .background(Color.climeetBackground)
}
