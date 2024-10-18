//
//  UserDTO+UsersAccounts.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.UsersAccounts {
    struct Response: Decodable {
        let userID: Int?
        let userName: String?
        let userProfileURL: String?
        let isManager: Bool
        let socialType: SocialType?
        
        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case userName
            case userProfileURL = "userProfileUrl"
            case isManager
            case socialType
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userID = try container.decodeIfPresent(Int.self, forKey: .userID)
            userName = try container.decodeIfPresent(String.self, forKey: .userName)
            userProfileURL = try container.decodeIfPresent(String.self, forKey: .userProfileURL)
            isManager = try container.decodeIfPresent(Bool.self, forKey: .isManager) ?? false
            socialType = try container.decodeIfPresent(SocialType.self, forKey: .socialType)
        }
    }
}
