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
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .usersBlock: nil
        }
    }
    
    var token: String? { UserDefaults.standard.value(forKey: "token") as? String }
    
    var multipart: Alamofire.MultipartFormData? { nil }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw AppError.urlConvertingError("URL Component 조합 실패")
        }
        var request = URLRequest(url: url)
        request.headers = headers ?? .default
        request.method = method
        
        return request
    }
}
