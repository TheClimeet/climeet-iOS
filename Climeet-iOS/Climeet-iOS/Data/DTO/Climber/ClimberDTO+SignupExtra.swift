//
//  ClimberDTO+SignupExtra.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimberDTO.SignupExtra {
    struct Request: Encodable {
        let token: String
        let socialType: SocialType
        let nickName: String
        let climbingLevel: ClimbingLevel
        let discoveryChannel: DiscoveryChannel
        let profileImgURL: String
        let gymFollowList: [Int]
        let isAllowFollowNotification, isAllowLikeNotification, isAllowCommentNotification, isAllowAdNotification: Bool
    }
}
