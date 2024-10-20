//
//  AuthReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthReducer {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case kakaoBtnDidTap
        case naverBtnDidTap
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .kakaoBtnDidTap:
                return .none
            case .naverBtnDidTap:
                return .none
            }
        }
    }
}
