//
//  BestTimeClimber.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/7/24.
//

import Foundation

struct BestTimeClimber: BestClimberable {
    let id = UUID()
    let userID: Int
    let ranking: Int
    let profileImageURL: String
    let profileName: String
    let thisWeekTotalClimbingTime: String
    var description: String {
        convertClimbingTime(thisWeekTotalClimbingTime)
    }
    
    init(from dto: BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement) throws {
        guard let userID = dto.userID,
              let ranking = dto.ranking,
              let profileImageURL = dto.profileImageURL,
              let profileName = dto.profileName,
              let thisWeekTotalClimbingTime = dto.thisWeekTotalClimbingTime else {
            throw AppError.dataParsingError("DTO 변환 실패")
        }
        
        self.userID = userID
        self.ranking = ranking
        self.profileImageURL = profileImageURL
        self.profileName = profileName
        self.thisWeekTotalClimbingTime = thisWeekTotalClimbingTime
    }
    
    private func convertClimbingTime(_ time: String) -> String {
        let timeInfo = time.split(separator: ":")
        var timeToPrint = ""
        var hourInfo = "00"
        var minuteInfo = "00"
        var secondInfo = "00"
        if let safeInfo = timeInfo[safe: 0] {
            hourInfo = String(safeInfo)
        }
        if let safeInfo = timeInfo[safe: 1] {
            minuteInfo = String(safeInfo)
        }
        if let safeInfo = timeInfo[safe: 2] {
            secondInfo = String(safeInfo)
        }
        timeToPrint += hourInfo + "h "
        timeToPrint += minuteInfo + "m "
        timeToPrint += secondInfo + "s"
        return timeToPrint
    }
}
