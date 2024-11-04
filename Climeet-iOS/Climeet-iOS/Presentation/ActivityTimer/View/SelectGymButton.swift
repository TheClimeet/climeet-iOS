//
//  SelectGymButton.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/1/24.
//

import SwiftUI

struct SelectGymButton: View {
    
    let selectedGym: Gym
    let buttonAction: () -> Void
    
    var body: some View {
        Button(action: {
            buttonAction()
        }, label: {
            HStack(alignment: .center, spacing: 5) {
                if !selectedGym.name.isEmpty {
                    Image("activitytimer_map")
                        .resizable()
                        .frame(width: 15, height: 15)
                    
                    Text(selectedGym.name)
                        .font(.climeetFontParagraph4())
                        .foregroundColor(Color.starNotFilled)
                } else {
                    Text("이용할 암장을 선택해주세요")
                        .font(.climeetFontParagraph4())
                        .foregroundColor(Color.starNotFilled)
                }
            }
        })
        .padding(.horizontal, 65)
        .frame(height: 35)
        .background(Color.text08)
        .cornerRadius(5.0)
    }
}
