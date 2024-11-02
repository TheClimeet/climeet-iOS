import Foundation
import NetworkKit
import Alamofire

enum BlockUserEndPoint {
    case usersBlock(userID: Int)
}

extension BlockUserEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .usersBlock: .patch
        }
    }
    
    var path: String {
        switch self {
        case .usersBlock(let userID): "/api/users/\(userID)/block"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .usersBlock: nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .usersBlock: nil
        }
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .usersBlock: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
