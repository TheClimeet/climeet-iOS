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
                if store.shortsItems.isEmpty {
                    ForEach(0..<8, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.gray)
                            .frame(width: 96, height: 160)
                    }
                } else {
                    ForEach(store.shortsItems) { item in
                        ShortsThumbnailView(imageURL: item.thumbnailImageURL)
                            .overlay {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        DifficultyMark(difficulty: item.difficulty)
                                    }
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 10)
                                }
                            }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

fileprivate struct ShortsThumbnailView: View {
    let imageURL: String
    
    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder({
                Color.gray
            })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 96, height: 160)
            .clipped()
            .cornerRadius(5)
    }
}

fileprivate struct DifficultyMark: View {
    let difficulty: GymDifficulty
    
    var body: some View {
        Text("V\(difficulty.level)")
            .foregroundStyle(Color(hex: difficulty.color) ?? .gray)
            .font(.climeetFontParagraph5())
            .frame(width: 30, height: 30)
            .overlay {
                Circle()
                    .stroke(
                        Color(hex: difficulty.color) ?? .gray,
                        style: StrokeStyle(lineWidth: 1.5)
                    )
                    .frame(width: 30, height: 30)
            }
    }
}

#Preview {
    let store = Store(initialState: WeeklyPopularShortsReducer.State()) {
        WeeklyPopularShortsReducer()
    }
    WeeklyPopularShortsView(store: store)
        .background(Color.climeetBackground)
}
