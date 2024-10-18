import Foundation
import NetworkKit
import Alamofire

enum ClimbingGymEndPoint {
    case gym(gymID: Int)
    case gymTab(gymID: Int)
    case skillDistribution(gymID: Int)
    case mySkill(gymID: Int)
    case search(ClimbingGymDTO.Search.Request)
    case searchFollow(ClimbingGymDTO.Search.Request)
    case searchAll(ClimbingGymDTO.Search.Request)
    case service([ServiceBitmask])
    case profileImage(imageURL: String)
    case name(name: String)
    case backgroundImage(imageURL: String)
    case gymInfo(gymID: Int)
    case price(ClimbingGymDTO.Price.Request)
}

extension ClimbingGymEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .gym, .gymTab, .skillDistribution, .mySkill: .get
        case .search, .searchFollow, .searchAll: .get
        case .service, .profileImage, .name, .backgroundImage: .patch
        case .gymInfo, .price: .post
        }
    }
    
    var path: String {
        switch self {
        case .gym(let gymID): "/api/gyms/\(gymID)"
        case .gymTab(let gymID): "/api/gyms/\(gymID)/tab"
        case .skillDistribution(let gymID): "/api/gyms/\(gymID)/skill-distribution"
        case .mySkill(let gymID): "/api/gyms/\(gymID)/my-skill"
        case .search: "/api/gyms/search"
        case .searchFollow: "/api/gyms/search/follow"
        case .searchAll: "/api/gyms/search/all"
        case .service: "/api/gyms/service"
        case .profileImage: "/api/gyms/profile-image"
        case .name: "/api/gyms/name"
        case .backgroundImage: "/api/gyms/background-image"
        case .gymInfo(let gymID): "/api/gyms/\(gymID)/info"
        case .price: "/api/gyms/price"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gym, .gymTab, .skillDistribution, .mySkill, .service, .profileImage, .name, .backgroundImage:
            return nil
        case .search(let param), .searchFollow(let param), .searchAll(let param):
            return [
                .init(name: "gymname", value: param.gymname),
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size))
            ]
        case .gymInfo, .price:
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .gym, .gymTab, .skillDistribution, .mySkill, .search, .searchFollow, .searchAll:
            return nil
        case .service(let serviceList):
            return ["serviceList": serviceList]
        case .profileImage(let imageURL):
            return ["imgUrl": imageURL]
        case .name(let name):
            return ["name": name]
        case .backgroundImage(let imageURL):
            return ["imgUrl": imageURL]
        case .gymInfo:
            return nil
        case .price(let param):
            return ["priceMapList": param.priceMapList]
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
