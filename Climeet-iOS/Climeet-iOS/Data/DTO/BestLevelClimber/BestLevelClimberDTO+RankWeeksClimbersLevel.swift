//
//  BestLevelClimberDTO+RankWeeksClimbersLevel.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestLevelClimberDTO.RankWeeksClimbersLevel {
    struct ResponseElement: Decodable {
        let userID: Int?
        let ranking: Int?
        let profileImageURL, profileName: String?
        let thisWeekHighDifficulty, highDifficultyCount: Int?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case ranking
            case profileImageURL = "profileImageUrl"
            case profileName, thisWeekHighDifficulty, highDifficultyCount
        }
    }

    typealias Response = [BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement]
}
