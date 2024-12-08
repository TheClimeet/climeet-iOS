//
//  BestFollowGymClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestFollowGymClient {
    /// [팔로우순] 금주 베스트 운동 기록 API
    var rankWeeksGymsFollow: @Sendable () async throws -> BestFollowGymDTO.RankWeeksGymsFollow.Response
}

extension BestFollowGymClient: DependencyKey {
    static var liveValue: BestFollowGymClient = .init(
        rankWeeksGymsFollow: {
            let endPoint = BestFollowGymEndPoint.rankWeeksGymsFollow
            return try await APIClient.shared.request(endPoint, decode: BestFollowGymDTO.RankWeeksGymsFollow.Response.self)
        }
    )
    
    static var previewValue: BestFollowGymClient = .init(
        rankWeeksGymsFollow: {
            return [
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 204,
                    ranking: 1,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/sillim_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 신림점",
                    thisWeekFollowerCount: 8,
                    rating: 5,
                    reviewCount: 2
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 5,
                    ranking: 2,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/cheongju-climbing-academy.png",
                    gymName: "청주 타기클라이밍센터",
                    thisWeekFollowerCount: 6,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 10,
                    ranking: 3,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/cheongju_international_profile.jpeg",
                    gymName: "청주국제스포츠클라이밍센터",
                    thisWeekFollowerCount: 6,
                    rating: 5,
                    reviewCount: 2
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 202,
                    ranking: 4,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/yeonnam_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 연남점",
                    thisWeekFollowerCount: 6,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 4,
                    ranking: 5,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/cheongju-rock.jpeg",
                    gymName: "청주락클라이밍센터",
                    thisWeekFollowerCount: 5,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 6,
                    ranking: 6,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/orda_profile.png",
                    gymName: "청주오르다클라이밍센터",
                    thisWeekFollowerCount: 5,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 1,
                    ranking: 7,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/hongseong-climbing.jpeg",
                    gymName: "홍성클라이밍센터",
                    thisWeekFollowerCount: 4,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 9,
                    ranking: 8,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/cheongju-climbing-academy.png",
                    gymName: "청주클라이밍아카데미",
                    thisWeekFollowerCount: 4,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 162,
                    ranking: 9,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/ilsan_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 일산점",
                    thisWeekFollowerCount: 4,
                    rating: 0,
                    reviewCount: 0
                ),
                BestFollowGymDTO.RankWeeksGymsFollow.ResponseElement(
                    gymID: 3,
                    ranking: 10,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/nungkul.jpeg",
                    gymName: "넝쿨클라이밍센터",
                    thisWeekFollowerCount: 3,
                    rating: 4,
                    reviewCount: 2
                )
            ]
        }
    )
}

extension DependencyValues {
    var bestFollowGymClient: BestFollowGymClient {
        get { self[BestFollowGymClient.self] }
        set { self[BestFollowGymClient.self] = newValue }
    }
}
