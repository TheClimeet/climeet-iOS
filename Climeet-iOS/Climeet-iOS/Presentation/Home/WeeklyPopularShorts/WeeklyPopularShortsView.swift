//
//  WeeklyPopularShortsView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct WeeklyPopularShortsView: View {
    @Bindable var store: StoreOf<WeeklyPopularShortsReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            shorts
        }
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
    }
    
    private var header: some View {
        HStack {
            Text("이번주 인기 숏츠")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
            ShowAllButton()
        }
    }
    
    private var shorts: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(store.shortsItems) { item in
                    KFImage(URL(string: item.thumbnailImageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 96, height: 160)
                        .clipped()
                        .cornerRadius(5)
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

#Preview {
    let store = Store(initialState: WeeklyPopularShortsReducer.State()) {
        WeeklyPopularShortsReducer()
    }
    WeeklyPopularShortsView(store: store)
        .background(Color.climeetBackground)
}
