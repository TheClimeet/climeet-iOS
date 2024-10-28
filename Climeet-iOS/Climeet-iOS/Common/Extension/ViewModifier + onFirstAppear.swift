//
//  ViewModifier + onFirstAppear.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/28/24.
//

import SwiftUI

public struct FirstAppearModifer: ViewModifier {

    private let action: () async -> Void
    @State private var hasAppeared = false
    
    public init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}

extension View {
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppearModifer(action))
    }
}
