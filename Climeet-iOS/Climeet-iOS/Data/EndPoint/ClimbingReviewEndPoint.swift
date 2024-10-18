import Foundation
import NetworkKit
import Alamofire

enum ClimbingReviewEndPoint {
    case gymReviews(ClimbingReviewDTO.GymReviews.Request)
    case update(ClimbingReviewDTO.Request)
    case create(ClimbingReviewDTO.Request)
}

extension ClimbingReviewEndPoint: Endpoint {
    
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .gymReviews: .get
        case .update: .patch
        case .create: .post
        }
    }
    
    var path: String {
        switch self {
        case .gymReviews(let param): "/api/gyms/\(param.gymID)/review"
        case .update(let param): "/api/gyms/\(param.gymID)/review"
        case .create(let param): "/api/gyms/\(param.gymID)/review"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gymReviews(let param):
            return [
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size))
            ]
        case .update, .create:
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .gymReviews:
            return nil
        case .update(let param), .create(let param):
            return [
                "content": param.content,
                "rating": param.rating
            ]
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
