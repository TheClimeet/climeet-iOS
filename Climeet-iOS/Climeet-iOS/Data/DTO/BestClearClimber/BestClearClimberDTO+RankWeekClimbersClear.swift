//
//  BestClearClimberDTO+RankWeekClimbersClear.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestClearClimberDTO.RankWeekClimbersClear {
    struct ResponseElement: Decodable {
        let userID: Int?
        let ranking: Int?
        let profileImageURL, profileName: String?
        let thisWeekClearCount: Int?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case ranking
            case profileImageURL = "profileImageUrl"
            case profileName, thisWeekClearCount
        }
    }

    typealias Response = [BestClearClimberDTO.RankWeekClimbersClear.ResponseElement]
}
