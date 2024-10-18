//
//  RouteVersionDTO+GymVersionRoute.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/10/24.
//

import Foundation

extension RouteVersionDTO.GymVersionRoute {
    struct Request: Encodable {
        let gymID: Int
        let page: Int
        let size: Int
        let floor: Int
        let sectorID: Int
        let difficulty: Int
        let timePoint: String?
    }
    
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [RouteVersionDTO.RouteList]?
    }
}
