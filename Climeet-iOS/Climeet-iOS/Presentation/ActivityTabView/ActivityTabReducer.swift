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
        var selectedGym = Gym()
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case readViewSize(CGSize)
        case closeButtonTapped
        case selectGymButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in await dismiss() }
                
            case .readViewSize(let size):
                state.screenSize = size
                
                return .none

            case .selectGymButtonTapped:
                state.bottomSheetHeight = state.screenSize.height *
                SheetType.search.displaySizeRatio
            
                let reducerState = SearchReducer.State(
                    transitionType: .modal
                )
                state.destination = .searchGymSheet(reducerState)
                
                return .none
                
            case let .destination(.presented(.searchGymSheet(.delegate(.selectGym(gym))))):
                state.selectedGym = gym

                return .none
                
            case .destination:
                
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
