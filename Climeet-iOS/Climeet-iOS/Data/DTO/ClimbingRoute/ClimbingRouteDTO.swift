//
//  ClimbingRouteDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

enum ClimbingRouteDTO {
    struct Response: Codable {
        let routeID, sectorID: Int?
        let sectorName, climeetDifficultyName: String?
        let difficulty: Int?
        let gymDifficultyName, gymDifficultyColor, routeImageURL, holdColor: String?

        enum CodingKeys: String, CodingKey {
            case routeID = "routeId"
            case sectorID = "sectorId"
            case sectorName, climeetDifficultyName, difficulty, gymDifficultyName, gymDifficultyColor
            case routeImageURL = "routeImageUrl"
            case holdColor
        }
    }
}
