//
//  BestTimeClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestTimeClimberClient {
    /// [시간순] 금주 베스트 클라이머 API
    var rankWeeksClimbersTime: @Sendable () async throws -> BestTimeClimberDTO.RankWeeksClimbersTime.Response
}

extension BestTimeClimberClient: DependencyKey {
    static var liveValue: BestTimeClimberClient = .init(
        rankWeeksClimbersTime: {
            let endPoint = BestTimeClimberEndPoint.rankWeeksClimbersTime
            return try await APIClient.shared.request(endPoint, decode: BestTimeClimberDTO.RankWeeksClimbersTime.Response.self)
        }
    )
}

extension DependencyValues {
    var bestTimeClimberClient: BestTimeClimberClient {
        get { self[BestTimeClimberClient.self] }
        set { self[BestTimeClimberClient.self] = newValue }
    }
}
