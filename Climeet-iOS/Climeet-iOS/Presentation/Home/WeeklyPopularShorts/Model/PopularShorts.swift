//
//  PopularShorts.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/29/24.
//

import Foundation

struct PopularShorts: Equatable, Identifiable {
    let id = UUID()
    let gymName: String
    let thumbnailImageURL: String
    let difficulty: GymDifficulty
    
    init(from dto: ShortsDTO.Shorts.Response, difficulty: GymDifficulty) throws {
        guard let gymName = dto.gymName,
              let thumbnailImageURL = dto.thumbnailImageURL else {
            throw AppError.dataParsingError("dto property nil")
        }
        self.gymName = gymName
        self.thumbnailImageURL = thumbnailImageURL
        self.difficulty = difficulty
    }
}
