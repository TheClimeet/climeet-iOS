//
//  UserDTO+RefreshToken.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.RefreshToken {
    struct Response: Decodable {
        let accessToken: String?
        let refreshToken: String?
    }
}
