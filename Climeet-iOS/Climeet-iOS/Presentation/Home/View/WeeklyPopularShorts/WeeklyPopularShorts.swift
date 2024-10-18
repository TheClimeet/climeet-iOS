//
//  WeeklyPopularShorts.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct WeeklyPopularShorts: View {
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            shorts
        }
    }
    
    private var header: some View {
        HStack {
            Text("이번주 인기 숏츠")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
            ShowAllButton()
        }
    }
    
    private var shorts: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 7.75) {
                ForEach(0..<8, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.gray)
                        .frame(width: 96, height: 160)
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

#Preview {
    WeeklyPopularShorts()
        .background(Color.climeetBackground)
}
