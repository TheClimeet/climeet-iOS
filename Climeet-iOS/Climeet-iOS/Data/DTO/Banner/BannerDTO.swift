//
//  BannerDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

enum BannerDTO {
    struct ResponseElement: Decodable {
        let id: Int?
        let bannerImageURL: String?
        let bannerTargetURL: String?
        let title, bannerStartDate, bannerEndDate: String?
        let isPopup: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id, title, bannerStartDate, bannerEndDate, isPopup
            case bannerImageURL = "bannerImageUrl"
            case bannerTargetURL = "bannerTargetUrl"
        }
    }

    typealias Response = [BannerDTO.ResponseElement]
}
