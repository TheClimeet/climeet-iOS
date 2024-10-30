//
//  ShortsLikeClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/12/24.
//

import NetworkKit
import Dependencies

struct ShortsLikeClient {
    /// 숏츠 댓글 조회
    var like: @Sendable (_ shortsID: Int) async throws -> String
}

extension ShortsLikeClient: DependencyKey {
    static var liveValue: ShortsLikeClient = .init(
        like: { shortsID in
            let endPoint = ShortsLikeEndPoint.like(shortsID: shortsID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var shortsLikeClient: ShortsLikeClient {
        get { self[ShortsLikeClient.self] }
        set { self[ShortsLikeClient.self] = newValue }
    }
}
