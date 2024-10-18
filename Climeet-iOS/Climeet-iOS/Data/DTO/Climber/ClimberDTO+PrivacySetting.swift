//
//  ClimberDTO+PrivacySetting.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimberDTO.PrivacySetting {
    struct Response: Decodable {
        let averageCompletionLevelPublic, shortsPublic, homeGymPublic, averageCompletionRatePublic: Bool?
    }
}
