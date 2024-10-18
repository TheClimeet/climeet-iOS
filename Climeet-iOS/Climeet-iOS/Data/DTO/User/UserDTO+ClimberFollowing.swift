//
//  UserDTO+ClimberFollowing.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.ClimberFollowing {
    struct ResponseElement: Decodable {
        let userID: Int?
        let userName, userProfileURL: String?
        let followerCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case userName
            case userProfileURL = "userProfileUrl"
            case followerCount
        }
    }
    
    typealias Response = [UserDTO.ClimberFollowing.ResponseElement]
}
