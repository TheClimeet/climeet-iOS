//
//  RouteVersionDTO+GymVersionKey.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/10/24.
//

import Foundation

extension RouteVersionDTO.GymVersionKey {
    struct Response: Decodable {
        let gymID: Int?
        let timePoint: String?
        let layoutList: [RouteVersionDTO.LayoutList]?
        let sectorList: [RouteVersionDTO.SectorList]?
        let difficultyList: [RouteVersionDTO.DifficultyList]?
        let maxFloor: Int?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case timePoint, layoutList, sectorList, difficultyList, maxFloor
        }
    }
}
