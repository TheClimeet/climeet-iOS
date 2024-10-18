//
//  RouteRecordsDTO+Update.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import Foundation

extension RouteRecordsDTO.Update {
    struct Request: Encodable {
        let id: Int
        let attemptCount: Int
        let isComplete: Bool
    }
}
