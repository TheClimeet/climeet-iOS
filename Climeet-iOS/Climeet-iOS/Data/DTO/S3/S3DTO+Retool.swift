//
//  S3DTO+Retool.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/16/24.
//

import Foundation

extension S3DTO.Retool {
    struct Request: Encodable {
        let file: Data
    }
    
    struct Response: Decodable {
        let imgURL: String?
    }
}
