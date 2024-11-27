//
//  shortsSharingView.swift
//  Climeet-iOS
//
//  Created by mac on 7/2/24.
//

import SwiftUI
import ComposableArchitecture

struct ShortsSharingView: View {
    @Bindable var store: StoreOf<ShortsPostingReducer>
    
    private struct Const {
        private static let figmaWidth: CGFloat = 375
        private static let figmaHeight: CGFloat = 889
        static let checkBottomPadding: CGFloat = 52 / figmaHeight
        static let leadingPadding: CGFloat = 120 / figmaWidth
        static let topPadding: CGFloat = 205 / figmaHeight
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Image(store.isSuccessed == true ? "check_successed" : "check_uploading")
                    .padding(.bottom, proxy.size.height * Const.checkBottomPadding)
                    .accessibility(identifier: "checkmarkImage")
                
                Text(store.isSuccessed == true ? "영상이 업로드 되었어요!" : "영상이 업로드 되고 있어요")
                    .font(.climeetFontParagraph1())
                    .foregroundStyle(.text0)
            }
            .padding(.leading, proxy.size.width * Const.leadingPadding)
            .padding(.top, proxy.size.height * Const.topPadding)
        }
        .background(.climeetBackground)
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.uploadShorts)
        }
    }
}

#Preview {
    ShortsSharingView(
        store: Store(initialState: ShortsPostingReducer.State(
            shorts: Shorts(
                video: Data([0x00, 0x01, 0x02, 0x03]),
                createShortsRequest:
                    ShortsRequest(climbingGymId: 1,
                                  routeId: 1,
                                  sectorId: 1,
                                  thumbnailImageUrl: "https://example.com/thumbnail.jpg",
                                  description: "Test description",
                                  shortsVisibility: "PUBLIC",
                                  soundEnabled: true))),
                     reducer: {
        ShortsPostingReducer()
    }))
}
