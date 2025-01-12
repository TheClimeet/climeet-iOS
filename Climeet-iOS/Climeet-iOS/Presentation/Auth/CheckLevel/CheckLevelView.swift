//
//  CheckLevelView.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/29/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct CheckLevelView: View {
    @Bindable var store: StoreOf<CheckLevelReducer>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 54) {
            headerSection()
            levelSection()
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            nextButton()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
        .backTopBar(title: "클라이밍 레벨", backAction: { store.send(.pop) }, underLine: true)
        .task {
            Log.debug("init CheckLevel View")
        }
    }
}

extension CheckLevelView {
    @ViewBuilder
    private func headerSection() -> some View {
        Text("켈리0921님, 클라이밍을\n시작한지 얼마나 되셨어요?")
            .font(.climeetFontTitle2())
            .foregroundStyle(Color.levelWhite)
            .multilineTextAlignment(.leading)
            .padding(.top, 60)
    }
    
    @ViewBuilder
    private func levelSection() -> some View {
        VStack(spacing: 0) {
            ForEach(store.rows, id: \.id) { element in
                Button {
                    store.send(.rowTap(element))
                } label: {
                    LevelRow(element: element)
                }
            }
        }
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
    
    struct LevelRow: View {
        var element: CheckLevelReducer.State.CheckLevel
        
        private var bgColor: Color { element.isSelected ? .climeetMain : .white.opacity(0.2) }
        private var textColor: Color { element.isSelected ? .text09 : .levelWhite }
        
        var body: some View {
            HStack(alignment: .center, spacing: 25) {
                Text(element.text)
                    .font(.climeetFontParagraph1())
                    .multilineTextAlignment(.center)
                    .foregroundColor(textColor)
                    .frame(width: 65, height: 43, alignment: .center)
                
                Text(element.content)
                    .font(.climeetFontParagraph5())
                    .multilineTextAlignment(.center)
                    .foregroundColor(textColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
            .padding(.vertical, 5)
            .background(bgColor)
            .cornerRadius(8)
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    CheckLevelView(store: Store(
        initialState: .init(
            signupExtra: .init(
                accessToken: "",
                socialType: .kakao,
                nickName: "Nickname",
                climbingLevel: .BEGINNER,
                discoveryChannel: .INSTAGRAM_FACEBOOK,
                profileImgURL: "",
                gymFollowList: [1]
            )
        ),
        reducer: {
            CheckLevelReducer()
        }))
}
