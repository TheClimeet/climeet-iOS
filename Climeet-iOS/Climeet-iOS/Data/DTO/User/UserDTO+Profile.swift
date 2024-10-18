//
//  UserDTO+Profile.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.Profile {
    struct Response: Decodable {
        let userID: Int?
        let userName, profileImgURL: String?
        let followerCount, followingCount: Int?
        let isManager: Bool?
        let isFollower: Bool?
        
        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case userName
            case profileImgURL = "profileImgUrl"
            case followerCount, followingCount, isManager, isFollower
        }
    }
}
