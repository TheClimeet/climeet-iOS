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
        var selectedGym: Gym?
        var elapsedTimeInterval: TimeInterval?
        
        var activityTimerState = ActivityTimerReducer.State()
    }
    
    enum Action {
        case closeButtonTapped
        case activityTimerAction(ActivityTimerReducer.Action)
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Scope(
            state: \.activityTimerState, action: \.activityTimerAction) {
                ActivityTimerReducer()
            }
        
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in await dismiss() }
                
            case .activityTimerAction(.destination(.presented(.searchGymSheet(.delegate(.selectGym(let gym)))))):
                state.selectedGym = gym
                
                return .none
                
            case .activityTimerAction(.timeChanged(let timeInterval)):
                state.elapsedTimeInterval = timeInterval
                
                return .none
            
            default:
                return .none
            }
        }
    }
}
