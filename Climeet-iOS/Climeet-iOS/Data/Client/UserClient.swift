//
//  UserClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct UserClient {
    /// 유저 알림 허용 범위 조회
    var usersNotification: @Sendable (UserDTO.UsersNotification.Request?) async throws -> UserDTO.UsersNotification.Response
    /// 로그인 계정 정보 조회
    var usersAccounts: @Sendable () async throws -> UserDTO.UsersAccounts.Response
    /// 유저 프로필 조회 (userID 가 null 이면 자기자신)
    var profile: @Sendable (_ userID: Int?) async throws -> UserDTO.Profile.Response
    /// 특정 유저 홈짐 조회 (userID가 null 이면 홈화면 홈짐 바로가기)
    var homeGyms: @Sendable (_ userID: Int?) async throws -> UserDTO.HomeGyms.Response
    /// 팔로우하는 암장 정보 조회(검색창 하단)
    var gymFollowing: @Sendable () async throws -> UserDTO.GymFollowing.Response
    /// 특정 유저 팔로우 조회
    var followers: @Sendable (UserDTO.Followers.Request) async throws -> UserDTO.Followers.Response
    /// 팔로우하는 클라이머 정보 조회(검색창 하단)
    var climberFollowing: @Sendable () async throws -> UserDTO.ClimberFollowing.Response
    /// 유저 프로필 이름 수정
    var profileName: @Sendable (_ name: String) async throws -> Bool
    //// 유저 프로필 사진 수정
    var profileImage: @Sendable (_ imageURL: String) async throws -> Bool
    /// 사용자 FCM 토큰 수정
    var userFCMToken: @Sendable (_ token: String) async throws -> Bool
    /// 소셜 AccessToken, Refresh Token 재발급
    var refreshToken: @Sendable () async throws -> UserDTO.RefreshToken.Response
}

extension UserClient: DependencyKey {
    static var liveValue: UserClient = .init(
        usersNotification: { param in
            let endPoint = UserEndPoint.usersNotification(param)
            return try await APIClient.shared.request(endPoint, decode: UserDTO.UsersNotification.Response.self)
        },
        usersAccounts: {
            let endPoint = UserEndPoint.usersAccounts
            return try await APIClient.shared.request(endPoint, decode: UserDTO.UsersAccounts.Response.self)
        },
        profile: { userID in
            let endPoint = UserEndPoint.profile(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: UserDTO.Profile.Response.self)
        },
        homeGyms: { userID in
            let endPoint = UserEndPoint.homeGyms(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: UserDTO.HomeGyms.Response.self)
        },
        gymFollowing: {
            let endPoint = UserEndPoint.gymFollowing
            return try await APIClient.shared.request(endPoint, decode: UserDTO.GymFollowing.Response.self)
        },
        followers: { param in
            let endPoint = UserEndPoint.followers(param)
            return try await APIClient.shared.request(endPoint, decode: UserDTO.Followers.Response.self)
        },
        climberFollowing: {
            let endPoint = UserEndPoint.climberFollowing
            return try await APIClient.shared.request(endPoint, decode: UserDTO.ClimberFollowing.Response.self)
        },
        profileName: { name in
            let endPoint = UserEndPoint.profileName(name: name)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        profileImage: { imageURL in
            let endPoint = UserEndPoint.profileImage(imageURL: imageURL)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        userFCMToken: { token in
            let endPoint = UserEndPoint.usersFCMToken(token: token)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        refreshToken: {
            let endPoint = UserEndPoint.refreshToken
            return try await APIClient.shared.request(endPoint, decode: UserDTO.RefreshToken.Response.self)
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
