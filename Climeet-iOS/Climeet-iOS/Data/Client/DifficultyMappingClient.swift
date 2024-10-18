//
//  DifficultyMappingClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import NetworkKit
import Dependencies

struct DifficultyMappingClient {
    /// 클밋 암장 난이도 매핑 조회
    var gymDifficulty: @Sendable (_ gymID: Int) async throws -> DifficultyMappingDTO.GymDifficulty.Response
    /// 암장 색 코드 목록 조회
    var difficultyColor: @Sendable () async throws -> DifficultyMappingDTO.DifficultyColor.Response
}

extension DifficultyMappingClient: DependencyKey {
    static var liveValue: DifficultyMappingClient = .init(
        gymDifficulty: { gymID in
            let endPoint = DifficultyMappingEndPoint.gymDifficulty(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: DifficultyMappingDTO.GymDifficulty.Response.self)
        },
        difficultyColor: {
            let endPoint = DifficultyMappingEndPoint.difficultyColor
            return try await APIClient.shared.request(endPoint, decode: DifficultyMappingDTO.DifficultyColor.Response.self)
        }
    )
}

extension DependencyValues {
    var difficultyMappingClient: DifficultyMappingClient {
        get { self[DifficultyMappingClient.self] }
        set { self[DifficultyMappingClient.self] = newValue }
    }
}
