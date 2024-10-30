//
//  BestRouteClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestRouteClient {
    /// [기록된 순(selected된 순)] 금주 베스트 루트 API
    var rankWeeksRoutes: @Sendable () async throws -> BestRouteDTO.RankWeeksRoutes.Response
}

extension BestRouteClient: DependencyKey {
    static var liveValue: BestRouteClient = .init(
        rankWeeksRoutes: {
            let endPoint = BestRouteEndPoint.rankWeeksRoutes
            return try await APIClient.shared.request(endPoint, decode: BestRouteDTO.RankWeeksRoutes.Response.self)
        }
    )
}

extension DependencyValues {
    var bestRouteClient: BestRouteClient {
        get { self[BestRouteClient.self] }
        set { self[BestRouteClient.self] = newValue }
    }
}
