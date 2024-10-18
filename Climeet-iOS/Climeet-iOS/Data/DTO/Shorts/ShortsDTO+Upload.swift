//
//  ShortsDTO+Upload.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.Upload {
    struct Request: Encodable {
        let video: Data
        let createShortsRequest: CreateShortsRequest
    }

    // MARK: - CreateShortsRequest
    struct CreateShortsRequest: Codable {
        let climbingGymID, routeID, sectorID: Int
        let thumbnailImageURL, description, shortsVisibility: String
        let soundEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case climbingGymID = "climbingGymId"
            case routeID = "routeId"
            case sectorID = "sectorId"
            case thumbnailImageURL = "thumbnailImageUrl"
            case description, shortsVisibility, soundEnabled
        }
        
        init(from request: ShortsRequest) {
            self.climbingGymID = request.climbingGymId
            self.routeID = request.routeId
            self.sectorID = request.sectorId
            self.thumbnailImageURL = request.thumbnailImageUrl
            self.description = request.description
            self.shortsVisibility = request.shortsVisibility
            self.soundEnabled = request.soundEnabled
        }
    }
}
