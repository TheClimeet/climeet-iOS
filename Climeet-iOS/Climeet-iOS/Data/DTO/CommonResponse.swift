//
//  CommonResponse.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

struct CommonResponseElement: Decodable {
    let code, message: String?
    let isSuccess: Bool?
}

typealias CommonResponse = [CommonResponseElement]
