//
//  ClimbingRecordsClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import NetworkKit
import Dependencies

struct ClimbingRecordsClient {
    /// ClimbingRecord 삭제
    var delete: @Sendable (_ id: Int) async throws -> String
    /// 클라이밍 간편 기록 전체 조회
    var climbingRecords: @Sendable () async throws -> ClimbingRecordsDTO.ClimbingRecords.Response
    /// 클라이밍 기록 id 조회
    var climbingRecord: @Sendable (_ id: Int) async throws -> ClimbingRecordsDTO.ClimbingRecord.Response
    /// [유저프로필] 유저별 전체 임장에 대한 누적 통계
    var usersStatistics: @Sendable (_ userID: Int) async throws -> ClimbingRecordsDTO.UsersStatistics.Response
    /// 유저별 운동한 임장 리스트 조회
    var usersList: @Sendable (_ userID: Int) async throws -> ClimbingRecordsDTO.UsersList.Response
    /// 유저별 특정 임장에 대한 누적 통계
    var gymsStatistics: @Sendable (_ userID: Int, _ gymID: Int) async throws -> ClimbingRecordsDTO.GymsStatistics.Response
    /// 나의 월별 운동기록 통계
    var myStatisticsMonths: @Sendable (_ year: Int, _ month: Int) async throws -> ClimbingRecordsDTO.MyStatisticsMonths.Response
    /// 나의 운동한 임장 리스트 조회
    var myMonthsList: @Sendable (_ year: Int, _ month: Int) async throws -> ClimbingRecordsDTO.UsersList.Response
    /// 특정 임장에 대한 나의 월 통계
    var myGymStatisticsMonth: @Sendable (ClimbingRecordsDTO.MyGymStatisticsMonth.Request) async throws -> ClimbingRecordsDTO.MyGymStatisticsMonth.Response
    /// 임장별 주간 평균 완등률 통계
    var gymStatisticsWeeks: @Sendable (_ gymID: Int) async throws -> ClimbingRecordsDTO.GymStatisticsWeeks.Response
    /// [시간순] 임장별 클라이머 랭킹
    var gymRankWeeksClimbersTime: @Sendable (_ gymID: Int) async throws -> ClimbingRecordsDTO.GymRankWeeksClimbersTime.Response
    /// [높은 레벨순] 임장별 클라이머 랭킹
    var gymRankWeeksClimbersLevel: @Sendable (_ gymID: Int) async throws -> ClimbingRecordsDTO.GymRankWeeksClimbersLevel.Response
    /// [완등순] 임장별 클라이머 랭킹
    var gymRankWeeksClimbersClear: @Sendable (_ gymID: Int) async throws -> ClimbingRecordsDTO.GymRankWeeksClimbersClear.Response
    /// ClimbingRecord 수정
    var update: @Sendable (ClimbingRecordsDTO.Update.Request) async throws -> ClimbingRecordsDTO.Update.Response
    /// ClimbingRecord 생성
    var create: @Sendable (ClimbingRecordsDTO.Create.Request) async throws -> String
}

extension ClimbingRecordsClient: DependencyKey {
    static var liveValue: ClimbingRecordsClient = .init(
        delete: { id in
            let endPoint = ClimbingRecordsEndPoint.delete(id: id)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        },
        climbingRecords: {
            let endPoint = ClimbingRecordsEndPoint.climbingRecords
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.ClimbingRecords.Response.self)
        },
        climbingRecord: { id in
            let endPoint = ClimbingRecordsEndPoint.climbingRecords
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.ClimbingRecord.Response.self)
        },
        usersStatistics: { userID in
            let endPoint = ClimbingRecordsEndPoint.usersStatistics(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.UsersStatistics.Response.self)
        },
        usersList: { userID in
            let endPoint = ClimbingRecordsEndPoint.usersList(userID: userID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.UsersList.Response.self)
        },
        gymsStatistics: { userID, gymID in
            let endPoint = ClimbingRecordsEndPoint.gymsStatistics(userID: userID, gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.GymsStatistics.Response.self)
        },
        myStatisticsMonths: { year, month in
            let endPoint = ClimbingRecordsEndPoint.myStatisticsMonths(year: year, month: month)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.MyStatisticsMonths.Response.self)
        },
        myMonthsList: { year, month in
            let endPoint = ClimbingRecordsEndPoint.myMonthsList(year: year, month: month)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.UsersList.Response.self)
        },
        myGymStatisticsMonth: { param in
            let endPoint = ClimbingRecordsEndPoint.myGymStatisticsMonth(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.MyGymStatisticsMonth.Response.self)
        },
        gymStatisticsWeeks: { gymID in
            let endPoint = ClimbingRecordsEndPoint.gymStatisticsWeeks(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.GymStatisticsWeeks.Response.self)
        },
        gymRankWeeksClimbersTime: { gymID in
            let endPoint = ClimbingRecordsEndPoint.gymRankWeeksClimbersTime(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.GymRankWeeksClimbersTime.Response.self)
        },
        gymRankWeeksClimbersLevel: { gymID in
            let endPoint = ClimbingRecordsEndPoint.gymRankWeeksClimbersLevel(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.GymRankWeeksClimbersLevel.Response.self)
        },
        gymRankWeeksClimbersClear: { gymID in
            let endPoint = ClimbingRecordsEndPoint.gymRankWeeksClimbersClear(gymID: gymID)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.GymRankWeeksClimbersClear.Response.self)
        },
        update: { param in
            let endPoint = ClimbingRecordsEndPoint.update(param)
            return try await APIClient.shared.request(endPoint, decode: ClimbingRecordsDTO.Update.Response.self)
        },
        create: { param in
            let endPoint = ClimbingRecordsEndPoint.create(param)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var climbingRecordsClient: ClimbingRecordsClient {
        get { self[ClimbingRecordsClient.self] }
        set { self[ClimbingRecordsClient.self] = newValue }
    }
}
