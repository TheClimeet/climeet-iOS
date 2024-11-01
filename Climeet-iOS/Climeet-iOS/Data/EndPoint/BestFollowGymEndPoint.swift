import Foundation
import NetworkKit
import Alamofire

enum BestFollowGymEndPoint {
    case rankWeeksGymsFollow
}

extension BestFollowGymEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeeksGymsFollow: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeeksGymsFollow: "/api/home/rank/weeks/gyms/follow"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeeksGymsFollow: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeeksGymsFollow: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }

}
