//
//  ShortsDeckView.swift
//  Climeet-iOS
//
//  Created by mac on 8/29/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct ShortsDeckView: View {
    @Bindable var store: StoreOf<ShortsDeckReducer>
    
    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                ShortsDeckAddFollowView()
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.shortsDeckItems, id: \.self) { item in
                        Button(action: {
                            store.send(.tapShortsItem)
                        }, label: {
                            VStack(alignment: .leading, spacing: 0) {
                                ShortsItemView(item, screenSize: store.screenSize)
                            }
                            .background(.climeetBackground)
                            .onAppear {
                                if item == store.shortsDeckItems.last {
                                    store.send(.startFetching)
                                }
                            }
                        })
                    }
                    .padding(.horizontal, 0)
                }
                
                switch store.fetchingStatus {
                case .isLoading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .foregroundStyle(.climeetMain)
                default:
                    EmptyView()
                }
            }
            .background(.climeetBackground)
            .onAppear {
                if store.shortsDeckItems.count == .zero {
                    store.send(.startFetching)
                }
            }
        } destination: { store in
            switch store.case {
            case .shortsDeckItemScrollView(let store):
                ShortsDeckItemScrollView(store: store)
            }
        }
    }
    
    private func ShortsItemView(_ item: ShortsDeckItem, screenSize: CGSize?) -> some View {
        let defaultScreenWidth: CGFloat = 400
        let defaultScreenHeight: CGFloat = 600
        let width = (screenSize?.width ?? defaultScreenWidth) / 2
        let height = (screenSize?.height ?? defaultScreenHeight) / 3
        let circleWidth: CGFloat = 15
        let circleHeight: CGFloat = 15
        
        return ZStack(alignment: .topLeading) {
            if let url = URL(string: item.thumbnailImageUrl) {
                KFImage(url)
                    .resizable()
                    .frame(width: width, height: height,
                           alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: width, height: height,
                           alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            
            GymInfoView(gymName: item.gymName, gymDifficultyColor: item.gymDifficultyColor)
            DifficultyView(colorHexadecimal: item.gymDifficultyColor,
                           difficulty: item.gymDifficultyName)
            .position(x: width - (circleWidth * 2), y: height - CGFloat((circleHeight * 2)))
        }
    }
    
    private func GymInfoView(gymName: String,
                             gymDifficultyColor: String) -> some View {
        let gymDifficultyColor = convertHexadecimal(gymDifficultyColor)
        return HStack(spacing: 4) {
            Text(gymName)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.leading, 7)
            
            Circle()
                .fill(gymDifficultyColor)
                .frame(width: 14, height: 14)
                .padding(.trailing, 7)
        }
        .background(Color.black.opacity(0.6))
        .cornerRadius(13)
        .padding(.horizontal, 7)
        .padding(.vertical, 10)
    }
    
    private func DifficultyView(colorHexadecimal: String,
                                difficulty: String) -> some View {
        let hexadecimal = convertHexadecimal(colorHexadecimal)
        return ZStack {
            Circle()
                .stroke(hexadecimal, lineWidth: 1.5)
                .frame(width: 30, height: 30)
            Text(difficulty)
                .foregroundColor(hexadecimal)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)
        }
    }
    
    private func convertHexadecimal(_ from: String) -> Color {
        return Color(hex: from) ?? .climeetMain
    }
}

#Preview {
    ShortsDeckView(store: Store(initialState: ShortsDeckReducer.State()) {
        ShortsDeckReducer()
    })
}
