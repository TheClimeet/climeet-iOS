//
//  ShortsUploadVideoSelectView.swift
//  Climeet-iOS
//
//  Created by mac on 5/31/24.
//

import SwiftUI
import ComposableArchitecture

struct ShortsSelectView: View {
    
    //MARK: ViewModel for UICollectioVIewController
    @ObservedObject private var viewModel = CustomGalleryViewModel()
    @Bindable var store: StoreOf<ShortsSelectReducer>
    
    private enum Const {
        static let recents = "최근항목"
        static let next = "다음"
        static let recentsIcon = "recentsExpandIcon"
        static let plcaeHolder = "shortsVideoPlaceHolder"
        static let cancelIcon = "uploadCancelIcon"
    }
    
    private let service = MyPhotoAuthService()
    private let thumbnailWidthProportion: CGFloat = 189 / 375
    private let thumbnailHeightProportion: CGFloat = 416 / 894
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    selectedImageView(viewModel: self.viewModel, size: proxy.size)
                    HStack {
                        moveToUserGalleryButton(viewModel: self.viewModel)
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
                        store.send(.tapNextButton(viewModel.selectedVideoThumbnail, viewModel.bringSelectedVideoURL()))
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
            .onAppear(perform: {
                service.requestAuthorization { result in
                    switch result {
                    case .success():
                        print("success")
                    case .failure(let errror):
                        print(errror)
                    }
                }
            })
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
    private func selectedImageView(viewModel: CustomGalleryViewModel, size: CGSize) -> some View {
        var image: Image
        
        if let uiImage = viewModel.selectedVideoThumbnail {
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
    
    private func moveToUserGalleryButton(viewModel: CustomGalleryViewModel) -> some View {
        return NavigationLink(destination: CustomGallery(viewModel)) {
            HStack {
                Text(Const.recents)
                    .font(.climeetFontParagraph2())
                    .foregroundColor(.white)
                    .padding(.leading)
                Image(Const.recentsIcon)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ShortsSelectView(store: Store(initialState: ShortsSelectReducer.State()) {
        ShortsSelectReducer()
    })
}
