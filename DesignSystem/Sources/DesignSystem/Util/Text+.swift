import SwiftUI

extension Text {
    // 기존 Text 생성자의 클로저에서 AttributedString을 구현 해 줄수 있음
    public init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}
