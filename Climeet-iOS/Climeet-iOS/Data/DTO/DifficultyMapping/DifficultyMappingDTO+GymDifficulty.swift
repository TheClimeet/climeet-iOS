//
//  DifficultyMappingDTO+GymDifficulty.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import Foundation

extension DifficultyMappingDTO.GymDifficulty {
    struct ResponseElement: Decodable {
        let climeetDifficultyName, gymDifficultyName: String?
        let difficulty: Int?
        let gymDifficultyColor: String?
    }

    typealias Response = [DifficultyMappingDTO.GymDifficulty.ResponseElement]
}
