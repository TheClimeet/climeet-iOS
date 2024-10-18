//
//  ShortsUploadViewBuilder.swift
//  Climeet-iOS
//
//  Created by mac on 7/4/24.
//

import Foundation
import SwiftUI

@ViewBuilder
func climeetDividerView(screenSize: CGSize, dividerWidth: CGFloat,
                        figmaWidth: CGFloat = 375,
                        height: CGFloat = 0.2, alignmet: Alignment = .center) -> some View {
    Rectangle()
        .frame(width: screenSize.width * (dividerWidth / figmaWidth),
               height: 0.2, alignment: .center)
        .foregroundStyle(.text07)
}

func shortsUploadOptionView<V: View>(iconImageName: String,
                                     title: String,
                                     @ViewBuilder optionalView: () -> V?) -> some View {
    HStack() {
        Image(iconImageName)
        Text(title)
            .font(.climeetFontParagraph2())
            .foregroundStyle(.text0)
        Spacer()
        if let view = optionalView() {
            view
        } else {
            EmptyView()
        }
    }
}
