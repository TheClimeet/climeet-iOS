//
//  ActivityTimer.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/1/24.
//

import SwiftUI

struct ActivityTimerText: View {
    
    let elapsedTime: String
    
    var body: some View {
        
        VStack(spacing: 3) {
            
            Text(elapsedTime)
                .frame(maxWidth: .infinity)
                .frame(height: 95)
                .font(Font.custom("Pretendard-Bold", size: 80))
                .foregroundColor(Color.climeetMain)
                .monospacedDigit()
            
            Text("시간")
                .font(.climeetFontTitle3())
                .foregroundColor(Color.levelWhite)
            
        }
    }
}
