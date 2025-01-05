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
    @Dependency(\.climberClient) var climberClient
    @Dependency(\.validateService) var validateService
    
    enum WarningText: String {
        case invalid = "닉네임을 규칙에 따라 지어주세요."
        case enable = "사용 가능한 닉네임입니다."
        case duplicate = "중복된 닉네임 입니다."
        case none = ""
    }

    @ObservableState
    struct State: Equatable {
        var signupExtra: SignupExtra
        var isValidNickname: Bool = true
        var warningText: WarningText = .none
        
        var isEnabledNextButton: Bool { isValidNickname && warningText == .enable }
    }
    
    enum Action {
        case updateNickname(String)
        case duplicateBtnTap
        case checkNicknameResponse(Result<Bool, Error>)
        case nextBtnTap
        case moveToSetProfile(SignupExtra)
        case pop
    }
    
    private enum CancelID { case checkNickname }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .updateNickname(let nickname):
                state.signupExtra.nickName = nickname
                state.warningText = .none
                state.isValidNickname = true
                return .none
            case .duplicateBtnTap:
                guard let nickname = state.signupExtra.nickName,
                      self.validateService.isValidNickname(nickname) else {
                    state.isValidNickname = false
                    state.warningText = .invalid
                    return .none
                }
                return .run { [nickname = nickname] send in
                    let response = try await self.climberClient.checkNickname(nickname)
                    await send(.checkNicknameResponse(Result { response }))
                }
                .cancellable(id: CancelID.checkNickname)
            case .checkNicknameResponse(.success(let isDuplicated)):
                state.warningText = isDuplicated ? .enable : .duplicate
                return .none
            case .checkNicknameResponse(.failure(let error)):
                Log.debug("API fail", error)
                return .none
            case .nextBtnTap:
                guard state.isEnabledNextButton else { return .none }
                return .send(.moveToSetProfile(state.signupExtra))
            case .moveToSetProfile:
                return .none
            case .pop:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
