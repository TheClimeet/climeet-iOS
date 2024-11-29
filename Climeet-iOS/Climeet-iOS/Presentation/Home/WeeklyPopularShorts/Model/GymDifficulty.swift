//
//  GymDifficulty.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/29/24.
//

import Foundation

struct GymDifficulty: Equatable {
    let level: Int
    let color: String
    
    init(from dto: DifficultyMappingDTO.GymDifficulty.ResponseElement) throws {
        guard let level = dto.difficulty,
              let color = dto.gymDifficultyColor else {
            throw AppError.dataParsingError("dto property nil")
        }
        self.level = level
        self.color = color
    }
}
