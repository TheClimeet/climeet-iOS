//
//  ShortsDTO+Uploader.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/11/24.
//

import Foundation

extension ShortsDTO.Uploader {
    struct Request: Encodable {
        let uploaderID: Int
        let page: Int
        let size: Int
        let sortType: SortType
    }
}
