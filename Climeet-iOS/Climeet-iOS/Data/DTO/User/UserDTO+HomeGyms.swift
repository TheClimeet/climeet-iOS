//
//  UserDTO+HomeGyms.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.HomeGyms {
    struct ResponseElement: Decodable {
        let gymID: Int
        let gymProfileURL, gymName: String
        let followerCount: Int
        
        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case gymProfileURL = "gymProfileUrl"
            case gymName, followerCount
        }
    }
    
    typealias Response = [UserDTO.HomeGyms.ResponseElement]
}
