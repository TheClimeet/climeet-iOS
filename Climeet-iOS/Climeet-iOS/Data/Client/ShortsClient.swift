//
//  ShortsClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import NetworkKit
import Dependencies

struct ShortsClient {
    /// 숏츠 단일 조회
    var shorts: @Sendable (_ shortsID: Int) async throws -> ShortsDTO.Shorts.Response
    /// 내가 좋아요 누른 숏츠 조회
    var likedShorts: @Sendable (_ page: Int, _ size: Int) async throws -> ShortsDTO.List.Response
    /// 내가 북마크 숏츠 조회
    var bookmarkedShorts: @Sendable (_ page: Int, _ size: Int) async throws -> ShortsDTO.List.Response
    /// 특정 유저가 올린 숏츠 조회
    var uploaderShorts: @Sendable (ShortsDTO.Uploader.Request) async throws -> ShortsDTO.List.Response
    /// 숏츠 프로필 바 조회 (팔로우 하고있는 암장, 프로필 리스트 조회/최근에 영상을 올렸을 시 true)
    var profile: @Sendable () async throws -> ShortsDTO.Profile.Response
    /// 숏츠 인기순 조회 (gymId, sectorId, routeIds 미 입력시 전체 조회)
    var popularShorts: @Sendable (ShortsDTO.List.Request) async throws -> ShortsDTO.List.Response
    /// 내 숏츠 조회
    var myShorts: @Sendable (ShortsDTO.MyShorts.Request) async throws -> ShortsDTO.List.Response
    /// 숏츠 최신순 조회 (gymId, sectorId, routeIds 미 입력시 전체 조회)
    var latestShorts: @Sendable (ShortsDTO.List.Request) async throws -> ShortsDTO.List.Response
    /// 숏츠 조회수 증가
    var addViewCount: @Sendable (_ shortsID: Int) async throws -> String
    /// 숏츠 신고하기
    var report: @Sendable (_ shortsID: Int, _ reason: String) async throws -> String
    /// 숏츠 업로드
    var upload: @Sendable (ShortsDTO.Upload.Request) async throws -> String
}

extension ShortsClient: DependencyKey {
    static var liveValue: ShortsClient = .init(
        shorts: { shortsID in
            let endPoint = ShortsEndPoint.shorts(shortsID: shortsID)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.Shorts.Response.self)
        },
        likedShorts: { page, size in
            let endPoint = ShortsEndPoint.likedShorts(page: page, size: size)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        bookmarkedShorts: { page, size in
            let endPoint = ShortsEndPoint.bookmarkedShorts(page: page, size: size)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        uploaderShorts: { param in
            let endPoint = ShortsEndPoint.uploaderShorts(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        profile: {
            let endPoint = ShortsEndPoint.profile
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.Profile.Response.self)
        },
        popularShorts: { param in
            let endPoint = ShortsEndPoint.popularShorts(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        myShorts: { param in
            let endPoint = ShortsEndPoint.myShorts(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        latestShorts: { param in
            let endPoint = ShortsEndPoint.LatestShorts(param)
            return try await APIClient.shared.request(endPoint, decode: ShortsDTO.List.Response.self)
        },
        addViewCount: { shortsID in
            let endPoint = ShortsEndPoint.addViewCount(shortsID: shortsID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        report: { shortsID, reason in
            let endPoint = ShortsEndPoint.report(shortsID: shortsID, reason: reason)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        upload: { param in
            let endPoint = ShortsEndPoint.upload(param)
            return try await APIClient.shared.upload(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var shortsClient: ShortsClient {
        get { self[ShortsClient.self] }
        set { self[ShortsClient.self] = newValue }
    }
}
