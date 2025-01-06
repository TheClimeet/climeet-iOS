//
//  KakaoClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/21/24.
//

import Dependencies
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

struct KakaoClient {
    var login: @MainActor @Sendable () async -> Result<String, AppError>
}

extension KakaoClient {
    private static func login() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    if let oauthToken {
                        continuation.resume(returning: oauthToken.accessToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    if let oauthToken {
                        continuation.resume(returning: oauthToken.accessToken)
                    }
                }
            }
        }
    }
}

extension KakaoClient: DependencyKey {
    static public var liveValue: KakaoClient = .init(
        login: {
            do {
                let oAuthToken = try await KakaoClient.login()
                return .success(oAuthToken)
            } catch {
                return .failure(AppError.dataParsingError("Kakao OAuthToken 호출 실패"))
            }
        }
    )
}

extension DependencyValues {
    var kakaoClient: KakaoClient {
        get { self[KakaoClient.self] }
        set { self[KakaoClient.self] = newValue }
    }
}
