//
//  ClimbingRecordsDTO+Update.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.Update {
    struct Request: Encodable {
        let id: Int
        let date: String
        let time: String
    }
    
    struct Response: Decodable {
        let climbingRecordID: Int?
        let date, time: String?
        let totalCompletedCount, totalAttemptCount, avgDifficulty: Int?
        let gymID: Int?

        enum CodingKeys: String, CodingKey {
            case climbingRecordID = "climbingRecordId"
            case date, time, totalCompletedCount, totalAttemptCount, avgDifficulty
            case gymID = "gymId"
        }
    }
}
