//
//  ShortsCommentDTO+CommentState.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/12/24.
//

import Foundation

extension ShortsCommentDTO.CommentState {
    struct Request: Encodable {
        let shortsCommentID: Int
        let isLike: Bool
        let isDislike: Bool
    }
}
