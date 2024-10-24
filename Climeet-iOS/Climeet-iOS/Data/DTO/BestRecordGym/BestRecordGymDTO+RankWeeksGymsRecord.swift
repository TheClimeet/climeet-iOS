//
//  BestRecordGymDTO+RankWeeksGymsRecord.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestRecordGymDTO.RankWeeksGymsRecord {
    struct ResponseElement: Decodable {
        let gymID: Int?
        let ranking: Int?
        let profileImageURL, gymName: String?
        let thisWeekSelectionCount, rating, reviewCount: Int?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case ranking
            case profileImageURL = "profileImageUrl"
            case gymName, thisWeekSelectionCount, rating, reviewCount
        }
    }

    typealias Response = [BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement]
}
