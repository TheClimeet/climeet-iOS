//
//  ShortsDTO+MyShorts.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.MyShorts {
    struct Request: Encodable {
        let shortsVisibility: ShortsVisibility
        let page: Int
        let size: Int
    }
}
