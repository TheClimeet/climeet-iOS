//
//  BestRouteDTO+RankWeeksRoutes.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BestRouteDTO.RankWeeksRoutes {
    struct ResponseElement: Decodable {
        let routeID: Int?
        let ranking, thisWeekSelectionCount: Int?
        let routeImageURL, gymName, sectorName, climeetDifficultyName: String?
        let gymDifficultyName, gymDifficultyColor, holdColor: String?

        enum CodingKeys: String, CodingKey {
            case routeID = "routeId"
            case ranking, thisWeekSelectionCount
            case routeImageURL = "routeImageUrl"
            case gymName, sectorName, climeetDifficultyName, gymDifficultyName, gymDifficultyColor, holdColor
        }
    }

    typealias Response = [BestRouteDTO.RankWeeksRoutes.ResponseElement]

}
