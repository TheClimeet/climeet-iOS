//
//  RouteVersionDTO+AddGymVersion.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/10/24.
//

import Foundation

extension RouteVersionDTO.AddGymVersion {
    struct Request: Encodable {
        let timePoint: String
        let existingData: ExistingData
        let newData: NewData
    }

    // MARK: - ExistingData
    struct ExistingData: Codable {
        let difficulty: [String]
        let layout, sector, route: [Int]
    }

    // MARK: - NewData
    struct NewData: Codable {
        let difficulty: [Difficulty]
        let layout: [Layout]
        let sector: [Sector]
        let route: [Route]
    }

    // MARK: - Difficulty
    struct Difficulty: Codable {
        let gymDifficultyName, climeetDifficultyName: String
    }

    // MARK: - Layout
    struct Layout: Codable {
        let floor: Int
        let imgURL: String

        enum CodingKeys: String, CodingKey {
            case floor
            case imgURL = "imgUrl"
        }
    }

    // MARK: - Route
    struct Route: Codable {
        let sectorName, gymDifficultyName, holdColor, imgURL: String

        enum CodingKeys: String, CodingKey {
            case sectorName, gymDifficultyName, holdColor
            case imgURL = "imgUrl"
        }
    }

    // MARK: - Sector
    struct Sector: Codable {
        let name: String
        let floor: Int
        let imgURL: String

        enum CodingKeys: String, CodingKey {
            case name, floor
            case imgURL = "imgUrl"
        }
    }
}
