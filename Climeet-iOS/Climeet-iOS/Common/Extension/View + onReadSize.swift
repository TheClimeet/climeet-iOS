//
//  View + onReadSize.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/12/24.
//

import SwiftUI

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
    @ViewBuilder
    func onReadSize(
        _ perform: @escaping (CGSize) -> Void)
    -> some View {
        self.customBackground {
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }
    
    @ViewBuilder
    private func customBackground<V: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V)
    -> some View
    {
        self.background(alignment: alignment, content: content)
    }
}
