//
//  AceessSelectView.swift
//  Climeet-iOS
//
//  Created by mac on 7/4/24.
//

import SwiftUI
import ComposableArchitecture

struct UploadShortsAcessSelectView: View {
    @Bindable var store: StoreOf<AccessStateReducer>
    
    private enum IconName: String {
        case world = "shortsUpload_acessMode"
        case followers = "shortsUpload_people_alt"
        case onlyMe = "shortsUpload_lock"
        
        var literal: String {
            return rawValue
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 10) {
                Text("공개 대상")
                //TODO: 피그마 폰트 확인 시 적용하기
                    .foregroundStyle(.text01)
                
                climeetDividerView(screenSize: proxy.size,
                                   dividerWidth: 375)
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("누구와 게시물을 공유하고 싶으신가요?")
                        .foregroundStyle(.text0)
                        .font(.climeetFontParagraph1())
                        .padding(.top, 20)
                    
                    shortsUploadOptionView(iconImageName: IconName.world.literal,
                                           title: "전체 공개") {
                        CutomAccessSelectToggle(index: 0, selectedToggle: $store.selectedToggleIndex)
                    }
                    
                    shortsUploadOptionView(iconImageName: IconName.followers.literal,
                                           title: "팔로워만 공개") {
                        CutomAccessSelectToggle(index: 1, selectedToggle: $store.selectedToggleIndex)
                    }
                    
                    shortsUploadOptionView(iconImageName: IconName.onlyMe.literal,
                                           title: "나만 보기") {
                        CutomAccessSelectToggle(index: 2, selectedToggle: $store.selectedToggleIndex)
                    }
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    store.send(.submitSelection)
                }, label: {
                    Text("선택완료")
                    //TODO: Figma 글꼴 없데이트되면 추가하기
                        .font(.climeetFontTitle4())
                        .foregroundStyle(.text08)
                })
                .frame(height: 41)
                .frame(maxWidth: .infinity)
                .background(.climeetMain)
                .cornerRadius(5)
                .padding()
            }
        }
        .background(.climeetBackground)
    }
}

#Preview {
    UploadShortsAcessSelectView(store: Store(initialState: AccessStateReducer.State(accessState: .world, selectedToggleIndex: 0), reducer: {
        AccessStateReducer()
    }))
}
