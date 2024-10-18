//
//  ClimbingRecordsDTO+GymRankWeeksClimbersClear.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.GymRankWeeksClimbersClear {
    struct ResponseElement: Decodable {
        let totalCompletedCount: Int?
        let userID: Int?
        let profileName, profileImageURL: String?
        let ranking: Int?

        enum CodingKeys: String, CodingKey {
            case totalCompletedCount
            case userID = "userId"
            case profileName
            case profileImageURL = "profileImageUrl"
            case ranking
        }
    }

    typealias Response = [ClimbingRecordsDTO.GymRankWeeksClimbersClear.ResponseElement]
}
