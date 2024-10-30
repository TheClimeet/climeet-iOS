//
//  BestLevelClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestLevelClimberClient {
    /// [레벨순] 금주 베스트 클라이머 API
    var rankWeeksClimbersLevel: @Sendable () async throws -> BestLevelClimberDTO.RankWeeksClimbersLevel.Response
}

extension BestLevelClimberClient: DependencyKey {
    static var liveValue: BestLevelClimberClient = .init(
        rankWeeksClimbersLevel: {
            let endPoint = BestLevelClimberEndPoint.rankWeeksClimbersLevel
            return try await APIClient.shared.request(endPoint, decode: BestLevelClimberDTO.RankWeeksClimbersLevel.Response.self)
        }
    )
}

extension DependencyValues {
    var bestLevelClimberClient: BestLevelClimberClient {
        get { self[BestLevelClimberClient.self] }
        set { self[BestLevelClimberClient.self] = newValue }
    }
}
