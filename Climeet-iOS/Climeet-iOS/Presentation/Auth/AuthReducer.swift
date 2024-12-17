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
    let naverClinet: NaverRepository = .init()
    
    @Reducer(state: .equatable)
    enum Path {
        case setNickname(SetNicknameReducer)
    }

    @ObservableState
    struct State: Equatable {
        var token: String? = nil
        
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case kakaoBtnDidTap
        case naverBtnDidTap
        case kakaoLoginResponse(Result<String, AppError>)
        case kakaoProfileResponse(Result<KakaoDTO.Response, AppError>)
        
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
                return .run { _ in
                    naverClinet.login()
                }
            case .kakaoLoginResponse(.success(let oAuthToken)):
                Log.debug("KakaoLogin API Success\n Token:", oAuthToken)
                state.token = oAuthToken
                return .run { send in
                    let profile = await kakaoClient.me()
                    await send(.kakaoProfileResponse(profile))
                }
            case .kakaoProfileResponse(.success(let userData)):
                Log.debug("KakaoProfile API Success\n userData:", userData)
                state.path.append(.setNickname(SetNicknameReducer.State()))
                return .none
            case .kakaoLoginResponse(.failure(let error)),
                    .kakaoProfileResponse(.failure(let error)):
                Log.debug("API fail", error)
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension AuthReducer: NaverDelegate {
    func naverUserInfo(_ response: Result<NaverDTO.Response, AppError>) {
        switch response {
        case .success(let success):
            break
        case .failure(let failure):
            break
        }
    }
}
