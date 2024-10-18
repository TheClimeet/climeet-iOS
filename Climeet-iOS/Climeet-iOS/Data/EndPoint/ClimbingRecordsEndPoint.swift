import Foundation
import NetworkKit
import Alamofire

enum ClimbingRecordsEndPoint {
    case delete(id: Int)
    case climbingRecords
    case climbingRecord(id: Int)
    case usersStatistics(userID: Int)
    case usersList(userID: Int)
    case gymsStatistics(userID: Int, gymID: Int)
    case myStatisticsMonths(year: Int, month: Int)
    case myMonthsList(year: Int, month: Int)
    case myGymStatisticsMonth(ClimbingRecordsDTO.MyGymStatisticsMonth.Request)
    case gymStatisticsWeeks(gymID: Int)
    case gymRankWeeksClimbersTime(gymID: Int)
    case gymRankWeeksClimbersLevel(gymID: Int)
    case gymRankWeeksClimbersClear(gymID: Int)
    case update(ClimbingRecordsDTO.Update.Request)
    case create(ClimbingRecordsDTO.Create.Request)
}

extension ClimbingRecordsEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .delete: .delete
        case .climbingRecords, .climbingRecord, .usersStatistics, .usersList, .gymsStatistics: .get
        case .myStatisticsMonths, .myMonthsList, .myGymStatisticsMonth: .get
        case .gymStatisticsWeeks, .gymRankWeeksClimbersTime, .gymRankWeeksClimbersLevel, .gymRankWeeksClimbersClear: .get
        case .update: .patch
        case .create: .post
        }
    }
    
    var path: String {
        switch self {
        case .delete(let id): "/api/climbing-records/\(id)"
        case .climbingRecords: "/api/climbing-records"
        case .climbingRecord(let id): "/api/climbing-records/\(id)"
        case .usersStatistics(let id): "/api/climbing-records/users/\(id)/statistics"
        case .usersList(let id): "/api/climbing-records/users/\(id)/list"
        case .gymsStatistics(let userID, let gymID): "/api/climbing-records/users/\(userID)/gyms/\(gymID)/statistics"
        case .myStatisticsMonths: "/api/climbing-records/users/statistics/months"
        case .myMonthsList: "/api/climbing-records/users/months/list"
        case .myGymStatisticsMonth(let param): "/api/climbing-records/users/gyms/\(param.gymID)/statistics/months"
        case .gymStatisticsWeeks(let gymID): "/api/climbing-records/gyms/\(gymID)/statistics/weeks"
        case .gymRankWeeksClimbersTime(let gymID): "/api/climbing-records/gyms/\(gymID)/rank/weeks/climbers/time"
        case .gymRankWeeksClimbersLevel(let gymID): "/api/climbing-records/gyms/\(gymID)/rank/weeks/climbers/level"
        case .gymRankWeeksClimbersClear(let gymID): "/api/climbing-records/gyms/\(gymID)/rank/weeks/climbers/clear"
        case .update(let param): "/api/climbing-records/\(param.id)"
        case .create: "/api/climbing-records"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .delete, .climbingRecords, .climbingRecord, .usersStatistics, .usersList, .gymsStatistics:
            return nil
        case .myStatisticsMonths(let year, let month):
            return [
                .init(name: "year", value: String(year)),
                .init(name: "month", value: String(month))
            ]
        case .myMonthsList(let year, let month):
            return [
                .init(name: "year", value: String(year)),
                .init(name: "month", value: String(month))
            ]
        case .myGymStatisticsMonth(let param):
            return [
                .init(name: "year", value: String(param.year)),
                .init(name: "month", value: String(param.month))
            ]
        case .gymStatisticsWeeks, .gymRankWeeksClimbersTime, .gymRankWeeksClimbersLevel, .gymRankWeeksClimbersClear:
            return nil
        case .update, .create:
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .delete, .climbingRecords, .climbingRecord, .usersStatistics, .usersList, .gymsStatistics: nil
        case .myStatisticsMonths, .myMonthsList, .myGymStatisticsMonth: nil
        case .gymStatisticsWeeks, .gymRankWeeksClimbersTime, .gymRankWeeksClimbersLevel, .gymRankWeeksClimbersClear: nil
        case .update(let param): [
            "date": param.date,
            "time": param.time
        ]
        case .create(let param): [
            "gymId": param.gymID,
            "date": param.date,
            "time": param.time,
            "avgDifficulty": param.avgDifficulty,
            "routeRecordRequestDtoList": param.routeRecordRequestDtoList
        ]
        }
    }
    
    var token: String? { UserDefaults.standard.value(forKey: "token") as? String }
    
    var multipart: Alamofire.MultipartFormData? { nil }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw AppError.urlConvertingError("URL Component 조합 실패")
        }
        var request = URLRequest(url: url)
        request.headers = headers ?? .default
        request.method = method
        
        return request
    }
}
