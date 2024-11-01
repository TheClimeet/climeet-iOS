import Foundation
import NetworkKit
import Alamofire

enum EvaluationEndPoint {
    case evaluation(content: String, rating: Int)
}

extension EvaluationEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .evaluation: .post
        }
    }
    
    var path: String {
        switch self {
        case .evaluation: "/api/evaluation"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .evaluation: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .evaluation(let content, let rating):
            return [
                "content": content,
                "rating": rating
            ]
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
