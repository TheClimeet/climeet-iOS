//
//  ClimberDTO+Search.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimberDTO.Search {
    struct Request: Encodable {
        let page: Int
        let size: Int
        let climberName: String
    }
    
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [Result]?
    }
    
    struct Result: Decodable {
        let userID: Int?
        let climberName, profileImgURL: String?
        let followerCount: Int?
        let isFollower: Bool?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case climberName
            case profileImgURL = "profileImgUrl"
            case followerCount, isFollower
        }
    }
}
