import Foundation
import NetworkKit
import Alamofire

enum ShortsLikeEndPoint {
    case like(shortsID: Int)
}

extension ShortsLikeEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .like: .patch
        }
    }
    
    var path: String {
        switch self {
        case .like(let shortsID): "/api/Shorts/\(shortsID)/likes"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .like: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .like: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
}
