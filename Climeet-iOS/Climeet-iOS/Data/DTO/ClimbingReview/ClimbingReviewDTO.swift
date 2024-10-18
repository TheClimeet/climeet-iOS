//
//  ClimbingReviewDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/7/24.
//

import Foundation

enum ClimbingReviewDTO {
    enum GymReviews {}
    
    struct Request: Encodable {
        let gymID: Int
        let content: String
        let rating: Int
    }
}
