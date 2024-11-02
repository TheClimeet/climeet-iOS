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
    }
    
    enum Action {
        case banner(BannerReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.banner, action: \.banner) {
            BannerReducer()
        }
    }
}
