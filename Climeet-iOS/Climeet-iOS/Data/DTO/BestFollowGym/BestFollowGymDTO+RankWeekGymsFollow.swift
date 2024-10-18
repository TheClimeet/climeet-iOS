//
//  BestFollowGymDTO+RankWeekGymsFollow.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestFollowGymDTO.RankWeeksGymsFollow {
    struct ResponseElement: Decodable {
        let gymID: Int?
        let ranking: Int?
        let profileImageURL, gymName: String?
        let thisWeekFollowerCount, rating, reviewCount: Int?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case ranking
            case profileImageURL = "profileImageUrl"
            case gymName, thisWeekFollowerCount, rating, reviewCount
        }
    }

    typealias Response = [BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement]

}
