//
//  ClimbingRecordsDTO+ClimbingRecord.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.ClimbingRecord {
    struct Response: Decodable {
        let climbingRecordID: Int?
        let date, time: String?
        let totalCompletedCount, totalAttemptCount, avgDifficulty: Int?
        let gymID: Int?
        let routeRecordSimpleInfoList: [RouteRecordSimpleInfoList]

        enum CodingKeys: String, CodingKey {
            case climbingRecordID = "climbingRecordId"
            case date, time, totalCompletedCount, totalAttemptCount, avgDifficulty
            case gymID = "gymId"
            case routeRecordSimpleInfoList
        }
    }

    // MARK: - RouteRecordSimpleInfoList
    struct RouteRecordSimpleInfoList: Codable {
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
