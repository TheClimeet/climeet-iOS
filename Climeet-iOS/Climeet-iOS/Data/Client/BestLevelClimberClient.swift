//
//  BestLevelClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestLevelClimberClient {
    /// [레벨순] 금주 베스트 클라이머 API
    var rankWeeksClimbersLevel: @Sendable () async throws -> BestLevelClimberDTO.RankWeeksClimbersLevel.Response
}

extension BestLevelClimberClient: DependencyKey {
    static var liveValue: BestLevelClimberClient = .init(
        rankWeeksClimbersLevel: {
            let endPoint = BestLevelClimberEndPoint.rankWeeksClimbersLevel
            return try await APIClient.shared.request(endPoint, decode: BestLevelClimberDTO.RankWeeksClimbersLevel.Response.self)
        }
    )
    
    static var previewValue: BestLevelClimberClient = .init(
        rankWeeksClimbersLevel: {
            return [
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 12,
                    ranking: 1,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_2.jpeg",
                    profileName: "오르락씨",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 33
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 13,
                    ranking: 2,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_3.jpeg",
                    profileName: "넝쿨이",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 29
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 11,
                    ranking: 3,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "홍박사님",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 29
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 14,
                    ranking: 4,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "청주락",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 25
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 15,
                    ranking: 5,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_6.jpeg",
                    profileName: "청주타",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 22
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 16,
                    ranking: 6,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "올라요잇",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 21
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 17,
                    ranking: 7,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "일번가",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 13
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 18,
                    ranking: 8,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "강마루",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 9
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 21,
                    ranking: 9,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_4.jpeg",
                    profileName: "일산짱",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 8
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 19,
                    ranking: 10,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "아카데미생",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 7
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 33,
                    ranking: 11,
                    profileImageURL: "http://k.kakaocdn.net/dn/nSULr/btrqnj9oPFK/9KmaDNJsD8E0W8336ePF70/img_640x640.jpg",
                    profileName: "MASTER",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 7
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 20,
                    ranking: 12,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "국제파",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 6
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 24,
                    ranking: 13,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "신림고릴라",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 6
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 23,
                    ranking: 14,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "마곡짱",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 6
                ),
                BestLevelClimberDTO.RankWeeksClimbersLevel.ResponseElement(
                    userID: 22,
                    ranking: 15,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "연남짱",
                    thisWeekHighDifficulty: 10,
                    highDifficultyCount: 5
                )
            ]
        }
    )
}

extension DependencyValues {
    var bestLevelClimberClient: BestLevelClimberClient {
        get { self[BestLevelClimberClient.self] }
        set { self[BestLevelClimberClient.self] = newValue }
    }
}
