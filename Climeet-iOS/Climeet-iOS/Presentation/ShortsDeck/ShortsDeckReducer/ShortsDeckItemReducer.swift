//
//  ShortsDeckItemReducer.swift
//  Climeet-iOS
//
//  Created by mac on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ShortsDeckItemReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        /*
         case 000State(000Reducer)
         */
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegation)
        enum Delegation {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                /* destination 바꾸기
                 case .addClimbingGym:
                 let reducer = SearchReducer.State()
                 state.destination = .searchGym(reducer)
                 return .none
                 
                 present 된 뷰에서 정보 가져오기
                 case let .destination(
                 .presented(
                 .searchGym(
                 .delegate(
                 .selectGym(gym)
                 )
                 )
                 )
                 ):
                 state.gym = gym
                 state.gymName = gym.name
                 return .none
                 
                 */
            case .binding(_):
                return .none
                
            case .destination(_):
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
