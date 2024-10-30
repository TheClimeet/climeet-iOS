//
//  BlockUserClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BlockUserClient {
    /// 유저 차단하기
    var usersBlock: @Sendable (_ userID: Int) async throws -> Bool
}

extension BlockUserClient: DependencyKey {
    static var liveValue: BlockUserClient = .init(
        usersBlock: { userID in
            let endPoint = BlockUserEndPoint.usersBlock(userID: userID)
            let response = try await APIClient.shared.request(endPoint, decode: String.self)
            return !response.isEmpty
        }
    )
}

extension DependencyValues {
    var blockUserClient: BlockUserClient {
        get { self[BlockUserClient.self] }
        set { self[BlockUserClient.self] = newValue }
    }
}
