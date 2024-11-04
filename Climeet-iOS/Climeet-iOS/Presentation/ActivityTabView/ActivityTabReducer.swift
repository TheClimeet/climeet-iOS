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
    @Reducer
    enum Destination {
        case searchGymSheet(SearchReducer)
    }
    
    @ObservableState
    struct State {
        var screenSize = CGSize(width: 0, height: 0)
        var bottomSheetHeight: CGFloat = 0.0
        var elapsedTimeInterval: TimeInterval?
        var activityTimerRecordState = ActivityTimerRecordReducer.State()
        var activityTimerState = ActivityTimerReducer.State()
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case readViewSize(CGSize)
        case closeButtonTapped
        case activityTimerRecordAction(ActivityTimerRecordReducer.Action)
        case activityTimerAction(ActivityTimerReducer.Action)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Scope(state: \.activityTimerState, action: \.activityTimerAction) {
            ActivityTimerReducer()
        }
        Scope(state: \.activityTimerRecordState, action: \.activityTimerRecordAction) {
            ActivityTimerRecordReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .readViewSize(let size):
                state.screenSize = size
                
                return .none
                
            case .closeButtonTapped:
                return .run { _ in await dismiss() }
                
            case .activityTimerAction(.timeChanged(let timeInterval)):
                state.elapsedTimeInterval = timeInterval
                
                return .none
                
            case .activityTimerAction(.gymSelectionButtonTapped), .activityTimerRecordAction(.gymSelectionButtonTapped):
                state.bottomSheetHeight = state.screenSize.height *
                SheetType.search.displaySizeRatio
                
                let reducerState = SearchReducer.State(
                    transitionType: .modal
                )
                state.destination = .searchGymSheet(reducerState)
                
                return .none
                
            case .destination(.presented(.searchGymSheet(.delegate(.selectGym(let gym))))):
                
                return .run { send in
                    await send(.activityTimerAction(.gymSet(gym)))
                    await send(.activityTimerRecordAction(.gymSet(gym)))
                }
                
            case .destination:
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}
