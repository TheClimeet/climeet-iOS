//
//  ClimbingRouteClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import NetworkKit
import Dependencies

struct ClimbingRouteClient {
    /// 클라이밍 암장 루트 목록 조회
    var gymRoutes: @Sendable (_ gymID: Int) async throws -> [ClimbingRouteDTO.Response]
    /// 클라이밍 루트 조회
    var gymRoute: @Sendable (_ routeID: Int) async throws -> ClimbingRouteDTO.Response
}

extension ClimbingRouteClient: DependencyKey {
    static var liveValue: ClimbingRouteClient = .init(
        gymRoutes: { gymID in
            let endPoint = ClimbingRouteEndPoint.gymRoutes(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: [ClimbingRouteDTO.Response].self)
        },
        gymRoute: { routeID in
            let endPoint = ClimbingRouteEndPoint.gymRoute(routeID: routeID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRouteDTO.Response.self)
        }
    )
}

extension DependencyValues {
    var climbingRouteClient: ClimbingRouteClient {
        get { self[ClimbingRouteClient.self] }
        set { self[ClimbingRouteClient.self] = newValue }
    }
}
