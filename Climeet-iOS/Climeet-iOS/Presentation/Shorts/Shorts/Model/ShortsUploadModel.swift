//
//  ShortsUploadModel.swift
//  Climeet-iOS
//
//  Created by mac on 7/20/24.
//

import Foundation

struct Shorts: Encodable, Equatable {
    let video: Data
    let createShortsRequest: ShortsRequest
    
    static func == (lhs: Shorts, rhs: Shorts) -> Bool {
        return lhs.video == rhs.video && lhs.createShortsRequest == rhs.createShortsRequest
    }
}

struct ShortsRequest: Encodable, Equatable {
    let climbingGymId: Int
    let routeId: Int
    let sectorId: Int
    let thumbnailImageUrl: String
    let description: String
    let shortsVisibility: String
    let soundEnabled: Bool
}
