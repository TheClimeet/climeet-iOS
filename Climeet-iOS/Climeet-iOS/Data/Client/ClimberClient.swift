//
//  ClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct ClimberClient {
    /// 클라이머 탈퇴
    var deactivate: @Sendable () async throws -> Bool
    /// 클라이머 검색 기능
    var search: @Sendable (ClimberDTO.Search.Request) async throws -> ClimberDTO.Search.Response
    /// 클라이머 정보 공개 여부 조회 (쇼츠, 홈짐, 평균완등률, 평균레벨)
    var privacySetting: @Sendable (_ climberID: Int) async throws -> ClimberDTO.PrivacySetting.Response
    /// 클라이머 닉네임 중복 확인 (사용가능 true/이미 존재 false)
    var checkNickname: @Sendable (_ nickname: String) async throws -> Bool
    /// 클라이머 쇼츠 공개 여부 변경
    var shortsPrivacySetting: @Sendable () async throws -> Bool
    /// 클라이머 홈짐 공개 여부 변경
    var homeGymPrivacySetting: @Sendable () async throws -> Bool
    /// 클라이머 평균완등률 공개 여부 변경
    var averageCompletionRatePrivacySetting: @Sendable () async throws -> Bool
    /// 클라이머 평균완등레벨 공개 여부 변경
    var averageCompletionLevelPrivacySetting: @Sendable () async throws -> Bool
    /// 회원가입 추가 정보 입력
    var signupExtra: @Sendable (ClimberDTO.SignupExtra.Request) async throws -> SignResponse
    /// OAuth 2.0 소셜 로그인
    var login: @Sendable (ClimberDTO.Login.Request) async throws -> SignResponse
}

extension ClimberClient: DependencyKey {
    static var liveValue: ClimberClient = .init(
        deactivate: {
            let endPoint = ClimberEndPoint.deactivate
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        search: { param in
            let endPoint = ClimberEndPoint.search(param)
            return try await APIClient.shared.request(endPoint, decode: ClimberDTO.Search.Response.self)
        },
        privacySetting: { climberID in
            let endPoint = ClimberEndPoint.privacySetting(climberID: climberID)
            return try await APIClient.shared.request(endPoint, decode: ClimberDTO.PrivacySetting.Response.self)
        },
        checkNickname: { nickname in
            let endPoint = ClimberEndPoint.checkNickname(nickname: nickname)
            return try await APIClient.shared.request(endPoint, decode: Bool.self)
        },
        shortsPrivacySetting: {
            let endPoint = ClimberEndPoint.shortsPrivacySetting
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        homeGymPrivacySetting: {
            let endPoint = ClimberEndPoint.homegymPrivacySetting
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        averageCompletionRatePrivacySetting: {
            let endPoint = ClimberEndPoint.averageCompletionRatePrivacySetting
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        averageCompletionLevelPrivacySetting: {
            let endPoint = ClimberEndPoint.averageCompletionLevelPrivacySetting
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        signupExtra: { param in
            let endPoint = ClimberEndPoint.signupExtra(param)
            return try await APIClient.shared.request(endPoint, decode: SignResponse.self)
        },
        login: { param in
            let endPoint = ClimberEndPoint.login(param)
            return try await APIClient.shared.request(endPoint, decode: SignResponse.self)
        }
    )
}

extension DependencyValues {
    var climberClient: ClimberClient {
        get { self[ClimberClient.self] }
        set { self[ClimberClient.self] = newValue }
    }
}
