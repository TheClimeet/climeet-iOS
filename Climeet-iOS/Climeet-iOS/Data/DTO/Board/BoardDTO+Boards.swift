//
//  BoardDTO+Boards.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension BoardDTO.Boards {
    struct ResponseElement: Decodable {
        let boardID: Int?
        let createdAt: String?
        let likeCount: Int?
        let title, content, profileImageURL, image: String?

        enum CodingKeys: String, CodingKey {
            case boardID = "boardId"
            case createdAt, likeCount, title, content
            case profileImageURL = "profileImageUrl"
            case image
        }
    }

    typealias Response = [ResponseElement]
}
