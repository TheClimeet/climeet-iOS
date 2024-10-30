//
//  ClimbingSectorClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import NetworkKit
import Dependencies

struct ClimbingSectorClient {
    /// 특정 암장 전체 섹터 조회
    var sector: @Sendable (_ gymID: Int) async throws -> ClimbingSectorDTO.Sector.Response
}

extension ClimbingSectorClient: DependencyKey {
    static var liveValue: ClimbingSectorClient = .init(
        sector: { gymID in
            let endPoint = ClimbingSectorEndPoint.sector(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingSectorDTO.Sector.Response.self)
        }
    )
}

extension DependencyValues {
    var climbingSectorClient: ClimbingSectorClient {
        get { self[ClimbingSectorClient.self] }
        set { self[ClimbingSectorClient.self] = newValue }
    }
}
