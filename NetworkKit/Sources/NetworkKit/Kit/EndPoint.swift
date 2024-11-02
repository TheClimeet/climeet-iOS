import Foundation
import Alamofire

public protocol Endpoint: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: HTTPHeaders? { get }
    var body: Parameters? { get }
    var token: String? { get }
}

extension Endpoint {
    
    private var defaultHeaders: HTTPHeaders {
        var headers: HTTPHeaders = []
        
        if let token = token {
            headers.add(.authorization(bearerToken: token))
        }
        
        return headers
    }
    
    public func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
            throw APIError(errorCode: "EndPoint.asURLRequest", message: "Invalid baseURL or path")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryItems = queryItems {
            components?.queryItems = queryItems.map { URLQueryItem(name: $0.name, value: $0.value) }
        }
        
        guard let finalURL = components?.url else {
            throw APIError(errorCode: "EndPoint.asURLRequest", message: "URL Component 조합 실패")
        }
        
        var request = URLRequest(url: finalURL)
        request.method = method
        
        // 헤더값 설정
        var finalHeader = defaultHeaders
        if let customHeaders = headers {
            customHeaders.forEach { finalHeader.update($0) }
        }
        
        request.headers = finalHeader
        
        // 파라미터 설정
        if let parameters = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
}
