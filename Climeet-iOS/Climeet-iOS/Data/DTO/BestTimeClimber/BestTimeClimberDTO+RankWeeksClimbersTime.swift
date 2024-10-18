//
//  BestTimeClimberDTO+RankWeeksClimbersTime.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestTimeClimberDTO.RankWeeksClimbersTime {
    struct ResponseElement: Decodable {
        let userID: Int?
        let ranking: Int?
        let profileImageURL, profileName, thisWeekTotalClimbingTime: String?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case ranking
            case profileImageURL = "profileImageUrl"
            case profileName, thisWeekTotalClimbingTime
        }
    }

    typealias Response = [BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement]
}
