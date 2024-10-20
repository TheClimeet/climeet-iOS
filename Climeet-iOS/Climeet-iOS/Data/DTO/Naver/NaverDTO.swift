//
//  NaverDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/22/24.
//

import Foundation

enum NaverDTO {
    struct Response: Decodable {
        let result: String?
        let profile: Profile?
        
        enum CodingKeys: String, CodingKey {
            case result = "resultcode"
            case profile = "response"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            result = try container.decodeIfPresent(String.self, forKey: .result)
            profile = try container.decodeIfPresent(Profile.self, forKey: .profile)
        }
    }
    
    struct Profile: Codable {
        let id, name, nickname, email: String
        let mobile, birthday, birthyear: String
        let profile_image: String
        let gender: String
    }
}
