//
//  HomeGymShortcutView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct HomeGymShortcutView: View {
    @Bindable var store: StoreOf<HomeGymShortcutReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.leading, 16)
                .padding(.bottom, 20)
            scrollView
        }
        .onFirstAppear {
            store.send(.onFirstAppear)
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
                ForEach(store.homeGymInfo) { homeGymInfo in
                    HomeGymIcon(
                        profileURL: homeGymInfo.gymProfileURL,
                        gymName: homeGymInfo.gymName,
                        followerCount: homeGymInfo.followerCount
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
    let profileURL: String
    let gymName: String
    let followerCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: profileURL))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.bottom, 11)
            Text(gymName)
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.starNotFilled)
                .padding(.bottom, 5)
            Text("팔로워 \(followerCount)")
                .font(.custom("Pretendard-Regular", size: 10))
                .foregroundStyle(Color.text05)
        }
    }
}

#Preview {
    let store = StoreOf<HomeGymShortcutReducer>(initialState: HomeGymShortcutReducer.State()) {
        HomeGymShortcutReducer()
    }
    ZStack {
        Color.climeetBackground
        HomeGymShortcutView(store: store)
    }
}
