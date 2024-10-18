//
//  ClimbingRecordsDTO+ClimbingRecords.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.ClimbingRecords {
    struct ResponseElement: Decodable {
        let climbingRecordID: Int?
        let date, time: String?
        let totalCompletedCount, totalAttemptCount, avgDifficulty, gymID: Int?

        enum CodingKeys: String, CodingKey {
            case climbingRecordID = "climbingRecordId"
            case date, time, totalCompletedCount, totalAttemptCount, avgDifficulty
            case gymID = "gymId"
        }
    }

    typealias Response = [ClimbingRecordsDTO.ClimbingRecords.ResponseElement]
}
