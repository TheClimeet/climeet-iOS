//
//  CommonViewBuilder.swift
//  Climeet-iOS
//
//  Created by mac on 7/3/24.
//

import Foundation
import SwiftUI

@ViewBuilder
func navigationBarRightButtonText(_ text: String) -> some View {
    Text(text)
    .foregroundColor(.climeetMain)
    .font(.climeetFontParagraph3())
}
