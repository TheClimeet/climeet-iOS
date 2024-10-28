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
                    HomeHeaderView()
                        .padding(.vertical, 30)
                    BannerView()
                        .padding(.bottom, 48)
                    HomeGymShortcutView()
                        .padding(.bottom, 48)
                    BestClimberView()
                        .padding(.bottom, 48)
                    WeeklyPopularShortsView()
                        .padding(.bottom, 48)
                    WeeklyPopularGymView()
                        .padding(.bottom, 48)
                    WeeklyPopularRoutView()
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
