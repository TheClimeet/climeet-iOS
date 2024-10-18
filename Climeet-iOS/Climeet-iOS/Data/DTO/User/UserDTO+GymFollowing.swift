//
//  UserDTO+GymFollowing.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.GymFollowing {
    struct Response: Decodable {
        let gymID: Int?
        let gymProfileURL, gymName: String?
        let routeSimpleInfos: [RouteSimpleInfo]
        
        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case gymProfileURL = "gymProfileUrl"
            case gymName, routeSimpleInfos
        }
    }
}

// MARK: - RouteSimpleInfo
struct RouteSimpleInfo: Codable {
    let routeID: Int?
    let routeImgURL, difficultyName: String?
    let sectorID: Int?
    let sectorName, holdColor, gymDifficultyName, gymDifficultyColor: String?

    enum CodingKeys: String, CodingKey {
        case routeID = "routeId"
        case routeImgURL = "routeImgUrl"
        case difficultyName
        case sectorID = "sectorId"
        case sectorName, holdColor, gymDifficultyName, gymDifficultyColor
    }
}
