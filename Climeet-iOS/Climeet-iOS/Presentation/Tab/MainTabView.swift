//
//  TabView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/15/24.
//
import SwiftUI
import ComposableArchitecture
import DesignSystem

enum MainTab {
    case home
    case shorts
    case upload
    case activity
    case mypage
}

struct MainTabView: View {
    
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    // 홈화면
                    HomeView()
                case .shorts:
                    // 쇼츠화면
                    ShortsDeckView(store: Store(initialState: ShortsDeckReducer.State(), reducer: {
                        ShortsDeckReducer()
                    }))
                case .upload:
                    // 업로드화면
                    ShortsSelectView(store: Store(initialState: ShortsSelectReducer.State(), reducer: {
                        ShortsSelectReducer()
                    }))
                case .activity:
                    ActivityCalendarView(store: Store(initialState: ActivityCalendarReducer.State(), reducer: {
                        ActivityCalendarReducer()
                    }))
                    
                case .mypage:
                    // 마이페이지화면
                    SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
                        SearchReducer()
                    }))
                }
                CustomTabView(selectedTab: $selectedTab)
                    .frame(height: geometry.size.height * 0.0874)
                    .background(Color.levelBlack)
            }
        }
    }
}

#Preview {
    MainTabView()
}
