//
//  ClimbingGymDTO+SearchFollow.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.SearchFollow {
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [Result]?
    }

    // MARK: - Result
    struct Result: Decodable {
        let gymID: Int?
        let name: String?
        let managerID: Int?
        let follower: Int?
        let profileImageURL: String?
        let isFollow: Bool?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case name
            case managerID = "managerId"
            case follower
            case profileImageURL = "profileImageUrl"
            case isFollow
        }
    }
}
