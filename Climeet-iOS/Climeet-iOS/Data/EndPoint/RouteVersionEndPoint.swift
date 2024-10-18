import Foundation
import NetworkKit
import Alamofire

enum RouteVersionEndPoint {
    case gymVersionList(gymID: Int)
    case gymVersionKey(gymID: Int, timePoint: String?)
    case gymVersionAll(timePoint: String)
    case gymVersionRoute(RouteVersionDTO.GymVersionRoute.Request)
    case addGymVersion(RouteVersionDTO.AddGymVersion.Request)
}

extension RouteVersionEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .gymVersionList, .gymVersionKey, .gymVersionAll: .get
        case .gymVersionRoute, .addGymVersion: .post
        }
    }
    
    var path: String {
        switch self {
        case .gymVersionList(let gymID): "/api/gyms/\(gymID)/version/list"
        case .gymVersionKey(let gymID, _): "/api/gyms/\(gymID)/version/key"
        case .gymVersionAll: "/api/gyms/version/all"
        case .gymVersionRoute(let param): "/api/gyms/\(param.gymID)/version/route"
        case .addGymVersion: "/api/gyms/version"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gymVersionList: nil
        case .gymVersionKey(_, let timePoint): [.init(name: "timePoint", value: timePoint)]
        case .gymVersionAll(let timePoint): [.init(name: "timePoint", value: timePoint)]
        case .gymVersionRoute, .addGymVersion: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .gymVersionList, .gymVersionKey, .gymVersionAll:
            return nil
        case .gymVersionRoute(let param):
            if param.timePoint != nil {
                return [
                    "page": param.page,
                    "size": param.size,
                    "floor": param.floor,
                    "sectorID": param.sectorID,
                    "difficulty": param.difficulty,
                    "timePoint": param.timePoint!  // swiftlint:disable:this force_unwrapping
                ]
            } else {
                return [
                    "page": param.page,
                    "size": param.size,
                    "floor": param.floor,
                    "sectorID": param.sectorID,
                    "difficulty": param.difficulty
                ]
            }
        case .addGymVersion(let param):
            return [
                "timePoint": param.timePoint,
                "existingData": param.existingData,
                "newData": param.newData
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
