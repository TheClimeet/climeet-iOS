import Foundation
import NetworkKit
import Alamofire

enum BoardLikeEndPoint {
    case unlike(boardID: Int)
    case like(boardID: Int)
}

extension BoardLikeEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .unlike: .patch
        case .like: .patch
        }
    }
    
    var path: String {
        switch self {
        case .unlike(let boardID): "/boards/\(boardID)/unlike"
        case .like(let boardID): "/boards/\(boardID)/like"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .unlike: nil
        case .like: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .unlike: nil
        case .like: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
