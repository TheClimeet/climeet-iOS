//
//  ShortsCommentClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import NetworkKit
import Dependencies

struct ShortsCommentClient {
    /// 숏츠 댓글 조회
    var comments: @Sendable (ShortsCommentDTO.Comments.Request) async throws -> ShortsCommentDTO.Comments.Response
    /// 숏츠 대댓글 조회
    var childComments: @Sendable (ShortsCommentDTO.ChildComments.Request) async throws -> ShortsCommentDTO.ChildComments.Response
    /// 내가 작성한 숏츠 댓글 조회
    var myComments: @Sendable (_ page: Int, _ size: Int) async throws -> ShortsCommentDTO.MyComments.Response
    /// 숏츠 댓글 상호작용
    var commentState: @Sendable (ShortsCommentDTO.CommentState.Request) async throws -> ShortsState
    /// 숏츠 댓글 신고
    var report: @Sendable (_ commentID: Int, _ reason: String) async throws -> String
    /// 숏츠 댓글 작성
    var write: @Sendable (ShortsCommentDTO.Write.Request) async throws -> String
}

extension ShortsCommentClient: DependencyKey {
    static var liveValue: ShortsCommentClient = .init(
        comments: { param in
            let endPoint = ShortsCommentEndPoint.comments(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsCommentDTO.Comments.Response.self)
        },
        childComments: { param in
            let endPoint = ShortsCommentEndPoint.childComments(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsCommentDTO.ChildComments.Response.self)
        },
        myComments: { page, size in
            let endPoint = ShortsCommentEndPoint.myComments(page: page, size: size)
            return try await APIClient.shared.request(endPoint, decode: ShortsCommentDTO.MyComments.Response.self)
        },
        commentState: { param in
            let endPoint = ShortsCommentEndPoint.commentState(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsState.self)
        },
        report: { commentID, reason in
            let endPoint = ShortsCommentEndPoint.report(commentID: commentID, reason: reason)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        write: { param in
            let endPoint = ShortsCommentEndPoint.Write(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var shortsCommentClient: ShortsCommentClient {
        get { self[ShortsCommentClient.self] }
        set { self[ShortsCommentClient.self] = newValue }
    }
}
