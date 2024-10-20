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

    @ObservableState
    struct State: Equatable {
        var token: String? = nil
    }
    
    enum Action: Equatable {
        case kakaoBtnDidTap
        case naverBtnDidTap
        case kakaoLoginResponse(Result<String, AppError>)
        case kakaoProfileResponse(Result<KakaoDTO.Response, AppError>)
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .kakaoBtnDidTap:
                return .run { send in
                    let login = await kakaoClient.login()
                    await send(.kakaoLoginResponse(login))
                }
            case .naverBtnDidTap:
                return .none
            case .kakaoLoginResponse(.success(let oAuthToken)):
                Log.debug("KakaoLogin API Success\n Token:", oAuthToken)
                state.token = oAuthToken
                return .run { send in
                    let profile = await kakaoClient.me()
                    await send(.kakaoProfileResponse(profile))
                }
            case .kakaoProfileResponse(.success(let userData)):
                Log.debug("KakaoProfile API Success\n userData:", userData)
                return .none
            case .kakaoLoginResponse(.failure(let error)),
                    .kakaoProfileResponse(.failure(let error)):
                Log.debug("API fail", error)
                return .none
            }
        }
    }
}
