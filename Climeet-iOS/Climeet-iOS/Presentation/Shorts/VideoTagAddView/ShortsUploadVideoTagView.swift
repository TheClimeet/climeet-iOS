//
//  ShortsUploadVideoTagView.swift
//  Climeet-iOS
//
//  Created by mac on 6/28/24.
//

import SwiftUI
import ComposableArchitecture

enum IconName: String {
    case mute = "shortsUpload_sounds"
    case acess = "shortsUpload_acessMode"
    case location = "shortsUpload_locationAdd"
    case route = "shortsUpload_routeAdd"
    case navigationArrow = "shortsUpload_navigation"
    
    var literal: String {
        return rawValue
    }
}

struct ShortsUploadVideoTagView: View {
    @Bindable var videoTagStore: StoreOf<AddVideoTagReducer>
    
    private struct Const {
        private static let figmaWidth: CGFloat = 375
        private static let figmaHeight: CGFloat = 889
        
        static let shareButtonLiteral = "공유"
        static let navigationTitleLiteral = "영상 업로드"
        static let plcaeHolder = "shortsVideoPlaceHolder"
        static let textFieldPlaceHolder = "문구를 입력하세요 ..."
        static let thumbnailWidthProportion: CGFloat = 189 / figmaWidth
        static let thumbnailHeightProportion: CGFloat = 355 / figmaHeight
        
        static let textFieldWidthProportion: CGFloat = 324 / figmaWidth
        static let textFieldHeightProportion: CGFloat = 64 / figmaHeight
        static let textFieldTopPadding: CGFloat = 25 / figmaHeight
        
        static let shortsOptionLeftPaddingProportion = 30 / figmaWidth
        static let shortsOptionTopPaddingProportion = 38 / figmaHeight
        
        static let imageCornerRadius: CGFloat = 30
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                HStack(alignment: .center){
                    Spacer()
                    selectedImageView(size: proxy.size,
                                      image: videoTagStore.selectedVideoThumbnail)
                    .clipShape(.rect(cornerRadius: Const.imageCornerRadius))
                    Spacer()
                }
                
                TextEditor(text: $videoTagStore.discription)
                    .customStyleEditor(placeholder: Const.textFieldPlaceHolder,
                                       userInput: $videoTagStore.discription,
                                       size: proxy.size,
                                       width: Const.textFieldWidthProportion,
                                       height: Const.textFieldHeightProportion)
                    .padding(.top, Const.textFieldTopPadding * proxy.size.width)
                
                climeetDividerView(screenSize: proxy.size,
                                   dividerWidth: 341)
                
                DetailTagView(videoTagStore: videoTagStore)
                
                    .frame(width: proxy.size.width * Const.textFieldWidthProportion)
                    .padding(.leading, proxy.size.width * Const.shortsOptionLeftPaddingProportion)
                    .padding(.trailing, proxy.size.width * Const.shortsOptionLeftPaddingProportion)
                    .padding(.top, proxy.size.height * Const.shortsOptionTopPaddingProportion)
            }
        }
        .onReadSize({ size in
            videoTagStore.send(.readSize(size))
        })
        .navigationBarTitle(Const.navigationTitleLiteral,
                            displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    videoTagStore.send(.startUploading)
                } label: {
                    navigationBarRightButtonText(Const.shareButtonLiteral)
                        .buttonStyle(PlainButtonStyle())
                        .accessibility(identifier: "다음")
                }
            }
        }
        .sheet(item: $videoTagStore.scope(
            state: \.destination?.changeAccessState,
            action: \.destination.changeAccessState),
               content: { store in
            VStack {
                Spacer(minLength: 20)
                UploadShortsAcessSelectView(store: store)
                    .presentationDetents([.height(videoTagStore.sheetHeight)])
            }
            .background(.climeetBackground)
        })
        
        .sheet(item: $videoTagStore.scope(
            state: \.destination?.searchGym,
            action: \.destination.searchGym),
               content: { store in
            SearchView(store: store)
        })
        
        .sheet(
            item: $videoTagStore.scope(
                state: \.destination?.addRoute,
                action: \.destination.addRoute
            ),
            content: { store in
                VStack {
                   // ClimeetNavigationBar(gymName: store.gymName, store: store)
                    RouteSelectionView(store: store)
                }
                .background(.climeetBackground)
                .presentationDetents([.height(videoTagStore.sheetHeight)])
                .padding([.leading, .trailing], 28)
            }
        )
        
        .background(.climeetBackground)
    }
}

struct DetailTagView: View {
    @Bindable var videoTagStore: StoreOf<AddVideoTagReducer>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            shortsUploadOptionView(iconImageName: IconName.mute.literal, title: "소리 음소거") {
                Toggle(isOn: $videoTagStore.isMuted) { }
                    .tint(.climeetMain)
                    .toggleStyle(.switch)
            }
            
            shortsUploadOptionView(iconImageName: IconName.acess.literal, title: "공개 대상") {
                Button {
                    videoTagStore.send(.acessStateChangedButtonTapped)
                } label: {
                    customLabel(text: videoTagStore.acessState.literal)
                }
            }
            
            shortsUploadOptionView(iconImageName: IconName.location.literal, title: "클라이밍 암장 추가") {
                Button {
                    videoTagStore.send(.addClimbingGym)
                } label: {
                    customLabel(text: videoTagStore.gymName)
                }
            }
            
            shortsUploadOptionView(iconImageName: IconName.route.literal, title: "루트 추가") {
                Button {
                    videoTagStore.send(.addGymRoutes)
                } label: {
                    customLabel(text: "루트추가")
                }
            }
        }
    }
    
    private func customLabel(text: String?) -> some View {
        let text = text ?? ""
        return HStack {
            Text(text)
                .font(.climeetFontParagraph2())
                .foregroundStyle(.text06)
            Image(IconName.navigationArrow.literal)
        }
    }
}

extension ShortsUploadVideoTagView {
    private func selectedImageView(size: CGSize, image: UIImage?) -> some View {
        var finalImage: Image
        
        if let image = image {
            let selected = Image(uiImage: image)
            finalImage = selected
        } else {
            let dafaultImage = Image(Const.plcaeHolder)
            finalImage = dafaultImage
        }
        
        return finalImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width * Const.thumbnailWidthProportion,
                   height: size.height * Const.thumbnailHeightProportion)
            .clipped()
    }
}

struct ClimeetNavigationBar: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var gymName: String
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.leading, 16)
                }
                
                Spacer()
            }
            
            Text(gymName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.text08)
        }
        .frame(height: 44)
        .background(Color.black)
    }
}

#Preview {
    ShortsUploadVideoTagView(
        videoTagStore: Store(
            initialState: AddVideoTagReducer.State(
                selectedVideoThumbnail: UIImage(),
                selectedVideoURL: URL(string: "")!
            )
        ) {
            AddVideoTagReducer()
        })
}
