import Foundation
import NetworkKit
import Alamofire

enum BestLevelClimberEndPoint {
    case rankWeeksClimbersLevel
}

extension BestLevelClimberEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeeksClimbersLevel: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeeksClimbersLevel: "/api/home/rank/weeks/climbers/level"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeeksClimbersLevel: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeeksClimbersLevel: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
