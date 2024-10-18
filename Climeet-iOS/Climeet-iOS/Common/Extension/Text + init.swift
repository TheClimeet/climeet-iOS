//
//  Text + init.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/4/24.
//

import SwiftUI

extension Text {
    // 기존 Text 생성자의 클로저에서 AttributedString을 구현 해 줄수 있음
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}
