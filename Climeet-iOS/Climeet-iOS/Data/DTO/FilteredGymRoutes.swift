//
//  FilteredGymRoutes.swift
//  Climeet-iOS
//
//  Created by KOVI on 7/20/24.
//

import Foundation

struct FilteredRouteResult {
    let page: Int
    let hasNext: Bool
    let result: [FilteredRoute]
}

struct FilteredRoute: Identifiable, Equatable {
    var id = UUID()
    let routeId: Int?
    let sectorId: Int?
    let sectorName: String?
    let climeetDifficultyName: String?
    let difficulty: Int?
    let gymDifficultyName: String?
    let gymDifficultyColor: String?
    let routeImageUrl: String?
    let holdColor: String?
    
    init(
        routeId: Int? = nil,
        sectorId: Int? = nil,
        sectorName: String? = nil,
        climeetDifficultyName: String? = nil,
        difficulty: Int? = nil,
        gymDifficultyName: String? = nil,
        gymDifficultyColor: String? = nil,
        routeImageUrl: String? = nil,
        holdColor: String? = nil
    ) {
        self.routeId = routeId
        self.sectorId = sectorId
        self.sectorName = sectorName
        self.climeetDifficultyName = climeetDifficultyName
        self.difficulty = difficulty
        self.gymDifficultyName = gymDifficultyName
        self.gymDifficultyColor = gymDifficultyColor
        self.routeImageUrl = routeImageUrl
        self.holdColor = holdColor
    }
    
    init(from dto: RouteVersionDTO.RouteList) {
        self.routeId = dto.routeID
        self.sectorId = dto.sectorID
        self.sectorName = dto.sectorName
        self.climeetDifficultyName = dto.climeetDifficultyName
        self.difficulty = dto.difficulty
        self.gymDifficultyName = dto.gymDifficultyName
        self.gymDifficultyColor = dto.gymDifficultyColor
        self.routeImageUrl = dto.routeImageURL
        self.holdColor = dto.holdColor
    }
}
