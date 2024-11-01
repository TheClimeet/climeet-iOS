//
//  ShortsDeckItem.swift
//  Climeet-iOS
//
//  Created by mac on 8/23/24.
//

import Foundation

//TODO: DTO 역할 분리
struct ShortsDeck: Decodable, Equatable, Hashable {
    let page: Int
    let hasNext: Bool
    let result: [ShortsDeckItem]
}

struct ShortsDeckItem: Decodable, Equatable, Hashable {        
    let shortsId: Int
    let thumbnailImageUrl: String
    let gymName: String
    let gymDifficultyName: String
    let gymDifficultyColor: String
    let isManager: Bool
    let shortsDetailInfo: ShortsDetailInfo
}

struct ShortsDetailInfo: Decodable, Equatable, Hashable {
    let userShortsSimpleInfo: UserShortsSimpleInfo
    let shortsId: Int
    let gymName: String
    let sectorName: String
    let gymId: Int
    let sectorId: Int
    let videoUrl: String
    let likeCount: Int
    let commentCount: Int
    let bookmarkCount: Int
    let shareCount: Int
    let isLiked: Bool
    let isBookmarked: Bool
    let description: String
    let routeImageUrl: String?
    let gymDifficultyName: String
    let gymDifficultyColor: String
    let isSoundEnabled: Bool
}

struct UserShortsSimpleInfo: Decodable, Equatable, Hashable {
    let userId: Int
    let profileImgUrl: String
    let profileName: String
}
