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
    
    //MARK: ViewModel for UICollectioVIewController
    @ObservedObject private var viewModel: CustomGalleryViewModel
    @Bindable var store: StoreOf<ShortsSelectReducer>
    @State private var selectedVideo: PhotosPickerItem?
    
    private enum Const {
        static let recents = "최근항목"
        static let next = "다음"
        static let recentsIcon = "recentsExpandIcon"
        static let plcaeHolder = "shortsVideoPlaceHolder"
        static let cancelIcon = "uploadCancelIcon"
    }
    
    private let thumbnailWidthProportion: CGFloat = 189 / 375
    private let thumbnailHeightProportion: CGFloat = 416 / 894
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    init(viewModel: CustomGalleryViewModel = CustomGalleryViewModel(),
         store: StoreOf<ShortsSelectReducer>) {
        self.viewModel = viewModel
        self.store = store
    }
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    selectedImageView(self.viewModel.selectedVideoThumbnail,
                                      size: proxy.size)
                    HStack {
                        moveToUserGalleryButton()
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(.climeetBackground)
                    .frame(width: proxy.size.width,
                           height: 20,
                           alignment: .leading)
                    CustomGallery(viewModel)
                }
                .background(.shorsUploadPartialBackground)
            }
            .navigationBarTitle("새 게시물",
                                displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.tapNextButton(viewModel.selectedVideoThumbnail,
                                                  viewModel.selectedVideoURL))
                    } label: {
                        Text(Const.next)
                            .foregroundStyle(.climeetMain)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: 이전 화면으로 돌아가는 기능 추가
                    } label: {
                        Image(Const.cancelIcon)
                    }
                }
            }
            
            //TODO: Shorts 버튼 누르면 권한 요청하거나 온보딩 화면에서 요청하도록 추후 위치 옮기기
            .onAppear {
                viewModel.requestPhotoAuthrization()
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
}

extension ShortsSelectView {
    private func selectedImageView(_ uiImage: UIImage?,
                                   size: CGSize) -> some View {
        var image: Image
        
        if let uiImage = uiImage {
            image = Image(uiImage: uiImage)
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
    
    private func moveToUserGalleryButton() -> some View {
        return PhotosPicker(selection: $selectedVideo,
                     matching: .videos,
                     preferredItemEncoding: .current) {
            HStack {
                Text(Const.recents)
                    .font(.climeetFontParagraph2())
                    .foregroundColor(.white)
                    .padding(.leading)
                Image(Const.recentsIcon)
            }
        }
    }
}

#Preview {
    ShortsSelectView(store: Store(initialState: ShortsSelectReducer.State()) {
        ShortsSelectReducer()
    })
}
