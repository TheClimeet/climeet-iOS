//
//  WeeklyPopularGymView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

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

struct WeeklyPopularGymView: View {
    @Bindable var store: StoreOf<WeeklyPopularGymReducer>
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
        .onFirstAppear {
            store.send(.onFirstAppear)
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
                .onTapGesture {
                    selectedTab = .follower
                }
            
            Text("기록순")
                .font(.climeetFontCaptionText3())
                .foregroundStyle(selectedTab == .record ? Color.text09 : Color.starNotFilled)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(selectedTab == .record ? Color.climeetMain : Color.text06_5)
                }
                .onTapGesture {
                    selectedTab = .record
                }
            Spacer()
        }
    }
    
    private var gymIcons: some View {
        ScrollView(.horizontal) {
            switch selectedTab {
            case .follower:
                if store.bestFollowGym.isEmpty {
                    Text("암장 정보가 없습니다")
                        .frame(height: 134)
                        .foregroundStyle(.white)
                } else {
                    HStack(spacing: 8) {
                        ForEach(store.bestFollowGym) { gymInfo in
                            GymIcon(
                                rank: gymInfo.rank,
                                profileImageURL: gymInfo.profileImageURL,
                                gymName: gymInfo.name,
                                description: "팔로워 \(gymInfo.followerCount)"
                            )
                        }
                    }
                }
            case .record:
                if store.bestRecordGym.isEmpty {
                    Text("암장 정보가 없습니다")
                        .frame(height: 134)
                        .foregroundStyle(.white)
                } else {
                    HStack(spacing: 8) {
                        ForEach(store.bestRecordGym) { gymInfo in
                            GymIcon(
                                rank: gymInfo.rank,
                                profileImageURL: gymInfo.profileImageURL,
                                gymName: gymInfo.name,
                                description: "기록 \(gymInfo.selectionCount)"
                            )
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

fileprivate
struct GymIcon: View {
    let rank: Int
    let profileImageURL: String
    let gymName: String
    let description: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(rank)")
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
            KFImage(URL(string: profileImageURL))
                .placeholder {
                    Circle()
                        .foregroundStyle(.gray)
                        .frame(width: 45, height: 45)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .padding(.bottom, 10)
                .padding(.horizontal, 24)
            Text(gymName)
                .font(.climeetFontCaptionText2())
                .foregroundStyle(Color.text01)
                .padding(.bottom, 4)
            
            Text(description)
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.text01)
                .padding(.bottom, 18)
        }
        .frame(width: 94, height: 134)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.text07)
        }
    }
}

#Preview {
    let store = Store(initialState: WeeklyPopularGymReducer.State()) {
        WeeklyPopularGymReducer()
    }
    WeeklyPopularGymView(store: store)
        .background(Color.climeetBackground)
}
