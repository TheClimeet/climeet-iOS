//
//  ClimbingRecordsDTO+UsersList.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

extension ClimbingRecordsDTO.UsersList {
    struct ResponseElement: Decodable {
        let gymID: Int?
        let gymName: String?

        enum CodingKeys: String, CodingKey {
            case gymID = "gymId"
            case gymName
        }
    }

    typealias Response = [ResponseElement]
}
