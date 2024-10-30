//
//  BestClearClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestClearClimberClient {
    /// [완등순] 금주 베스트 클라이머 API
    var rankWeekClimbersClear: @Sendable () async throws -> BestClearClimberDTO.RankWeekClimbersClear.Response
}

extension BestClearClimberClient: DependencyKey {
    static var liveValue: BestClearClimberClient = .init(
        rankWeekClimbersClear: {
            let endPoint = BestClearClimberEndPoint.rankWeekClimbersClear
            return try await APIClient.shared.request(endPoint, decode: BestClearClimberDTO.RankWeekClimbersClear.Response.self)
        }
    )
}

extension DependencyValues {
    var bestClearClimberClient: BestClearClimberClient {
        get { self[BestClearClimberClient.self] }
        set { self[BestClearClimberClient.self] = newValue }
    }
}
