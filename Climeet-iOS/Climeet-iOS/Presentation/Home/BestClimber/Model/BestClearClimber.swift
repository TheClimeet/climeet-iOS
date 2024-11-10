//
//  BestClearClimber.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/7/24.
//

import Foundation

struct BestClearClimber: BestClimberable {
    let id = UUID()
    let userID: Int
    let ranking: Int
    let profileImageURL: String
    let profileName: String
    let thisWeekClearCount: Int
    var description: String {
        "\(thisWeekClearCount)개 완등"
    }
    
    init(from dto: BestClearClimberDTO.RankWeekClimbersClear.ResponseElement) throws {
        guard let userID = dto.userID,
              let ranking = dto.ranking,
              let profileImageURL = dto.profileImageURL,
              let profileName = dto.profileName,
              let thisWeekClearCount = dto.thisWeekClearCount else {
            throw AppError.dataParsingError("DTO 변환 실패")
        }
        
        self.userID = userID
        self.ranking = ranking
        self.profileImageURL = profileImageURL
        self.profileName = profileName
        self.thisWeekClearCount = thisWeekClearCount
    }
}
