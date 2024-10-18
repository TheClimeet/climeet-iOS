//
//  RouteRecordsClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import NetworkKit
import Dependencies

struct RouteRecordsClient {
    /// RouteRecord 삭제
    var delete: @Sendable (_ id: Int) async throws -> String
    /// 루트 기록 id 조회
    var routeRecord: @Sendable (_ id: Int) async throws -> RouteRecordsDTO.RouteRecord.Response
    /// 루트 기록 전체 조회
    var routeRecords: @Sendable () async throws -> [RouteRecordsDTO.RouteRecord.Response]
    /// RouteRecord 수정
    var update: @Sendable (RouteRecordsDTO.Update.Request) async throws -> RouteRecordsDTO.RouteRecord.Response
}

extension RouteRecordsClient: DependencyKey {
    static var liveValue: RouteRecordsClient = .init(
        delete: { id in
            let endPoint = RouteRecordsEndPoint.delete(id: id)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        routeRecord: { id in
            let endPoint = RouteRecordsEndPoint.routeRecord(id: id)
            return try await APIClient.shared.request(endPoint, decode: RouteRecordsDTO.RouteRecord.Response.self)
        },
        routeRecords: {
            let endPoint = RouteRecordsEndPoint.routeRecords
            return try await APIClient.shared.request(endPoint, decode: [RouteRecordsDTO.RouteRecord.Response].self)
        },
        update: { param in
            let endPoint = RouteRecordsEndPoint.update(param)
            return try await APIClient.shared.request(endPoint, decode: RouteRecordsDTO.RouteRecord.Response.self)
        }
    )
}

extension DependencyValues {
    var routeRecordsClient: RouteRecordsClient {
        get { self[RouteRecordsClient.self] }
        set { self[RouteRecordsClient.self] = newValue }
    }
}
