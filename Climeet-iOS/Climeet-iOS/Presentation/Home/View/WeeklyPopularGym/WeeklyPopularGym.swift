//
//  WeeklyPopularGym.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

enum SortBy {
    case follower
    case record
    
    var title: String {
        switch self {
        case .follower:
            return "팔로워순"
        case .record:
            return "기록순"
        }
    }
}

struct WeeklyPopularGym: View {
    @State private var selectedTab: SortBy = .follower
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            segmentTab
                .padding(.leading, 16)
                .padding(.bottom, 15)
            gymIcons
        }
    }
    
    private var header: some View {
        HStack {
            Text("이번주 인기 암장")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
            ShowAllButton()
        }
    }
    
    private var segmentTab: some View {
        HStack(spacing: 10) {
            Text("팔로워순")
                .font(.climeetFontCaptionText3())
                .foregroundStyle(selectedTab == .follower ? Color.text09 : Color.starNotFilled)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(selectedTab == .follower ? Color.climeetMain : Color.text06_5)
                }
            
            Text("기록순")
                .font(.climeetFontCaptionText3())
                .foregroundStyle(selectedTab == .record ? Color.text09 : Color.starNotFilled)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(selectedTab == .record ? Color.climeetMain : Color.text06_5)
                }
            Spacer()
        }
    }
    
    private var gymIcons: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { _ in
                    GymIcon()
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

fileprivate
struct GymIcon: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("1")
                    .font(.climeetFontCaptionText3())
                    .foregroundStyle(Color.text00)
                    .padding(.horizontal, 3)
                    .padding(.vertical, 2)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .foregroundStyle(Color.text06_5)
                    }
                Spacer()
            }
            .padding(.leading, 5)
            .padding(.top, 7)
            .padding(.bottom, 8)
            Image(.activitytabEllipse)
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .padding(.bottom, 10)
                .padding(.horizontal, 24)
            Text("더클라임 연남")
                .font(.climeetFontCaptionText2())
                .foregroundStyle(Color.text01)
                .padding(.bottom, 4)
            Text("팔로워 20202")
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.text01)
                .padding(.bottom, 18)
        }
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.text07)
        }
    }
}

#Preview {
    WeeklyPopularGym()
        .background(Color.climeetBackground)
}
