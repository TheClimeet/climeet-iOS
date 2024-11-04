//
//  ActivityTimerRecordReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActivityTimerRecordReducer {
    @ObservableState
    struct State {
        var selectedGym: Gym?
        var routeSelectionState = RouteSelectionReducer.State(selectedGym: nil)
    }
    
    enum Action {
        case gymSelectionButtonTapped
        case gymSet(Gym)
        case routeSelectionAction(RouteSelectionReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.routeSelectionState, action: \.routeSelectionAction) {
            RouteSelectionReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .gymSelectionButtonTapped:
                return .none
            case .gymSet(let gym):
                state.selectedGym = gym
                state.routeSelectionState.selectedGym = gym
                
                return .run { send in
                    await send(.routeSelectionAction(.gymSet))
                }
                
            case .routeSelectionAction:
                return .none
            }
        }
    }
    
}
