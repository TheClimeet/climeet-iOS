//
//  ShortCommentDTO+MyComments.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/12/24.
//

import Foundation

extension ShortsCommentDTO.MyComments {
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [Result]?
    }

    // MARK: - Result
    struct Result: Codable {
        let shortsID, commentID: Int
        let profileImageURL, content, createdDate: String

        enum CodingKeys: String, CodingKey {
            case shortsID = "shortsId"
            case commentID = "commentId"
            case profileImageURL = "profileImageUrl"
            case content, createdDate
        }
    }
}
