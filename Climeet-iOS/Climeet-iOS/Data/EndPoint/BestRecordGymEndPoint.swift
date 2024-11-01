import Foundation
import NetworkKit
import Alamofire

enum BestRecordGymEndPoint {
    case rankWeeksGymsRecord
}

extension BestRecordGymEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .rankWeeksGymsRecord: .get
        }
    }
    
    var path: String {
        switch self {
        case .rankWeeksGymsRecord: "/api/home/rank/weeks/gyms/record"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .rankWeeksGymsRecord: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .rankWeeksGymsRecord: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
