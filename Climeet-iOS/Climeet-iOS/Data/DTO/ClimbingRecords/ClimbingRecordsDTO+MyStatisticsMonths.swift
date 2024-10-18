//
//  ClimbingRecordsDTO+MyStatisticsMonths.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.MyStatisticsMonths {
    struct Response: Decodable {
        let time: String?
        let totalCompletedCount, attemptRouteCount: Int?
        let difficulty: Difficulty?
    }

    // MARK: - Difficulty
    struct Difficulty: Codable {
        let additionalProp1, additionalProp2, additionalProp3: Int
    }
}
