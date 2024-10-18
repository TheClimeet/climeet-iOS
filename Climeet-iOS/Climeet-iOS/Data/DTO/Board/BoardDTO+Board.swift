//
//  BoardDTO+Board.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BoardDTO.Board {
    struct Response: Decodable {
        let boardID: Int?
        let title, createdAt, profileImageURL, profileName: String?
        let followerCount, followingCount: Int?
        let content: String?
        let likeCount: Int?
        let imageList: [String]?
        let likeStatus: Bool?

        enum CodingKeys: String, CodingKey {
            case boardID = "boardId"
            case title, createdAt
            case profileImageURL = "profileImageUrl"
            case profileName, followerCount, followingCount, content, likeCount, imageList, likeStatus
        }
    }
}
