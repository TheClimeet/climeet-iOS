//
//  BestTimeClimberClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BestTimeClimberClient {
    /// [시간순] 금주 베스트 클라이머 API
    var rankWeeksClimbersTime: @Sendable () async throws -> BestTimeClimberDTO.RankWeeksClimbersTime.Response
}

extension BestTimeClimberClient: DependencyKey {
    static var liveValue: BestTimeClimberClient = .init(
        rankWeeksClimbersTime: {
            let endPoint = BestTimeClimberEndPoint.rankWeeksClimbersTime
            return try await APIClient.shared.request(endPoint, decode: BestTimeClimberDTO.RankWeeksClimbersTime.Response.self)
        }
    )
    
    static var previewValue: BestTimeClimberClient = .init(
        rankWeeksClimbersTime: {
            return [
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 33,
                    ranking: 1,
                    profileImageURL: "http://k.kakaocdn.net/dn/nSULr/btrqnj9oPFK/9KmaDNJsD8E0W8336ePF70/img_640x640.jpg",
                    profileName: "MASTER",
                    thisWeekTotalClimbingTime: "274:24:00"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 14,
                    ranking: 2,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "청주락",
                    thisWeekTotalClimbingTime: "57:42:57"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 13,
                    ranking: 3,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_3.jpeg",
                    profileName: "넝쿨이",
                    thisWeekTotalClimbingTime: "54:29:37"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 11,
                    ranking: 4,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "홍박사님",
                    thisWeekTotalClimbingTime: "51:11:42"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 16,
                    ranking: 5,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "올라요잇",
                    thisWeekTotalClimbingTime: "50:05:25"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 12,
                    ranking: 6,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_2.jpeg",
                    profileName: "오르락씨",
                    thisWeekTotalClimbingTime: "48:50:50"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 15,
                    ranking: 7,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/dummy/user_profile/profile_6.jpeg",
                    profileName: "청주타",
                    thisWeekTotalClimbingTime: "35:25:46"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 25,
                    ranking: 8,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "양재양",
                    thisWeekTotalClimbingTime: "27:15:14"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 23,
                    ranking: 9,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "마곡짱",
                    thisWeekTotalClimbingTime: "23:26:01"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 29,
                    ranking: 10,
                    profileImageURL: "https://climeet-staging-bucket.s3.ap-northeast-2.amazonaws.com/45042861-6053-4e51-b53f-02f872f9d2eb.jpg",
                    profileName: "노아",
                    thisWeekTotalClimbingTime: "18:05:33"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 22,
                    ranking: 11,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "연남짱",
                    thisWeekTotalClimbingTime: "16:37:32"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 17,
                    ranking: 12,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "일번가",
                    thisWeekTotalClimbingTime: "15:27:22"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 34,
                    ranking: 13,
                    profileImageURL: "http://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
                    profileName: "마스터관리자",
                    thisWeekTotalClimbingTime: "14:08:11"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 26,
                    ranking: 14,
                    profileImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/c161efac-5756-4870-82f8-d9784e41223e.jpeg",
                    profileName: "사당숭구리당당",
                    thisWeekTotalClimbingTime: "13:53:08"
                ),
                BestTimeClimberDTO.RankWeeksClimbersTime.ResponseElement(
                    userID: 31,
                    ranking: 15,
                    profileImageURL: "http://k.kakaocdn.net/dn/kni8P/btsDfPzY8Gz/JQ0b4G97tOsNNUaCRBSy30/img_640x640.jpg",
                    profileName: "후니",
                    thisWeekTotalClimbingTime: "13:00:02"
                )
            ]
        }
    )
}

extension DependencyValues {
    var bestTimeClimberClient: BestTimeClimberClient {
        get { self[BestTimeClimberClient.self] }
        set { self[BestTimeClimberClient.self] = newValue }
    }
}
