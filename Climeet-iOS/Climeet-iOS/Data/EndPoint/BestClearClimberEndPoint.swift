import Foundation
import NetworkKit
import Alamofire

enum BestClearClimberEndPoint {
    case rankWeekClimbersClear
}

extension BestClearClimberEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeekClimbersClear: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeekClimbersClear: "/api/home/rank/weeks/climbers/clear"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeekClimbersClear: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeekClimbersClear: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
