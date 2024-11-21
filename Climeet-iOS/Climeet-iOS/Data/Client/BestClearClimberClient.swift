//
//  BestClearClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestClearClimberClient {
    /// [완등순] 금주 베스트 클라이머 API
    var rankWeekClimbersClear: @Sendable () async throws -> BestClearClimberDTO.RankWeekClimbersClear.Response
}

extension BestClearClimberClient: DependencyKey {
    static var liveValue: BestClearClimberClient = .init(
        rankWeekClimbersClear: {
            let endPoint = BestClearClimberEndPoint.rankWeekClimbersClear
            return try await APIClient.shared.request(endPoint, decode: BestClearClimberDTO.RankWeekClimbersClear.Response.self)
        }
    )
    
    static var previewValue: BestClearClimberClient = .init(
        rankWeekClimbersClear: {
            return [
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 16,
                    ranking: 1,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "올라요잇",
                    thisWeekClearCount: 32
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 13,
                    ranking: 2,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_3.jpeg",
                    profileName: "넝쿨이",
                    thisWeekClearCount: 29
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 14,
                    ranking: 3,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "청주락",
                    thisWeekClearCount: 27
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 12,
                    ranking: 4,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_2.jpeg",
                    profileName: "오르락씨",
                    thisWeekClearCount: 24
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 15,
                    ranking: 5,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_6.jpeg",
                    profileName: "청주타",
                    thisWeekClearCount: 22
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 11,
                    ranking: 6,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "홍박사님",
                    thisWeekClearCount: 21
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 17,
                    ranking: 7,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "일번가",
                    thisWeekClearCount: 11
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 18,
                    ranking: 8,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "강마루",
                    thisWeekClearCount: 9
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 29,
                    ranking: 9,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/45042861-6053-4e51-b53f-02f872f9d2eb.jpg",
                    profileName: "노아",
                    thisWeekClearCount: 7
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 33,
                    ranking: 10,
                    profileImageURL: "http://k.kakaocdn.net/dn/nSULr/btrqnj9oPFK/9KmaDNJsD8E0W8336ePF70/img_640x640.jpg",
                    profileName: "MASTER",
                    thisWeekClearCount: 6
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 26,
                    ranking: 11,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "사당숭구리당당",
                    thisWeekClearCount: 4
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 25,
                    ranking: 12,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "양재양",
                    thisWeekClearCount: 4
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 19,
                    ranking: 13,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "아카데미생",
                    thisWeekClearCount: 4
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 22,
                    ranking: 14,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "연남짱",
                    thisWeekClearCount: 3
                ),
                BestClearClimberDTO.RankWeekClimbersClear.ResponseElement(
                    userID: 20,
                    ranking: 15,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "국제파",
                    thisWeekClearCount: 2
                )
            ]
        }
    )
}

extension DependencyValues {
    var bestClearClimberClient: BestClearClimberClient {
        get { self[BestClearClimberClient.self] }
        set { self[BestClearClimberClient.self] = newValue }
    }
}
