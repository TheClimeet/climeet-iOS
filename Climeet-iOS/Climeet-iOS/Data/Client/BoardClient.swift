//
//  BoardClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BoardClient {
    /// 공지사항 전체 조회
    var boards: @Sendable () async throws -> BoardDTO.Boards.Response
    /// 특정 공지사항 조회
    var board: @Sendable (_ boardID: Int) async throws -> BoardDTO.Board.Response
}

extension BoardClient: DependencyKey {
    static var liveValue: BoardClient = .init(
        boards: {
            let endPoint = BoardEndPoint.boards
            return try await APIClient.shared.request(endPoint, decode: BoardDTO.Boards.Response.self)
        },
        board: { boardID in
            let endPoint = BoardEndPoint.board(boardID: boardID)
            return try await APIClient.shared.request(endPoint, decode: BoardDTO.Board.Response.self)
        }
    )
}

extension DependencyValues {
    var boardClient: BoardClient {
        get { self[BoardClient.self] }
        set { self[BoardClient.self] = newValue }
    }
}
