//
//  BoardLikeClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BoardLikeClient {
    /// 특정 공지사항 좋아요 취소
    var unlike: @Sendable (_ boardID: Int) async throws -> Bool
    /// 특정 공지사항 좋아요
    var like: @Sendable (_ boardID: Int) async throws -> Bool
}

extension BoardLikeClient: DependencyKey {
    static var liveValue: BoardLikeClient = .init(
        unlike: { boardID in
            let endPoint = BoardLikeEndPoint.unlike(boardID: boardID)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        },
        like: { boardID in
            let endPoint = BoardLikeEndPoint.like(boardID: boardID)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        }
    )
}

extension DependencyValues {
    var boardLikeClient: BoardLikeClient {
        get { self[BoardLikeClient.self] }
        set { self[BoardLikeClient.self] = newValue }
    }
}
