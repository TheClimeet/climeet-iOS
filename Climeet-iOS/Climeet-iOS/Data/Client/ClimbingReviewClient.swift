//
//  ClimbingReviewClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import NetworkKit
import Dependencies

struct ClimbingReviewClient {
    /// 특정 암장 리뷰 목록 조회
    var gymReviews: @Sendable (ClimbingReviewDTO.GymReviews.Request) async throws -> ClimbingReviewDTO.GymReviews.Response
    /// 암장 리뷰 수정
    var update: @Sendable (ClimbingReviewDTO.Request) async throws -> String
    /// 암장 리뷰 작성
    var create: @Sendable (ClimbingReviewDTO.Request) async throws -> String
}

extension ClimbingReviewClient: DependencyKey {
    static var liveValue: ClimbingReviewClient = .init(
        gymReviews: { param in
            let endPoint = ClimbingReviewEndPoint.gymReviews(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingReviewDTO.GymReviews.Response.self)
        },
        update: { param in
            let endPoint = ClimbingReviewEndPoint.update(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        create: { param in
            let endPoint = ClimbingReviewEndPoint.create(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var climbingReviewClient: ClimbingReviewClient {
        get { self[ClimbingReviewClient.self] }
        set { self[ClimbingReviewClient.self] = newValue }
    }
}
