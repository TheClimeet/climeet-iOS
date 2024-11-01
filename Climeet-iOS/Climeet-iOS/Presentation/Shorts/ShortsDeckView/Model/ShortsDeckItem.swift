//
//  ShortsDeckItem.swift
//  Climeet-iOS
//
//  Created by mac on 8/23/24.
//

import Foundation

struct ShortsDeck {
    let page: Int
    let hasNext: Bool
    let result: [ShortsDeckItem]
}

//TODO: DTO 역할 분리
struct ShortsDeckItem: Hashable {
    let shortsId: Int
    let thumbnailImageUrl: String
    let gymName: String?
    let gymDifficultyName: String?
    let gymDifficultyColor: String?
    let isManager: Bool
    let shortsDetailInfo: ShortsDetailInfo
}

struct ShortsDetailInfo: Hashable {
    let userShortsSimpleInfo: UserShortsSimpleInfo
    let shortsId: Int
    let gymName: String?
    let sectorName: String?
    let gymId: Int?
    let sectorId: Int?
    let videoUrl: String
    let likeCount: Int
    let commentCount: Int
    let bookmarkCount: Int
    let shareCount: Int
    let isLiked: Bool
    let isBookmarked: Bool
    let description: String?
    let routeImageUrl: String?
    let gymDifficultyName: String?
    let gymDifficultyColor: String?
    let isSoundEnabled: Bool
}

struct UserShortsSimpleInfo: Hashable {
    let userId: Int
    let profileImgUrl: String?
    let profileName: String
}
