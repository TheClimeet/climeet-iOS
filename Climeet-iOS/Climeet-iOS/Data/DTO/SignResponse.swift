//
//  SignResponse.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

struct SignResponse: Decodable {
    let socialType: SocialType?
    let accessToken, refreshToken: String?
    let responseType: SignResponseType?
    
    enum CodingKeys: String, CodingKey {
        case socialType = "userId"
        case accessToken
        case refreshToken
        case responseType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        socialType = try container.decodeIfPresent(SocialType.self, forKey: .socialType)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        responseType = try container.decodeIfPresent(SignResponseType.self, forKey: .responseType)
    }
}
