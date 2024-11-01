import Foundation
import NetworkKit
import Alamofire

enum BoardEndPoint {
    case boards
    case board(boardID: Int)
}

extension BoardEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .boards: .get
        case .board: .get
        }
    }
    
    var path: String {
        switch self {
        case .boards: "/boards"
        case .board(let boardID): "/boards/\(boardID)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .boards: nil
        case .board: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .boards: nil
        case .board: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
