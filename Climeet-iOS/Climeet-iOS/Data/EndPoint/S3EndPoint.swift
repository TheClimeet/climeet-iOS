import Foundation
import NetworkKit
import Alamofire

enum S3EndPoint {
    case retoolUpload(data: Data)
    case upload(data: Data)
}

extension S3EndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .retoolUpload: .post
        case .upload: .post
        }
    }
    
    var path: String {
        switch self {
        case .retoolUpload: "/api/retool/file"
        case .upload: "/api/file"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .retoolUpload: nil
        case .upload: nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token), .contentType("multipart/form-data")]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case let .retoolUpload(data: data):
            ["data": data]
        case let .upload(data: data):
            ["data": data]
        }
    }
    
    var token: String? { UserDefaults.standard.value(forKey: "token") as? String }
    
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
