//
//  ShortsBookmarkClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import NetworkKit
import Dependencies

struct ShortsBookmarkClient {
    /// 숏츠 북마크
    var bookmark: @Sendable (_ shortsID: Int) async throws -> String
}

extension ShortsBookmarkClient: DependencyKey {
    static var liveValue: ShortsBookmarkClient = .init(
        bookmark: { shortsID in
            let endPoint = ShortsBookmarkEndPoint.bookmark(shortsID: shortsID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var shortsBookmarkClient: ShortsBookmarkClient {
        get { self[ShortsBookmarkClient.self] }
        set { self[ShortsBookmarkClient.self] = newValue }
    }
}
