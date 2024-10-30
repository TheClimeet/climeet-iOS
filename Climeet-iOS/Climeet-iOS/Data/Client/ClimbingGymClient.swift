//
//  ClimbingGymClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct ClimbingGymClient {
    /// 암장 프로필 정보 (상단) 불러오기
    var gym: @Sendable (_ gymID: Int) async throws -> ClimbingGymDTO.Gym.Response
    /// 암장 프로필 정보 (탭) 불러오기
    var gymTab: @Sendable (_ gymID: Int) async throws -> ClimbingGymDTO.GymTab.Response
    /// 암장 실력분포 조회
    var skillDistribution: @Sendable (_ gymID: Int) async throws -> ClimbingGymDTO.SkillDistribution.Response
    /// 특정 암장에서의 현재 내 실력 조회
    var mySkill: @Sendable (_ gymID: Int) async throws -> String
    /// Manager가 등록된 암장 검색 기능
    var search: @Sendable (ClimbingGymDTO.Search.Request) async throws -> ClimbingGymDTO.Search.Response
    /// Manager가 등록된 암장 검색 기능 + 팔로잉 여부
    var searchFollow: @Sendable (ClimbingGymDTO.Search.Request) async throws -> ClimbingGymDTO.SearchFollow.Response
    /// 전국 암장 검색 기능(자체 목록화)
    var searchAll: @Sendable (ClimbingGymDTO.Search.Request) async throws -> ClimbingGymDTO.SearchAll.Response
    /// 암장 제공 서비스 수정
    var service: @Sendable ([ServiceBitmask]) async throws -> String
    /// 암장 프로필 이미지 변경
    var profileImage: @Sendable (_ imageURL: String) async throws -> String
    /// 암장 이름 변경 요청 전송
    var name: @Sendable (_ name: String) async throws -> String
    /// 암장 배경사진 변경 (1개만 등록 가능)
    var backgroundImage: @Sendable (_ imageURL: String) async throws -> String
    /// 암장 크롤링 정보 입력
    var gymInfo: @Sendable (_ gymID: Int) async throws -> ClimbingGymDTO.GymInfo.Response
    /// 기본 가격(제공) 추가 & 수정
    var price: @Sendable (ClimbingGymDTO.Price.Request) async throws -> String
}

extension ClimbingGymClient: DependencyKey {
    static var liveValue: ClimbingGymClient = .init(
        gym: { gymID in
            let endPoint = ClimbingGymEndPoint.gym(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.Gym.Response.self)
        },
        gymTab: { gymID in
            let endPoint = ClimbingGymEndPoint.gymTab(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.GymTab.Response.self)
        },
        skillDistribution: { gymID in
            let endPoint = ClimbingGymEndPoint.skillDistribution(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.SkillDistribution.Response.self)
        },
        mySkill: { gymID in
            let endPoint = ClimbingGymEndPoint.mySkill(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        search: { param in
            let endPoint = ClimbingGymEndPoint.search(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.Search.Response.self)
        },
        searchFollow: { param in
            let endPoint = ClimbingGymEndPoint.searchFollow(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.SearchFollow.Response.self)
        },
        searchAll: { param in
            let endPoint = ClimbingGymEndPoint.searchAll(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.SearchAll.Response.self)
        },
        service: { serviceList in
            let endPoint = ClimbingGymEndPoint.service(serviceList)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        profileImage: { imageURL in
            let endPoint = ClimbingGymEndPoint.profileImage(imageURL: imageURL)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        name: { name in
            let endPoint = ClimbingGymEndPoint.name(name: name)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        backgroundImage: { imageURL in
            let endPoint = ClimbingGymEndPoint.backgroundImage(imageURL: imageURL)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        gymInfo: { gymID in
            let endPoint = ClimbingGymEndPoint.gymInfo(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingGymDTO.GymInfo.Response.self)
        },
        price: { param in
            let endPoint = ClimbingGymEndPoint.price(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var climbingGymClient: ClimbingGymClient {
        get { self[ClimbingGymClient.self] }
        set { self[ClimbingGymClient.self] = newValue }
    }
}
