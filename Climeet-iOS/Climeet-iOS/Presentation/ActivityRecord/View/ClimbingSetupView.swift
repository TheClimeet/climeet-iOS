//
//  ClimbingSetupView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/13/24.
//

import SwiftUI
import DesignSystem

struct ClimbingSetupView: View {
    var placeholderText: String
    var gym: Gym?
    
    var body: some View {
        HStack {
            Text(gym?.name ?? placeholderText)
                .foregroundColor(gym == nil ? .starNotfilledEyes : .levelWhite)
                .padding(.leading, 18)
            
            Spacer()
            
            Image(uiImage: UIImage(named: "activity_arrow_right") ?? UIImage())
                .padding(.trailing, 20)
        }
    }
}
