import Foundation
import NetworkKit
import Alamofire

enum DifficultyMappingEndPoint {
    case gymDifficulty(gymID: Int)
    case difficultyColor
}

extension DifficultyMappingEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .gymDifficulty, .difficultyColor: .get
        }
    }
    
    var path: String {
        switch self {
        case .gymDifficulty(let gymID): "/api/gyms/\(gymID)/difficulty"
        case .difficultyColor: "/api/gyms/difficulty/color"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gymDifficulty, .difficultyColor: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .gymDifficulty, .difficultyColor: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
