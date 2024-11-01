//
//  HttpHeaders.swift
//  NetworkKit
//
//  Created by KOVI on 11/1/24.
//

extension HTTPHeaders {
    /// `Content-Type: application/json` 헤더를 포함하는 HTTPHeaders 인스턴스 반환
    public static var applicationJSON: HTTPHeaders? {
        return [.contentType("application/json")]
    }
}
