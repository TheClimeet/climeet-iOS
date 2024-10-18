//
//  RouteRecordsDTO+RouteRecord.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import Foundation

extension RouteRecordsDTO.RouteRecord {
    struct Response: Decodable {
        let routeRecordID, climbingRecordID, routeID: Int?
        let attemptCount: Int?
        let isCompleted: Bool?

        enum CodingKeys: String, CodingKey {
            case routeRecordID = "routeRecordId"
            case climbingRecordID = "climbingRecordId"
            case routeID = "routeId"
            case attemptCount, isCompleted
        }
    }
}
