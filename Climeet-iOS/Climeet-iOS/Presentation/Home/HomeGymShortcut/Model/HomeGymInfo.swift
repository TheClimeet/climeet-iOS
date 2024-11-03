//
//  HomeGymInfo.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/2/24.
//

import Foundation

struct HomeGymInfo: Identifiable, Equatable {
    let id = UUID()
    let gymID: Int
    let gymProfileURL: String
    let gymName: String
    let followerCount: Int
    
    init(from dto: UserDTO.HomeGyms.ResponseElement) {
        self.gymID = dto.gymID
        self.gymProfileURL = dto.gymProfileURL
        self.gymName = dto.gymName
        self.followerCount = dto.followerCount
    }
    
    init(
        gymID: Int,
        gymProfileURL: String,
        gymName: String,
        followerCount: Int
    ) {
        self.gymID = gymID
        self.gymProfileURL = gymProfileURL
        self.gymName = gymName
        self.followerCount = followerCount
    }
    
    static let dummy = HomeGymInfo(
        gymID: 1,
        gymProfileURL: "",
        gymName: "",
        followerCount: 0
    )
}
