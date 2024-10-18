//
//  BestFollowGymClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestFollowGymClient {
    /// [팔로우순] 금주 베스트 운동 기록 API
    var rankWeeksGymsFollow: @Sendable () async throws -> BestFollowGymDTO.RankWeeksGymsFollow.Response
}

extension BestFollowGymClient: DependencyKey {
    static var liveValue: BestFollowGymClient = .init(
        rankWeeksGymsFollow: {
            let endPoint = BestFollowGymEndPoint.rankWeeksGymsFollow
            return try await APIClient.shared.request(endPoint, decode: BestFollowGymDTO.RankWeeksGymsFollow.Response.self)
        }
    )
}

extension DependencyValues {
    var bestFollowGymClient: BestFollowGymClient {
        get { self[BestFollowGymClient.self] }
        set { self[BestFollowGymClient.self] = newValue }
    }
}
