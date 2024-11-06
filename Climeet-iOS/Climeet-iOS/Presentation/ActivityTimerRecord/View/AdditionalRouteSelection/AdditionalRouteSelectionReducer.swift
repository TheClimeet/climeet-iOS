//
//  AddtionalRouteSelectionReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/6/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdditionalRouteSelectionReducer {
    @ObservableState
    struct State {
        var selectedFilteredRoute: FilteredRoute?
        var attemtCount: Int = 0
        var routeSelectionState = RouteSelectionReducer.State(selectedGym: nil)
    }
    
    enum Action {
        case gymSet(Gym)
        case minusButtonTapped
        case plusButtonTapped
        case routeSelectionAction(RouteSelectionReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.routeSelectionState, action: \.routeSelectionAction) {
            RouteSelectionReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .gymSet(let gym): /// ActivityTimerRecordReducer에서 호출
                state.routeSelectionState.selectedGym = gym
                
                return .run { send in
                    await send(.routeSelectionAction(.gymSet))
                }
                
            case .minusButtonTapped:
                guard state.attemtCount > 0 else { return .none }
                
                state.attemtCount -= 1
                
                return .none
                
            case .plusButtonTapped:
                guard state.attemtCount < 15 else { return .none }
                
                state.attemtCount += 1
                
                return .none
                                
            case .routeSelectionAction(.filteredRouteChangeButtonTapped(let filteredRoute)):
                state.selectedFilteredRoute = filteredRoute
                
                return .none
                
            case .routeSelectionAction(_):
                return .none
            }
        }
    }
}
