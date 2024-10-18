//
//  ClimbingSectorDTO+Sector.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingSectorDTO.Sector {
    struct ResponseElement: Codable {
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

    typealias Response = [ClimbingSectorDTO.Sector.ResponseElement]
}
