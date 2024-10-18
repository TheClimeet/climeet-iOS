import Foundation
import NetworkKit
import Alamofire

enum RouteRecordsEndPoint {
    case delete(id: Int)
    case routeRecord(id: Int)
    case routeRecords
    case update(RouteRecordsDTO.Update.Request)
}

extension RouteRecordsEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .delete: .delete
        case .routeRecord: .get
        case .routeRecords: .get
        case .update: .patch
        }
    }
    
    var path: String {
        switch self {
        case .delete(let id): "/api/route-records/\(id)"
        case .routeRecord(let id): "/api/route-records/\(id)"
        case .routeRecords: "/api/route-records"
        case .update(let param): "/api/route-records/\(param.id)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .delete, .routeRecord, .routeRecords, .update: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .delete, .routeRecord, .routeRecords:
            return nil
        case .update(let param):
            return [
                "attemptCount": param.attemptCount,
                "isComplete": param.isComplete
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
