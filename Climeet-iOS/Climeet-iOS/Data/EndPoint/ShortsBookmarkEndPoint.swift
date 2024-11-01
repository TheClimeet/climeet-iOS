import Foundation
import NetworkKit
import Alamofire

enum ShortsBookmarkEndPoint {
    case bookmark(shortsID: Int)
}

extension ShortsBookmarkEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .bookmark: .patch
        }
    }
    
    var path: String {
        switch self {
        case .bookmark(let shortsID): "/api/shorts/\(shortsID)/bookmarks"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .bookmark: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .bookmark: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
}
