//
//  AccessStateReducer.swift
//  Climeet-iOS
//
//  Created by mac on 7/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AccessStateReducer {
    
    @ObservableState
    struct State: Equatable {
        var accessState: RevealState
        var selectedToggleIndex: Int
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case submitSelection
        case delegate(Delegate)
        enum Delegate {
            case selectAccessState(RevealState)
            case toggleIndex(Int)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .submitSelection:
                assignState(&state)
                return .run { [access = state.accessState] send in
                    await send(.delegate(.selectAccessState(access)))
                    await dismiss()
                }
            case .binding(_):
                return .none
            default:
                return .none
            }
        }
    }
    
    private func assignState(_ state: inout AccessStateReducer.State) {
        let indexOfWorld = 0
        let indexOfFollower = 1
        let indexOfOnlyMe = 2
        
        if state.selectedToggleIndex == indexOfWorld {
            state.accessState = .world
        } else if state.selectedToggleIndex == indexOfFollower {
            state.accessState = .followers
        } else if state.selectedToggleIndex == indexOfOnlyMe {
            state.accessState = .onlyMe
        }
    }
    
}
