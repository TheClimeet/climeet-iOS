//
//  HomeReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/28/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeReducer {
    @ObservableState
    struct State: Equatable {
        var banner = BannerReducer.State()
        var shortcut = HomeGymShortcutReducer.State()
        var bestClimber = HomeBestClimberReducer.State()
        var popularGym = WeeklyPopularGymReducer.State()
    }
    
    enum Action {
        case banner(BannerReducer.Action)
        case shortcut(HomeGymShortcutReducer.Action)
        case bestClimber(HomeBestClimberReducer.Action)
        case popularGym(WeeklyPopularGymReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.banner, action: \.banner) {
            BannerReducer()
        }
        Scope(state: \.shortcut, action: \.shortcut) {
            HomeGymShortcutReducer()
        }
        Scope(state: \.bestClimber, action: \.bestClimber) {
            HomeBestClimberReducer()
        }
        Scope(state: \.popularGym, action: \.popularGym) {
            WeeklyPopularGymReducer()
        }
    }
}
