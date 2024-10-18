//
//  ShortsDTO+Shorts.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.Shorts {
    struct Response: Decodable {
        let shortsID: Int?
        let thumbnailImageURL, gymName, gymDifficultyName, gymDifficultyColor: String?
        let isManager: Bool?
        let shortsDetailInfo: ShortsDetailInfoDTO?

        enum CodingKeys: String, CodingKey {
            case shortsID = "shortsId"
            case thumbnailImageURL = "thumbnailImageUrl"
            case gymName, gymDifficultyName, gymDifficultyColor, isManager, shortsDetailInfo
        }
        
        func toEntity() -> ShortsDeckItem? {
            guard let shortsID,
                  let thumbnailImageURL,
                  let gymName,
                  let gymDifficultyName,
                  let gymDifficultyColor,
                  let isManager,
                  let detailInfo = shortsDetailInfo?.toEntity() else {
                return nil
            }
            return ShortsDeckItem(
                shortsId: shortsID,
                thumbnailImageUrl: thumbnailImageURL,
                gymName: gymName,
                gymDifficultyName: gymDifficultyName,
                gymDifficultyColor: gymDifficultyColor,
                isManager: isManager,
                shortsDetailInfo: detailInfo
            )
        }
    }

    // MARK: - ShortsDetailInfoDTO
    struct ShortsDetailInfoDTO: Codable {
        let userShortsSimpleInfo: UserShortsSimpleInfoDTO?
        let shortsID: Int?
        let gymName, sectorName: String?
        let gymID, sectorID: Int?
        let videoURL: String?
        let likeCount, commentCount, bookmarkCount, shareCount: Int?
        let isLiked, isBookmarked: Bool?
        let description, routeImageURL, gymDifficultyName, gymDifficultyColor: String?
        let isSoundEnabled: Bool?

        enum CodingKeys: String, CodingKey {
            case userShortsSimpleInfo
            case shortsID = "shortsId"
            case gymName, sectorName
            case gymID = "gymId"
            case sectorID = "sectorId"
            case videoURL = "videoUrl"
            case likeCount, commentCount, bookmarkCount, shareCount, isLiked, isBookmarked, description
            case routeImageURL = "routeImageUrl"
            case gymDifficultyName, gymDifficultyColor, isSoundEnabled
        }
        
        func toEntity() -> ShortsDetailInfo? {
            guard let simpleInfo = userShortsSimpleInfo?.toEntity(),
                  let shortsID,
                  let gymName,
                  let sectorName,
                  let gymID,
                  let sectorID,
                  let videoURL,
                  let likeCount,
                  let commentCount,
                  let bookmarkCount,
                  let shareCount,
                  let isLiked,
                  let isBookmarked,
                  let description,
                  let routeImageURL,
                  let gymDifficultyName,
                  let gymDifficultyColor,
                  let isSoundEnabled else { return nil }
            return ShortsDetailInfo(
                userShortsSimpleInfo: simpleInfo,
                shortsId: shortsID,
                gymName: gymName,
                sectorName: sectorName,
                gymId: gymID,
                sectorId: sectorID,
                videoUrl: videoURL,
                likeCount: likeCount,
                commentCount: commentCount,
                bookmarkCount: bookmarkCount,
                shareCount: shareCount,
                isLiked: isLiked,
                isBookmarked: isBookmarked,
                description: description,
                routeImageUrl: routeImageURL,
                gymDifficultyName: gymDifficultyName,
                gymDifficultyColor: gymDifficultyColor,
                isSoundEnabled: isSoundEnabled
            )
        }
    }

    // MARK: - UserShortsSimpleInfoDTO
    struct UserShortsSimpleInfoDTO: Codable {
        let userID: Int?
        let profileImgURL, profileName: String?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case profileImgURL = "profileImgUrl"
            case profileName
        }
        
        func toEntity() -> UserShortsSimpleInfo? {
            guard let userID,
                  let profileImgURL,
                  let profileName else { return nil }
            
            return UserShortsSimpleInfo(
                userId: userID,
                profileImgUrl: profileImgURL,
                profileName: profileName
            )
        }
    }
}
