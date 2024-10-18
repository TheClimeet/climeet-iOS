//
//  HomeHeader.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import DesignSystem

struct HomeHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("클밋")
                .font(.climeetFontTitle3())
                .fontWeight(.bold)
                .foregroundStyle(Color.text00)
            Spacer()
            Image(.homeSearch)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color.climeetBackground
        HomeHeader()
    }
}
