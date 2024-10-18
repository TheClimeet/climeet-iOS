//
//  ClimbingGymDTO+GymInfo.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.GymInfo {
    struct Response: Decodable {
        let gymID: Int?
        let name, address, tel: String?
        let businessHours: BusinessHours?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case name, address, tel, businessHours
        }
    }

    // MARK: - BusinessHours
    struct BusinessHours: Codable {
        let additionalProp1, additionalProp2, additionalProp3: [String]?
    }
}
