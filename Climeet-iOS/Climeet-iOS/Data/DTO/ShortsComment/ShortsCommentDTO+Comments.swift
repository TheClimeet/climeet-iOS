//
//  ShortsCommentDTO+Comments.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsCommentDTO.Comments {
    struct Request: Encodable {
        let shortsID: Int
        let page: Int
        let size: Int
    }
    
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [Result]?
    }

    // MARK: - Result
    struct Result: Codable {
        let commentID: Int
        let nickname, profileImageURL, content, commentLikeStatus: String
        let likeCount, dislikeCount: Int
        let isParent: Bool
        let parentCommentID: Int
        let childCommentCount: Int
        let createdDate: String
        let isBlocked: Bool

        enum CodingKeys: String, CodingKey {
            case commentID = "commentId"
            case nickname
            case profileImageURL = "profileImageUrl"
            case content, commentLikeStatus, likeCount, dislikeCount, isParent
            case parentCommentID = "parentCommentId"
            case childCommentCount, createdDate, isBlocked
        }
    }
}
