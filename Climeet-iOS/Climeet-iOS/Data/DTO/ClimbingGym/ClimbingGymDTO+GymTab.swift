//
//  ClimbingGymDTO+GymTab.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.GymTab {
    struct Response: Decodable {
        let gymID: Int?
        let address, location, tel: String?
        let businessHours: BusinessHours?
        let serviceList: [String]?
        let priceList: PriceList?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case address, location, tel, businessHours, serviceList, priceList
        }
    }

    // MARK: - BusinessHours
    struct BusinessHours: Codable {
        let additionalProp1, additionalProp2, additionalProp3: [String]
    }

    // MARK: - PriceList
    struct PriceList: Codable {
        let additionalProp1, additionalProp2, additionalProp3: String
    }
}
