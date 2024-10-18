//
//  ClimbingRecordsDTO+MyGymStatisticsMonth.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.MyGymStatisticsMonth {
    struct Request: Encodable {
        let gymID: Int
        let year: Int
        let month: Int
    }
    
    struct Response: Decodable {
        let time: String?
        let totalCompletedCount, attemptRouteCount: Int?
        let difficulty: [Difficulty]?
    }

    // MARK: - Difficulty
    struct Difficulty: Codable {
        let climeetDifficultyName, gymDifficultyName, gymDifficultyColor: String?
        let count, difficulty: Int?
    }
}
