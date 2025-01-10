//
//  AuthScreenReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 1/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthScreenReducer {
    @Reducer(state: .equatable)
    enum Path {
        case setNickname(SetNicknameReducer)
        case setProfile(SetProfileReducer)
        case checkLevel(CheckLevelReducer)
    }
    
    @ObservableState
    struct State: Equatable {
        var auth: AuthReducer.State = .init()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case auth(AuthReducer.Action)
        case path(StackActionOf<Path>)
        case popToRoot
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.auth, action: \.auth) {
            AuthReducer()
        }
        Reduce { state, action in
            switch action {
            case .auth(.moveToSetNickname(let accessToken)):
                guard let accessToken else { return .none }
                state.path.append(.setNickname(SetNicknameReducer.State(
                    signupExtra: .init(accessToken: accessToken)
                )))
                return .none
            case .auth:
                return .none
            case .path(let action):
                switch action {
                case .element(id: _, action: .setNickname(.moveToSetProfile(let signupExtra))):
                    state.path.append(.setProfile(SetProfileReducer.State(
                        signupExtra: signupExtra
                    )))
                    return .none
                case .element(id: _, action: .setProfile(.moveToCheckLevel(let signupExtra))):
                    state.path.append(.checkLevel(CheckLevelReducer.State(
                        signupExtra: signupExtra
                    )))
                default:
                    return .none
                }
                return .none
            case .popToRoot:
                state.path.removeAll()
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
