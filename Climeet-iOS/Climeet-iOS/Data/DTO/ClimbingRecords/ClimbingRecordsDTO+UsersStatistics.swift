//
//  ClimbingRecordsDTO+UsersStatistics.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.UsersStatistics {
    struct Response: Decodable {
        let userID: Int?
        let totalCompletedCount, attemptRouteCount: Int?
        let difficulty: Difficulty?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case totalCompletedCount, attemptRouteCount, difficulty
        }
    }

    // MARK: - Difficulty
    struct Difficulty: Codable {
        let additionalProp1, additionalProp2, additionalProp3: Int?
    }
}
