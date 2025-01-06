//
//  ValidateService.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/19/24.
//

import Foundation
import Dependencies

struct ValidateService {
    /// 닉네임 유효성 검사
    var isValidNickname: @Sendable (String) -> Bool
}

extension ValidateService: DependencyKey {
    static var liveValue = ValidateService(
        isValidNickname: { nickname in
            /// 한글, 숫자
            /// 글자수 2-8
            /// 앞 뒤 공백 불가
            let nameRegEx = "[가-힣0-9]{2,8}"
            let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
            return namePred.evaluate(with: nickname) && !nickname.hasPrefix(" ") && !nickname.hasSuffix(" ")
        }
    )
}

extension DependencyValues {
    var validateService: ValidateService {
        get { self[ValidateService.self] }
        set { self[ValidateService.self] = newValue }
    }
}
