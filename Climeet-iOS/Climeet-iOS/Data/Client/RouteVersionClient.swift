//
//  RouteVersionClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/10/24.
//

import NetworkKit
import Dependencies

struct RouteVersionClient {
    /// 암장의 루트 버전 일자 목록
    var gymVersionList: @Sendable (_ gymID: Int) async throws -> [String]
    /// 암장 특정 루트버전 필터링 키 불러오기
    var gymVersionKey: @Sendable (_ gymID: Int, _ timePoint: String?) async throws -> RouteVersionDTO.GymVersionKey.Response
    /// 암장 특정 루트버전의 모든 데이터 불러오기
    var gymVersionAll: @Sendable (_ timePoint: String) async throws -> RouteVersionDTO.GymVersionAll.Response
    /// 암장 특정 루트버전 루트 리스트 불러오기
    var gymVersionRoute: @Sendable (RouteVersionDTO.GymVersionRoute.Request) async throws -> RouteVersionDTO.GymVersionRoute.Response
    /// 암장의 루트 버전 추가
    var addGymVersion: @Sendable (RouteVersionDTO.AddGymVersion.Request) async throws -> String
}

extension RouteVersionClient: DependencyKey {
    static var liveValue: RouteVersionClient = .init(
        gymVersionList: { gymID in
            let endPoint = RouteVersionEndPoint.gymVersionList(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: [String].self)
        },
        gymVersionKey: { gymID, timePoint in
            let endPoint = RouteVersionEndPoint.gymVersionKey(gymID: gymID, timePoint: timePoint)
            return try await APIClient.shared.request(endPoint, decode: RouteVersionDTO.GymVersionKey.Response.self)
        },
        gymVersionAll: { timePoint in
            let endPoint = RouteVersionEndPoint.gymVersionAll(timePoint: timePoint)
            return try await APIClient.shared.request(endPoint, decode: RouteVersionDTO.GymVersionAll.Response.self)
        },
        gymVersionRoute: { param in
            let endPoint = RouteVersionEndPoint.gymVersionRoute(param)
            return try await APIClient.shared.request(endPoint, decode: RouteVersionDTO.GymVersionRoute.Response.self)
        },
        addGymVersion: { param in
            let endPoint = RouteVersionEndPoint.addGymVersion(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var routeVersionClient: RouteVersionClient {
        get { self[RouteVersionClient.self] }
        set { self[RouteVersionClient.self] = newValue }
    }
}
