//
//  ClimbingRecordsDTO+Create.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.Create {
    struct Request: Encodable {
        let gymID: Int
        let date, time: String
        let avgDifficulty: Int
        let routeRecordRequestDtoList: [RouteRecordRequestDtoList]
    }

    // MARK: - RouteRecordRequestDtoList
    struct RouteRecordRequestDtoList: Codable {
        let routeID: Int
        let attemptCount: Int
        let isCompleted: Bool
    }
}
