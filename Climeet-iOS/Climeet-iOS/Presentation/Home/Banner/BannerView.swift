//
//  BannerView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct BannerView: View {
    @Bindable var store: StoreOf<BannerReducer>
    
    @State var selection: Int = 0
    let screenWidth = UIWindow().screen.bounds.width
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(store.bannerInfos.indices, id: \.self) { index in
                KFImage(URL(string: store.bannerInfos[index].bannerImageURL))
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenWidth / 2.08)
                    .clipped()
                    .tag(index)
            }
        }
        .frame(width: screenWidth, height: screenWidth / 2.08)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.bouncy, value: selection)
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(String(format: "%02d / %02d", selection + 1, store.bannerInfos.count))                        .font(.climeetFontCaptionText1())
                        .foregroundStyle(.white)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.text09.opacity(0.4))
                        }
                        .padding(.trailing, 11)
                        .padding(.bottom, 11)
                }
            }
        }
    }
}

#Preview {
    let store = StoreOf<BannerReducer>(initialState: BannerReducer.State()) {
        BannerReducer()
    }
    BannerView(store: store)
}
