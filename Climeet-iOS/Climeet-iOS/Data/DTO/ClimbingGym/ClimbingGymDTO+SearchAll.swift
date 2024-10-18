//
//  ClimbingGymDTO+SearchAll.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

extension ClimbingGymDTO.SearchAll {
    struct Response: Decodable {
        let page: Int?
        let hasNext: Bool?
        let result: [Result]?
    }

    // MARK: - Result
    struct Result: Decodable {
        let id: Int?
        let name: String?
        let managerID: Int?

        enum CodingKeys: String, CodingKey {
            case id, name
            case managerID = "managerId"
        }
    }
}
