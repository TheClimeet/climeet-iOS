//
//  ClimbingGymDTO+Gym.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.Gym {
    struct Response: Decodable {
        let gymID: Int?
        let gymProfileImageURL, gymBackGroundImageURL, gymName: String?
        let followerCount, followingCount, averageRating, reviewCount: Int?
        let isFollower, hasManager: Bool?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case gymProfileImageURL = "gymProfileImageUrl"
            case gymBackGroundImageURL = "gymBackGroundImageUrl"
            case gymName, followerCount, followingCount, averageRating, reviewCount, isFollower, hasManager
        }
    }
}
