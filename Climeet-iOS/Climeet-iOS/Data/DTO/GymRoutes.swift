//
//  GymRoutes.swift
//  Climeet-iOS
//
//  Created by KOVI on 7/2/24.
//

import Foundation

struct GymRoutes: Identifiable {
    let id = UUID()
    let gymId: Int?
    let timePoint: String?
    let floorLayout: [FloorLayout]?
    let sectors: [Sector]?
    let difficultyList: [Difficulty]?
    let maxFloor: Int?
    
    init(
        gymId: Int? = nil,
        timePoint: String? = nil,
        floorLayout: [FloorLayout]? = nil,
        sectors: [Sector]? = nil,
        difficultyList: [Difficulty]? = nil,
        maxFloor: Int? = nil
    ) {
        self.gymId = gymId
        self.timePoint = timePoint
        self.floorLayout = floorLayout
        self.sectors = sectors
        self.difficultyList = difficultyList
        self.maxFloor = maxFloor
    }
    
    init(from dto: RouteVersionDTO.GymVersionKey.Response) {
        self.gymId = dto.gymID
        self.timePoint = dto.timePoint
        self.floorLayout = dto.layoutList?.compactMap {
            FloorLayout(
                id: $0.id,
                imgUrl: $0.imgURL,
                floor: $0.floor
            )
        }
        self.sectors = dto.sectorList?.compactMap {
            Sector(
                sectorId: $0.sectorID,
                name: $0.name,
                floor: $0.floor,
                imgUrl: $0.imgURL
            )
        }
        self.difficultyList = dto.difficultyList?.compactMap {
            Difficulty(
                climeetDifficultyName: $0.climeetDifficultyName,
                gymDifficultyName: $0.gymDifficultyName,
                difficulty: $0.difficulty,
                gymDifficultyColor: $0.gymDifficultyColor
            )
        }
        self.maxFloor = dto.maxFloor
    }
}

struct FloorLayout: Identifiable {
    let id: Int?
    let imgUrl: String?
    let floor: Int?
    
    init(
        id: Int? = nil,
        imgUrl: String? = nil,
        floor: Int? = nil
    ) {
        self.id = id
        self.imgUrl = imgUrl
        self.floor = floor
    }
}

struct Sector: Identifiable {
    let id = UUID()
    let sectorId: Int?
    let name: String?
    let floor: Int?
    let imgUrl: String?
    
    init(
        sectorId: Int? = nil,
        name: String? = nil,
        floor: Int? = nil,
        imgUrl: String? = nil
    ) {
        self.sectorId = sectorId
        self.name = name
        self.floor = floor
        self.imgUrl = imgUrl
    }
}

struct Difficulty: Identifiable, Equatable {
    let id = UUID()
    let climeetDifficultyName: String?
    let gymDifficultyName: String?
    let difficulty: Int?
    let gymDifficultyColor: String?
    
    init(
        climeetDifficultyName: String? = nil,
        gymDifficultyName: String? = nil ,
        difficulty: Int? = nil,
        gymDifficultyColor: String? = nil
    ) {
        self.climeetDifficultyName = climeetDifficultyName
        self.gymDifficultyName = gymDifficultyName
        self.difficulty = difficulty
        self.gymDifficultyColor = gymDifficultyColor
    }
}
