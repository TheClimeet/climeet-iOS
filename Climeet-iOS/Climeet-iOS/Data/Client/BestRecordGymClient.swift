//
//  BestRecordGymClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestRecordGymClient {
    /// [기록된 순(selected된 순)] 금주 베스트 운동 기록 API
    var rankWeeksGymsRecord: @Sendable () async throws -> BestRecordGymDTO.RankWeeksGymsRecord.Response
}

extension BestRecordGymClient: DependencyKey {
    static var liveValue: BestRecordGymClient = .init(
        rankWeeksGymsRecord: {
            let endPoint = BestRecordGymEndPoint.rankWeeksGymsRecord
            return try await APIClient.shared.request(endPoint, decode: BestRecordGymDTO.RankWeeksGymsRecord.Response.self)
        }
    )
    
    static var previewValue: BestRecordGymClient = .init(
        rankWeeksGymsRecord: {
            return [
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 1,
                    ranking: 1,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/hongseong-climbing.jpeg",
                    gymName: "홍성클라이밍센터",
                    thisWeekSelectionCount: 107,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 2,
                    ranking: 2,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/climbrock-climbing.jpeg",
                    gymName: "오르락클라이밍짐",
                    thisWeekSelectionCount: 46,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 3,
                    ranking: 3,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/nungkul.jpeg",
                    gymName: "넝쿨클라이밍센터",
                    thisWeekSelectionCount: 22,
                    rating: 4,
                    reviewCount: 2
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 162,
                    ranking: 4,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/ilsan_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 일산점",
                    thisWeekSelectionCount: 11,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 362,
                    ranking: 5,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/umc_profile_image.png",
                    gymName: "UMC 데모데이",
                    thisWeekSelectionCount: 6,
                    rating: 5,
                    reviewCount: 1
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 6,
                    ranking: 6,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/orda_profile.png",
                    gymName: "청주오르다클라이밍센터",
                    thisWeekSelectionCount: 4,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 202,
                    ranking: 7,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/yeonnam_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 연남점",
                    thisWeekSelectionCount: 3,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 5,
                    ranking: 8,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/climbing-profile/cheongju-climbing-academy.png",
                    gymName: "청주 타기클라이밍센터",
                    thisWeekSelectionCount: 1,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 203,
                    ranking: 9,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/magok_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 마곡점",
                    thisWeekSelectionCount: 1,
                    rating: 0,
                    reviewCount: 0
                ),
                BestRecordGymDTO.RankWeeksGymsRecord.ResponseElement(
                    gymID: 204,
                    ranking: 10,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/profile_back/sillim_profile.png",
                    gymName: "더클라임 클라이밍 짐앤샵 신림점",
                    thisWeekSelectionCount: 1,
                    rating: 5,
                    reviewCount: 2
                )
            ]
        }
    )
}

extension DependencyValues {
    var bestRecordGymClient: BestRecordGymClient {
        get { self[BestRecordGymClient.self] }
        set { self[BestRecordGymClient.self] = newValue }
    }
}
