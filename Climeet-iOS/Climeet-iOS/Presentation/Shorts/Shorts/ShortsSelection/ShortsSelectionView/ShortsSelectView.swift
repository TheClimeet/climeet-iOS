//
//  ShortsUploadVideoSelectView.swift
//  Climeet-iOS
//
//  Created by mac on 5/31/24.
//

import SwiftUI
import ComposableArchitecture
import _PhotosUI_SwiftUI

struct ShortsSelectView: View {
    @Bindable var store: StoreOf<ShortsSelectReducer>
    @State private var selectedItem: PhotosPickerItem?
    
    private let thumbnailWidthProportion: CGFloat = 189 / 375
    private let thumbnailHeightProportion: CGFloat = 416 / 894
    
    private enum Const {
        static let recents = "최근항목"
        static let next = "다음"
        static let recentsIcon = "recentsExpandIcon"
        static let plcaeHolder = "shortsVideoPlaceHolder"
        static let cancelIcon = "uploadCancelIcon"
    }
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    selectedImageView(store.shortsThumbnail,
                                       size: proxy.size)

                    PhotosPicker(selection: $selectedItem,
                                 matching: .videos,
                                 preferredItemEncoding: .current) {
                        HStack {
                            Text(Const.recents)
                                .font(.climeetFontParagraph2())
                                .foregroundColor(.white)
                                .padding(.leading)
                            Image(Const.recentsIcon)
                            Spacer()
                        }
                    }
                    .onChange(of: selectedItem) { oldValue, newValue in
                        guard oldValue != newValue else {
                            return
                        }
                        
                        store.send(.changedPhotoPickerItem(newValue))
                    }
                    .padding(.vertical, 10)
                    .background(.climeetBackground)
                    .frame(width: proxy.size.width,
                           height: 20,
                           alignment: .leading)
                    
                    CustomGallery(store.scope(
                        state: \.gallery,
                        action: \.gallery
                    ))
                }
                .background(.shorsUploadPartialBackground)
            }
            .navigationBarTitle("새 게시물", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { store.send(.tapNextButton) }) {
                        Text(Const.next)
                            .foregroundStyle(.climeetMain)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(Const.cancelIcon)
                    }
                }
            }
            .onAppear {
                store.send(.gallery(.requestPhotoAuthorization))
            }
        } destination: { store in
            switch store.case {
            case .videoTagView(let store):
                ShortsUploadVideoTagView(videoTagStore: store)
            case .uploadView(let store):
                ShortsSharingView(store: store)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func selectedImageView(_ uiimage: UIImage?,
                                   size: CGSize) -> some View {
        var image: Image
        if let uiimage = uiimage {
            image = Image(uiImage: uiimage)
        } else {
            image = Image(Const.plcaeHolder)
        }
        
        return image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width * thumbnailWidthProportion,
                   height: size.height * thumbnailHeightProportion)
            .clipped()
    }
}
