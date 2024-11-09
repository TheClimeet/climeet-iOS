//
//  BestLevelClimber.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/7/24.
//

import Foundation

struct BestLevelClimber: Identifiable, Equatable {
    let id = UUID()
    let userID: Int
    let ranking: Int
    let profileImageURL: String
    let profileName: String
    let thisWeekHighDifficulty: Int
    let highDifficultyCount: Int
    
    init(from dto: BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement) throws {
        guard let userID = dto.userID,
              let ranking = dto.ranking,
              let profileImageURL = dto.profileImageURL,
              let profileName = dto.profileName,
              let thisWeekHighDifficulty = dto.thisWeekHighDifficulty,
              let highDifficultyCount = dto.highDifficultyCount else {
            throw AppError.dataParsingError("DTO 변환 실패")
        }
        
        self.userID = userID
        self.ranking = ranking
        self.profileImageURL = profileImageURL
        self.profileName = profileName
        self.thisWeekHighDifficulty = thisWeekHighDifficulty
        self.highDifficultyCount = highDifficultyCount
    }
}
