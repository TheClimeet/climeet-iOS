//
//  ShortsCommentDTO+Write.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/12/24.
//

import Foundation

extension ShortsCommentDTO.Write {
    struct Request: Encodable {
        let shortsID: Int
        let parentCommentID: Int?
        let content: String
    }
    
    struct Response: Decodable {
        let commentID: Int?
        let nickname, profileImageURL, content, commentLikeStatus: String?
        let likeCount, dislikeCount: Int?
        let isParent: Bool?
        let parentCommentID: Int?
        let childCommentCount: Int?
        let createdDate: String?
        let isBlocked: Bool?

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
