//
//  UserDTO+UsersNotification.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension UserDTO.UsersNotification {
    struct Request: Encodable {
        let isAllowFollowNotification: Bool
        let isAllowLikeNotification: Bool
        let isAllowCommentNotification: Bool
        let isAllowAdNotification: Bool
    }
    
    struct Response: Decodable {
        let isAllowFollowNotification: Bool?
        let isAllowLikeNotification: Bool?
        let isAllowCommentNotification: Bool?
        let isAllowAdNotification: Bool?
    }
}
