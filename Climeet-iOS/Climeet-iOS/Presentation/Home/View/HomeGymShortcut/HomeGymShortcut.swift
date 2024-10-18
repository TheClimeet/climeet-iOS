//
//  HomeGymShortcut.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct HomeGymShortcut: View {
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.leading, 16)
                .padding(.bottom, 20)
            
            scrollView
        }
    }
    
    private var header: some View {
        HStack {
            Text("홈짐 바로가기")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
        }
    }
    
    private var scrollView: some View {
        ScrollView(.horizontal) {
            let width = UIScreen.main.bounds.width / 4
            HStack(spacing: 0) {
                ForEach(0..<6, id: \.self) { _ in
                    HomeGymIcon(
                        resource: .activitytabEllipse,
                        gymName: "더클라임 연남",
                        followerCount: 2555
                    )
                    .frame(width: width)
                }
            }
        }
        .scrollIndicators(.never)
    }
}

fileprivate
struct HomeGymIcon: View {
    let resource: ImageResource
    let gymName: String
    let followerCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Image(resource)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.bottom, 11)
            Text(gymName)
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.starNotFilled)
                .padding(.bottom, 5)
            Text("팔로워 \(followerCount)")
                .font(.climeetFontCaptionText2())
                .foregroundStyle(Color.text05)
        }
    }
}

#Preview {
    ZStack {
        Color.climeetBackground
        HomeGymShortcut()
    }
}
