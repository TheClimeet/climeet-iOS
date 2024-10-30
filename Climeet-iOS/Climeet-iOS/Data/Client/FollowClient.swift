//
//  FollowClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import NetworkKit
import Dependencies

struct FollowClient {
    /// 유저 팔로우 취소
    var unFollow: @Sendable (_ userID: Int) async throws -> String
    /// 암장 팔로우 취소
    var gymUnFollow: @Sendable (_ gymID: Int) async throws -> String
    /// 유저 팔로우
    var follow: @Sendable (_ userID: Int) async throws -> String
    /// 암장 팔로우
    var gymFollow: @Sendable (_ userID: Int) async throws -> String
}

extension FollowClient: DependencyKey {
    static var liveValue: FollowClient = .init(
        unFollow: { userID in
            let endPoint = FollowEndPoint.unFollow(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        gymUnFollow: { gymID in
            let endPoint = FollowEndPoint.gymUnFollow(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        follow: { userID in
            let endPoint = FollowEndPoint.follow(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        gymFollow: { gymID in
            let endPoint = FollowEndPoint.gymFollow(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var followClient: FollowClient {
        get { self[FollowClient.self] }
        set { self[FollowClient.self] = newValue }
    }
}
