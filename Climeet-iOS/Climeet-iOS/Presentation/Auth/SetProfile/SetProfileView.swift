//
//  SetProfileView.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/23/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import AuthenticationServices
import PhotosUI

struct SetProfileView: View {
    @Bindable var store: StoreOf<SetProfileReducer>
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 105) {
            headerSection()
            circleProfileImage()
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            nextButton()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
        .backTopBar(title: "프로필 설정", backAction: { store.send(.pop) }, underLine: true)
        .task {
            Log.debug("init SetNickname View")
        }
    }
}

extension SetProfileView {
    @ViewBuilder
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("클밋에서 사용하실\n프로필 사진을 설정해주세요!")
                .font(.climeetFontTitle2())
                .foregroundStyle(Color.levelWhite)
                .multilineTextAlignment(.leading)
            
            Text("설정에서 언제든지 바꿀 수 있어요.")
                .font(.climeetFontParagraph5())
                .foregroundStyle(Color.levelWhite)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 60)
    }
    
    @ViewBuilder
    private func circleProfileImage() -> some View {
        VStack(alignment: .center, spacing: 30) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                if let data = selectedImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 191, height: 191)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(hex: "#D9D9D9") ?? .gray)
                        .frame(width: 191, height: 191)
                }
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            Text(store.nickname)
                .font(.climeetFontTitle3())
                .foregroundStyle(Color.levelWhite)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func nextButton() -> some View {
        Button {
            store.send(.nextBtnTap)
        } label: {
            Circle()
                .frame(width: 54, height: 54)
                .foregroundStyle(Color.climeetMain)
                .overlay {
                    Image(.homeArrowRight)
                        .resizable()
                        .renderingMode(.template)
                        .tint(Color.levelBlack)
                        .frame(width: 14, height: 14)
                }
        }
    }
}

#Preview {
    SetProfileView(store: Store(
        initialState: .init(accessToken: "", nickname: "켈리0921"),
        reducer: {
            SetProfileReducer()
        }))
}
