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
    
    private let shortsDeckStore = Store(initialState: ShortsDeckReducer.State(), reducer: {
        ShortsDeckReducer()
    })
    
    private let shortsSelectStore = Store(initialState: ShortsSelectReducer.State(), reducer: {
        ShortsSelectReducer()
    })
    
    private let activityCalenderStore = Store(initialState: ActivityCalendarReducer.State(), reducer: {
        ActivityCalendarReducer()
    })
    
    private let searchStore = Store(initialState: SearchReducer.State(), reducer: {
        SearchReducer()
    })
    
    private let activityCalendarStore = Store(
        initialState: ActivityCalendarReducer.State(), reducer: {
            ActivityCalendarReducer()
        })
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeView()
                case .shorts:
                    ShortsDeckView(store: shortsDeckStore)
                case .upload:
                    ShortsSelectView(store: shortsSelectStore)
                case .activity:
                    ActivityCalendarView(store: activityCalendarStore)
                case .mypage:
                    SearchView(store: searchStore)
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
