//
//  ActivityTimerView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/26/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityTimerView: View {
    
    var gym: Gym
    var handleClimbingGymSelectionTapped: () -> Void
    
    var body: some View {
        
        VStack(spacing: 40) {
            ChallengeStats()
            
            Button(action: {
                handleClimbingGymSelectionTapped()
            }, label: {
                HStack(alignment: .center, spacing: 5) {
                    if !gym.name.isEmpty {
                        Image("activitytimer_map")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text(gym.name)
                            .font(.climeetFontParagraph4())
                            .foregroundColor(Color.starNotFilled)
                    } else {
                        Text("암장을 선택해주세요")
                            .font(.climeetFontParagraph4())
                            .foregroundColor(Color.starNotFilled)
                    }
                }
            })
            .padding(.horizontal, 20)
            .frame(height: 35)
            .background(Color.text08)
            .cornerRadius(5.0)
            
            ExpandableControlButton()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(25)
        .background(Color.text09)
    }
}

#Preview {
    ActivityTimerView(
        gym: Gym(),
        handleClimbingGymSelectionTapped: {
            
        })
}
