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

//MARK: -  Shorts PhotoPicker
extension View {
    func asImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.view.addSubview(controller.view)
        }
        
        let size = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = UIColor.systemBackground
        controller.view.sizeToFit()
        
        let image = UIImage(fromView: controller.view)
        controller.view.removeFromSuperview()
        return image
    }
}
