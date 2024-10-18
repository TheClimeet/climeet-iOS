//
//  RouteVersionDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/10/24.
//

import Foundation

enum RouteVersionDTO {
    enum GymVersionKey {}
    enum GymVersionAll {}
    enum GymVersionRoute {}
    enum AddGymVersion {}
}

extension RouteVersionDTO {
    // MARK: - DifficultyList
    struct DifficultyList: Codable {
        let climeetDifficultyName, gymDifficultyName: String?
        let difficulty: Int?
        let gymDifficultyColor: String?
    }

    // MARK: - LayoutList
    struct LayoutList: Codable {
        let id: Int?
        let imgURL: String?
        let floor: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case imgURL = "imgUrl"
            case floor
        }
    }

    // MARK: - SectorList
    struct SectorList: Codable {
        let sectorID: Int?
        let name: String?
        let floor: Int?
        let imgURL: String?

        enum CodingKeys: String, CodingKey {
            case sectorID = "sectorId"
            case name, floor
            case imgURL = "imgUrl"
        }
    }
    
    // MARK: - RouteList
    struct RouteList: Decodable {
        let routeID, sectorID: Int
        let sectorName, climeetDifficultyName: String
        let difficulty: Int
        let gymDifficultyName, gymDifficultyColor, routeImageURL, holdColor: String

        enum CodingKeys: String, CodingKey {
            case routeID = "routeId"
            case sectorID = "sectorId"
            case sectorName, climeetDifficultyName, difficulty, gymDifficultyName, gymDifficultyColor
            case routeImageURL = "routeImageUrl"
            case holdColor
        }
    }
}
