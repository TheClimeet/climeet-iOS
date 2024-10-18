//
//  WeeklyPopularRout.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct WeeklyPopularRout: View {
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            scrollView
        }
    }
    
    private var header: some View {
        HStack {
            Text("이번주 인기 루트")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
            ShowAllButton()
        }
    }
    
    private var scrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<6, id: \.self) { _ in
                    RouteView()
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

fileprivate
struct RouteView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(.contentMypage)
                .resizable()
                .scaledToFit()
                .frame(width: 84, height: 107)
                .padding(.bottom, 7)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Image(.shortsUploadLocationAdd)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    Text("더클라임 연남")
                        .font(.climeetFontCaptionText2())
                        .foregroundStyle(Color.text00)
                }
                .padding(.vertical, 2.5)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 99)
                        .foregroundStyle(Color.text07)
                }
                
                HStack(spacing: 2) {
                    Image(.activitytimerMap)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    Text("툇마루")
                        .font(.climeetFontCaptionText2())
                        .foregroundStyle(Color.text00)
                }
                .padding(.vertical, 2.5)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 99)
                        .foregroundStyle(Color.text07)
                }
            }
        }
    }
}

#Preview {
    WeeklyPopularRout()
        .background(Color.climeetBackground)
}
