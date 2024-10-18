//
//  ClimbingRecordsDTO+GymRankWeeksClimbersLevel.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.GymRankWeeksClimbersLevel {
    struct ResponseElement: Decodable {
        let userID: Int?
        let profileName, profileImageURL: String?
        let ranking, highDifficulty, highDifficultyCount: Int?
        let climeetDifficultyName, gymDifficultyName, gymDifficultyColor: String?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case profileName
            case profileImageURL = "profileImageUrl"
            case ranking, highDifficulty, highDifficultyCount, climeetDifficultyName, gymDifficultyName, gymDifficultyColor
        }
    }

    typealias Response = [ClimbingRecordsDTO.GymRankWeeksClimbersLevel.ResponseElement]
}
