//
//  ShortsDTO+List.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.List {
    struct Request: Encodable {
        let page: Int
        let size: Int
        let gymID: Int?
        let sectorID: Int?
        let routeID: Int?
        
        init(page: Int, size: Int, gymID: Int? = nil, sectorID: Int? = nil, routeID: Int? = nil) {
            self.page = page
            self.size = size
            self.gymID = gymID
            self.sectorID = sectorID
            self.routeID = routeID
        }
    }
    
    struct Response: Decodable {
        let page: Int
        let hasNext: Bool
        let result: [ShortsDTO.Shorts.Response]
    }
}
