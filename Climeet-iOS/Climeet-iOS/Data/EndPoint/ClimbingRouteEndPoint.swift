import Foundation
import NetworkKit
import Alamofire

enum ClimbingRouteEndPoint {
    case gymRoutes(gymID: Int)
    case gymRoute(routeID: Int)
}

extension ClimbingRouteEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .gymRoutes, .gymRoute: .get
        }
    }
    
    var path: String {
        switch self {
        case .gymRoutes(let gymID): "/api/gyms/\(gymID)/routes"
        case .gymRoute(let routeID): "/api/gyms/route/\(routeID)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gymRoutes, .gymRoute: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .gymRoutes, .gymRoute: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
