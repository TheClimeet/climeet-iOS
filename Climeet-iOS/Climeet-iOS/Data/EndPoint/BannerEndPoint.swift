import Foundation
import NetworkKit
import Alamofire

enum BannerEndPoint {
    case banners
}

extension BannerEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .banners: .get
        }
    }
    
    var path: String {
        switch self {
        case .banners: "/api/banners"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .banners: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .banners: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
    
    var multipart: Alamofire.MultipartFormData? { nil }
}
