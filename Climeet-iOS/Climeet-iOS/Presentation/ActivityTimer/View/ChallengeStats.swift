//
//  ChallengeStats.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/27/24.
//

import SwiftUI
import DesignSystem

struct ChallengeStats: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Stat(stat: "--", title: "도전")
            Spacer()
            Stat(stat: "6", title: "완등")
            Spacer()
            Stat(stat: "V6+", title: "평균레벨")
        }
        .padding(.horizontal, 20)
        .font(.climeetFontTitle3())
        .foregroundColor(.levelWhite)
    }
}

struct Stat: View {
    let stat: String
    let title: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("\(stat)")
                .font(.climeetFontTitle1())
            Text("\(title)")
                .font(.climeetFontTitle3())
        }
    }
}

#Preview {
    ChallengeStats()
}
