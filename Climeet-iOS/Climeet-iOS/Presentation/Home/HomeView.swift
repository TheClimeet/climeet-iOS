//
//  HomeView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>
    
    var body: some View {
        ZStack {
            Color.climeetBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HomeHeaderView()
                        .padding(.vertical, 30)
                    BannerView(store: store.scope(state: \.banner, action: \.banner))
                        .padding(.bottom, 48)
                    HomeGymShortcutView(store: store.scope(state: \.shortcut, action: \.shortcut))
                        .padding(.bottom, 48)
                    HomeBestClimberView(store: store.scope(state: \.bestClimber, action: \.bestClimber))
                        .padding(.bottom, 48)
                    WeeklyPopularShortsView()
                        .padding(.bottom, 48)
                    WeeklyPopularGymView(store: store.scope(state: \.popularGym, action: \.popularGym))
                        .padding(.bottom, 48)
                    WeeklyPopularRoutView()
                        .padding(.bottom, 120)
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    let store = StoreOf<HomeReducer>(initialState: HomeReducer.State()) {
        HomeReducer()
    }
    HomeView(store: store)
}
