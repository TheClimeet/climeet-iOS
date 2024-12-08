//
//  BestRecordGymInfo.swift
//  Climeet-iOS
//
//  Created by 권승용 on 12/6/24.
//

struct BestRecordGymInfo: Identifiable, Equatable {
    let id: Int
    let rank: Int
    let name: String
    let selectionCount: Int
    let profileImageURL: String
    
    init(from dto: BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement) throws {
        guard let id = dto.gymID,
              let rank = dto.ranking,
              let name = dto.gymName,
              let selectionCount = dto.thisWeekSelectionCount,
              let profileImageURL = dto.profileImageURL else {
            throw AppError.dataParsingError("dto 변환 실패")
        }
        self.id = id
        self.rank = rank
        self.name = name
        self.selectionCount = selectionCount
        self.profileImageURL = profileImageURL
    }
}
