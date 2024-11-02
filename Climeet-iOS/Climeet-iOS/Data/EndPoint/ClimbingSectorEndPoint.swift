import Foundation
import NetworkKit
import Alamofire

enum ClimbingSectorEndPoint {
    case sector(gymID: Int)
}

extension ClimbingSectorEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .sector: .get
        }
    }
    
    var path: String {
        switch self {
        case .sector(let gymID): "/api/gyms/\(gymID)/sector"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .sector: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .sector: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
