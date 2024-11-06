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
        var selectedFilteredRoute: FilteredRoute?
        
        var recordsListState = RecordsListReducer.State()
        var additionalRouteSelectionState = AdditionalRouteSelectionReducer.State()
    }
    
    enum Action {
        case gymSelectionButtonTapped
        case gymSet(Gym)
        case recordsListAction(RecordsListReducer.Action)
        case additionalRouteSelectionAction(AdditionalRouteSelectionReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.additionalRouteSelectionState, action: \.additionalRouteSelectionAction) {
            AdditionalRouteSelectionReducer()
        }
        
        Scope(state: \.recordsListState, action: \.recordsListAction) {
            RecordsListReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .gymSelectionButtonTapped: /// ActivityTabReducer에서 액션처리
                return .none
                
            case .gymSet(let gym): /// ActivityTabReducer 에서 호출
                state.selectedGym = gym
                
                return .run { [gym = state.selectedGym] send in
                    guard let gym else {
                        print("짐이설정되지않음")
                        return
                    }
                    
                    await send(.additionalRouteSelectionAction(.gymSet(gym)))
                }
            
            case .additionalRouteSelectionAction(.filteredRouteButtonTapped(let route)):
                state.selectedFilteredRoute = route
                
                return .run { send in
                    await send(.recordsListAction(.addRouteRecord(route)))
                }
                
            case .additionalRouteSelectionAction(_):
                return .none
            case .recordsListAction(_):
                return .none
            }
        }
    }
}
