//
//  ClimbingGymDTO+Price.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.Price {
    struct Request: Encodable {
        let priceMapList: PriceMapList
    }
    
    // MARK: - PriceMapList
    struct PriceMapList: Codable {
        let additionalProp1, additionalProp2, additionalProp3: String
    }
}
