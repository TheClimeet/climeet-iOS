//
//  ClimbingGymDTO+Search.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.Search {
    struct Request: Encodable {
        let gymname: String
        let page: Int
        let size: Int
    }
    
    struct Response: Decodable {
        let page: Int
        let hasNext: Bool
        let result: [Result]
    }

    // MARK: - Result
    struct Result: Decodable {
        let id: Int
        let name: String
        let managerID: Int
        let follower: Int
        let profileImageURL: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case managerID = "managerId"
            case follower
            case profileImageURL = "profileImageUrl"
        }
    }
}
