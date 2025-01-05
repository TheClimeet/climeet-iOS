//
//  AuthReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthReducer {
    @Dependency(\.kakaoClient) var kakaoClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.climberClient) var climberClient
    let naverClinet: NaverRepository = .init()
    
    @Reducer(state: .equatable)
    enum Path {
        case setNickname(SetNicknameReducer)
        case setProfile(SetProfileReducer)
        case checkLevel(CheckLevelReducer)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case kakaoBtnDidTap
        case naverBtnDidTap
        case appleBtnDidTap(idToken: Data?)
        case kakaoLoginResponse(Result<String, Error>)
        
        case climeetLoginRequest(provider: SocialType, accessToken: String)
        case climeetLoginResponse(Result<SignResponse, Error>)
        case path(StackActionOf<Path>)
    }
    
    private enum CancelID { case kakaoLogin }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .kakaoBtnDidTap:
                return .run { send in
                    let login = await kakaoClient.login()
                    await send(.kakaoLoginResponse(login))
                }
                .cancellable(id: CancelID.kakaoLogin)
            case .naverBtnDidTap:
                return .run { send in
                    naverClinet.login()
                    naverClinet.accessToken = { accessToken in
                        guard let accessToken else { return }
                        await send(.climeetLoginRequest(provider: .naver, accessToken: accessToken))
                    }
                }
            case .appleBtnDidTap(let idToken):
                guard let idToken, let idTokenString = String(data: idToken, encoding: .utf8) else { return .none }
                return .send(.climeetLoginRequest(provider: .apple, accessToken: idTokenString))
            case .kakaoLoginResponse(.success(let accessToken)):
                Log.debug("KakaoLogin API Success\n Token:", accessToken)
                return .send(.climeetLoginRequest(provider: .kakao, accessToken: accessToken))
            case .climeetLoginRequest(let provider, let accessToken):
                return .run { send in
                    let response = try await self.climberClient.login(.init(
                        provider: provider,
                        accessToken: accessToken
                    ))
                    await send(.climeetLoginResponse(Result { response }))
                }
            case .climeetLoginResponse(.success(let response)):
                switch response.responseType {
                case .SIGN_IN:
                    // TODO: Global State move mainView
                    Log.debug("move to Main")
                case .SIGN_UP:
                    Log.debug("move to SetNickname")
                    guard let accessToken = response.accessToken else { return .none }
                    state.path.append(.setNickname(SetNicknameReducer.State(
                        signupExtra: .init(accessToken: accessToken)
                    )))
                case .none:
                    Log.debug("SERVER API ERROR")
                }
                KeyChain.shared.refreshToken = response.refreshToken
                return .none
            case .kakaoLoginResponse(.failure(let error)),
                    .climeetLoginResponse(.failure(let error)):
                Log.debug("API fail", error)
                return .none
            case .path(.element(let id, action: .setNickname(.moveToSetProfile(let signupExtra)))):
                state.path.append(.setProfile(.init(
                    signupExtra: signupExtra
                )))
                return .none
            case .path(.element(let id, action: .setProfile(.moveToCheckLevel(let signupExtra)))):
                state.path.append(.checkLevel(.init(
                    signupExtra: signupExtra
                )))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
