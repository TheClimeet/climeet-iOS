//
//  SetNicknameView.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/17/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Combine

struct SetNicknameView: View {
    @Bindable var store: StoreOf<SetNicknameReducer>
    @State var nickname: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            headerSection()
            
            NicknameTextField(
                text: $nickname,
                btnAction: { store.send(.duplicateBtnTap) }
            )
            .onChange(of: nickname) { _, newValue in
                nickname = String(newValue.prefix(8))
                store.send(.updateNickname(nickname))
            }
            
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            nextButton()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.pop)
                } label: {
                    Image(.searchBack)
                }
            }
        }
        .task {
            Log.debug("init SetNickname View")
        }
    }
}

extension SetNicknameView {
    @ViewBuilder
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("클밋에서 사용하실\n닉네임을 설정해주세요!")
                .font(.climeetFontTitle2())
                .foregroundStyle(Color.levelWhite)
                .multilineTextAlignment(.leading)
            
            Text("2~8글자의 한글과 숫자만 가능해요.\n설정에서 언제든지 바꿀 수 있어요.")
                .font(.climeetFontParagraph5())
                .foregroundStyle(Color.levelWhite)
                .multilineTextAlignment(.leading)
        }
    }
    
    struct NicknameTextField: View {
        @Binding var text: String
        var btnAction: () -> Void
        
        private var isEmptyText: Bool { text.count > 0 }
        private var btnTextColor: Color {
            isEmptyText ? Color.levelBlack : Color.levelWhite
        }
        private var btnBGColor: Color {
            isEmptyText ? Color.climeetMain : Color.text04
        }
        var body: some View {
            TextField(
                "",
                text: $text,
                prompt: Text("2~8글자의 한글과 숫자로 입력하세요.")
                    .foregroundStyle(Color.levelWhite)
            )
            .accentColor(.text06)
            .foregroundColor(.white)
            .font(.climeetFontParagraph6())
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, minHeight: 42)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.text06)
            )
            .overlay(alignment: .trailing) {
                Button {
                    btnAction()
                } label: {
                    Text("중복확인")
                        .font(.climeetFontCaptionText3())
                        .foregroundStyle(btnTextColor)
                }
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(btnBGColor)
                )
                .padding(.trailing, 5)
            }
        }
    }
    
    @ViewBuilder
    private func nextButton() -> some View {
        var bgColor: Color {
            store.isEnabledNext ? Color.climeetMain : Color.grayButton
        }
        var arrowColor: Color {
            store.isEnabledNext ? Color.levelBlack : Color.levelWhite
        }
        Button {
            store.send(.nextBtnTap)
        } label: {
            Circle()
                .frame(width: 54, height: 54)
                .foregroundStyle(bgColor)
                .overlay {
                    Image(.homeArrowRight)
                        .resizable()
                        .renderingMode(.template)
                        .tint(arrowColor)
                        .frame(width: 14, height: 14)
                }
        }
    }
}

#Preview {
    SetNicknameView(store: Store(
        initialState: .init(),
        reducer: {
            SetNicknameReducer()
    }))
}
