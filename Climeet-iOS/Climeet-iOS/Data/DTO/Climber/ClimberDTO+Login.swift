//
//  ClimberDTO+Login.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimberDTO.Login {
    struct Request: Encodable {
        let provider: SocialType
        let accessToken: String
    }
}
