//
//  UserDTO+Followers.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.Followers {
    struct Request: Encodable {
        /// 본인 == nil
        let userID: Int?
        let userCategory: String
    }
    
    struct ResponseElement: Decodable {
        let userID: Int?
        let userName, userProfileURL: String?
        let followerCount, followingCount: Int?
        let isFollower: Bool?
        
        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case userName
            case userProfileURL = "userProfileUrl"
            case followerCount, followingCount, isFollower
        }
    }
    
    typealias Response = [UserDTO.Followers.ResponseElement]
}
