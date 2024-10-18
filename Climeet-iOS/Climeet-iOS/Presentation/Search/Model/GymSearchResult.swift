//
//  GymSearchResult.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/2/24.
//

import Foundation

struct GymSearchResult: Identifiable {
    let id = UUID()
    let page: Int
    let hasNext: Bool
    let gyms: [Gym]
}

struct Gym: Identifiable {
    let id = UUID()
    let responseGymId: Int?
    let gymId: Int?
    let name: String
    let managerId: Int?
    let follower: Int
    let profileImageUrl: String
    let isFollow: Bool?
    
    init(
        responseGymId: Int? = nil,
        gymId: Int? = nil,
        name: String = "",
        managerId: Int? = nil,
        follower: Int = 0,
        profileImageUrl: String = "",
        isFollow: Bool? = nil)
    {
        self.responseGymId = responseGymId
        self.gymId = gymId
        self.name = name
        self.managerId = managerId
        self.follower = follower
        self.profileImageUrl = profileImageUrl
        self.isFollow = isFollow
    }
}
