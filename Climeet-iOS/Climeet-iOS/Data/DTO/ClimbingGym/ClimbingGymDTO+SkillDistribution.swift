//
//  ClimbingGymDTO+SkillDistribution.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.SkillDistribution {
    struct ResponseElement: Codable {
        let gymID, difficulty: Int
        let gymDifficultyName, gymDifficultyColor: String
        let percentage: Int

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case difficulty, gymDifficultyName, gymDifficultyColor, percentage
        }
    }

    typealias Response = [ClimbingGymDTO.SkillDistribution.ResponseElement]
}
