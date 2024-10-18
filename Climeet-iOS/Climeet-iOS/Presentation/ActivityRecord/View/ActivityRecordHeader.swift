//
//  ActivityHeader.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/13/24.
//

import SwiftUI
import DesignSystem

struct ActivityRecordHeader: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.climeetFontTitle4())
                .foregroundColor(.levelWhite)
            Spacer()
        }
    }
}
