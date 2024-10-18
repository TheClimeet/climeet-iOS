//
//  ClimbingRecordsDTO+GymStatisticsWeeks.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.GymStatisticsWeeks {
    struct Response: Decodable {
        let difficulty: [Difficulty]
    }

    // MARK: - Difficulty
    struct Difficulty: Codable {
        let climeetDifficultyName, gymDifficultyName, gymDifficultyColor: String?
        let count, difficulty: Int?
    }
}
