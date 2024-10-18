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
        let title, bannerStartDate, bannerEndDate: String?
        let isPopup: Bool?
        let createdAt, status: String?
    }

    typealias Response = [BannerDTO.ResponseElement]
}
