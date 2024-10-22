//
//  ActivityTabReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActivityTabReducer {
    @ObservableState
    struct State {
        var selectedGym = Gym()
    }
    
    enum Action {
        case closeButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in await dismiss() }
            }
        }
    }
}
