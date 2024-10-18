//
//  ShortsDTO+Profile.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.Profile {
    struct ResponseElement: Decodable {
        let followingUserID: Int?
        let followingUserName, followingUserProfileURL: String?
        let isUploadRecent, isGym: Bool?
        let gymID: Int?

        enum CodingKeys: String, CodingKey {
            case followingUserID = "followingUserId"
            case followingUserName
            case followingUserProfileURL = "followingUserProfileUrl"
            case isUploadRecent, isGym
            case gymID = "gymId"
        }
    }

    typealias Response = [ResponseElement]
}
