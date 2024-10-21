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
    var login: @Sendable () async -> Result<String, AppError>
    var me: @Sendable () async -> Result<KakaoDTO.Response, AppError>
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
    
    private static func myInfo() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                if let user {
                    continuation.resume(returning: user)
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
        },
        me: {
            do {
                let user: User = try await KakaoClient.myInfo()
                let birthYear = user.kakaoAccount?.birthyear ?? ""
                let birthDay = user.kakaoAccount?.birthday ?? ""
                return .success(KakaoDTO.Response(
                    id: user.id,
                    imageURL: user.kakaoAccount?.profile?.profileImageUrl?.absoluteString,
                    name: user.kakaoAccount?.name,
                    nickname: user.kakaoAccount?.profile?.nickname,
                    email: user.kakaoAccount?.email,
                    birthDay: birthYear + birthDay,
                    gender: user.kakaoAccount?.gender?.rawValue,
                    phoneNumber: user.kakaoAccount?.phoneNumber
                ))
            } catch {
                return .failure(AppError.dataParsingError("Kakao User Profile 호출 실패"))
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
