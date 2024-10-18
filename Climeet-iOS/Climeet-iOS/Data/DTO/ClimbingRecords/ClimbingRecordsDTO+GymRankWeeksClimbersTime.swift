//
//  ClimbingRecordsDTO+GymRankWeeksClimbersTime.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.GymRankWeeksClimbersTime {
    struct ResponseElement: Decodable {
        let totalTime: String?
        let userID: Int?
        let profileName, profileImageURL: String?
        let ranking: Int?

        enum CodingKeys: String, CodingKey {
            case totalTime
            case userID = "userId"
            case profileName
            case profileImageURL = "profileImageUrl"
            case ranking
        }
    }

    typealias Response = [ClimbingRecordsDTO.GymRankWeeksClimbersTime.ResponseElement]
}
