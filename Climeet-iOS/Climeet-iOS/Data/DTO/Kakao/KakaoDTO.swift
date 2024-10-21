//
//  KakaoDTO.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/21/24.
//

import Foundation

enum KakaoDTO {
    struct Response: Equatable {
        var id: Int64?
        var imageURL: String?
        var name: String?
        var nickname: String?
        var email: String?
        var birthDay: String?
        var gender: String?
        var phoneNumber: String?
        var ageRange: String?
    }
}
