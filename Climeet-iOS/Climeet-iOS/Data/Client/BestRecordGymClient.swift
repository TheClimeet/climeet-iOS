//
//  BestRecordGymClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestRecordGymClient {
    /// [기록된 순(selected된 순)] 금주 베스트 운동 기록 API
    var rankWeeksGymsRecord: @Sendable () async throws -> BestRecordGymDTO.RankWeeksGymsRecord.Response
}

extension BestRecordGymClient: DependencyKey {
    static var liveValue: BestRecordGymClient = .init(
        rankWeeksGymsRecord: {
            let endPoint = BestRecordGymEndPoint.rankWeeksGymsRecord
            return try await APIClient.shared.request(endPoint, decode: BestRecordGymDTO.RankWeeksGymsRecord.Response.self)
        }
    )
}

extension DependencyValues {
    var bestRecordGymClient: BestRecordGymClient {
        get { self[BestRecordGymClient.self] }
        set { self[BestRecordGymClient.self] = newValue }
    }
}
