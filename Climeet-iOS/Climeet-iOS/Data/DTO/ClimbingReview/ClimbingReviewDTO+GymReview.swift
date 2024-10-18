//
//  ClimbingReviewDTO+GymReview.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingReviewDTO.GymReviews {
    struct Request: Encodable {
        let gymID: Int
        let page: Int
        let size: Int
    }
    
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: Result?
    }

    // MARK: - Result
    struct Result: Codable {
        let summary: Summary?
        let reviewList: [ReviewList]?
    }

    // MARK: - ReviewList
    struct ReviewList: Codable {
        let userID: Int?
        let profileImageURL, profileName: String?
        let rating: Int?
        let content, updatedAt: String?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case profileImageURL = "profileImageUrl"
            case profileName, rating, content, updatedAt
        }
    }

    // MARK: - Summary
    struct Summary: Codable {
        let gymID: Int?
        let averageRating, reviewCount: Int?
        let myReview: ReviewList?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case averageRating, reviewCount, myReview
        }
    }
}
