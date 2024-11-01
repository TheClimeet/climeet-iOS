import Foundation
import NetworkKit
import Alamofire

enum BestTimeClimberEndPoint {
    case rankWeeksClimbersTime
}

extension BestTimeClimberEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeeksClimbersTime: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeeksClimbersTime: "/api/home/rank/weeks/climbers/time"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeeksClimbersTime: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeeksClimbersTime: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
