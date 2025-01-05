//
//  SignupExtra.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 1/5/25.
//

import Foundation

struct SignupExtra: Equatable {
    let accessToken: String
    var socialType: SocialType?
    var nickName: String?
    var climbingLevel: ClimbingLevel?
    var discoveryChannel: DiscoveryChannel?
    var profileImgURL: String?
    var gymFollowList: [Int] = []
}
