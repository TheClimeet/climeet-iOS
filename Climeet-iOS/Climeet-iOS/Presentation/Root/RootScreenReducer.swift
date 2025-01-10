//
//  RootScreenReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 1/10/25.
//

import ComposableArchitecture

@Reducer
struct RootScreenReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var auth: AuthScreenReducer.State?
    }
    
    enum Action {
        case onLoad
        case showAuth
        case auth(PresentationAction<AuthScreenReducer.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onLoad:
                // 로그인 여부 확인
                return KeyChain.shared.refreshToken == nil ? .send(.showAuth) : .none
            case .showAuth:
                state.auth = .init()
                return .none
            case .auth(.dismiss):
                state.auth = nil
                return .none
            case .auth:
                return .none
            }
        }
        .ifLet(\.$auth, action: /Action.auth) {
            AuthScreenReducer()
        }
    }
}
