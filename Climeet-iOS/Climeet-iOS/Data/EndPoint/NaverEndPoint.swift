//
//  NaverEndPoint.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/22/24.
//

import Foundation
import NetworkKit
import Alamofire

enum NaverEndPoint {
    case login(authorization: String)
}

extension NaverEndPoint: Endpoint {
    var baseURL: String { "https://openapi.naver.com" }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login(let authorization): .get
        }
    }
    
    var path: String { "/v1/nid/me" }
    
    var queryItems: [URLQueryItem]? { nil }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .login(let authorization): [.init(name: "Authorization", value: authorization)]
        }
    }
    
    var body: Alamofire.Parameters? { nil }
    
    var token: String? { nil }
    
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
