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
    }
    
    enum Action {
        case banner(BannerReducer.Action)
        case shortcut(HomeGymShortcutReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.banner, action: \.banner) {
            BannerReducer()
        }
        Scope(state: \.shortcut, action: \.shortcut) {
            HomeGymShortcutReducer()
        }
    }
}
