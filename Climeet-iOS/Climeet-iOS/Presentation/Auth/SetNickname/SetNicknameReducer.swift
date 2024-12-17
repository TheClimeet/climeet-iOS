//
//  SetNicknameReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SetNicknameReducer {
    @Dependency(\.dismiss) var dismiss
    
    @Reducer(state: .equatable)
    enum Path {
//        case setNickname(SetNicknameReducer)
    }

    @ObservableState
    struct State: Equatable {
        var nickname: String = ""
        var isEnabledNext: Bool = false
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case updateNickname(String)
        case duplicateBtnTap
        case nextBtnTap
        case path(StackActionOf<Path>)
        case pop
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .updateNickname(var nickname):
                state.nickname = nickname
                return .none
            case .duplicateBtnTap:
                return .none
            case .nextBtnTap:
                return .none
            case .path:
                return .none
            case .pop:
                return .run { _ in
                    await self.dismiss()
                }
            
            }
        }
        .forEach(\.path, action: \.path)
    }
}
