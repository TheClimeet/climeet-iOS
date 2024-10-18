//
//  HomeView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.climeetBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HomeHeader()
                        .padding(.vertical, 30)
                    Banner()
                        .padding(.bottom, 48)
                    HomeGymShortcut()
                        .padding(.bottom, 48)
                    BestClimber()
                        .padding(.bottom, 48)
                    WeeklyPopularShorts()
                        .padding(.bottom, 48)
                    WeeklyPopularGym()
                        .padding(.bottom, 48)
                    WeeklyPopularRout()
                        .padding(.bottom, 120)
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    HomeView()
}
