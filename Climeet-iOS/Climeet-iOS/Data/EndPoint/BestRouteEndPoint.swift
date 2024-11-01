import Foundation
import NetworkKit
import Alamofire

enum BestRouteEndPoint {
    case rankWeeksRoutes
}

extension BestRouteEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeeksRoutes: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeeksRoutes: "/api/home/rank/weeks/routes"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeeksRoutes: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeeksRoutes: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
