//
//  AuthView.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/20/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import AuthenticationServices

struct AuthView: View {
    @Bindable var store: StoreOf<AuthReducer>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack(spacing: 83) {
                Image(.authLogo)
                
                VStack(spacing: 22) {
                    kakaoBtn()
                        .overlay {
                            TooltipView(
                                alignment: .top,
                                isVisible: .constant(true),
                                xPadding: 0,
                                yPadding: 14
                            ) {
                                HStack {
                                    Image(.authTooltipIcon)
                                    
                                    Text("3초만에 로그인하세요")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    naverBtn()
                    
                    appleBtn()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.text09)
        } destination: { store in
            switch store.case {
            case .setNickname(let store):
                SetNicknameView(store: store)
            }
        }
    }
}

extension AuthView {
    @ViewBuilder
    private func kakaoBtn() -> some View {
        SocialButton(
            text: "카카오 아이디로 시작하기",
            textColor: .levelBlack,
            image: .kakaoLogo,
            bgColor: Color(hex: "#FAE100"),
            action: { self.store.send(.kakaoBtnDidTap) }
        )
    }
    
    @ViewBuilder
    private func naverBtn() -> some View {
        SocialButton(
            text: "네이버 아이디로 시작하기",
            textColor: .levelWhite,
            image: .naverLogo,
            bgColor: Color(hex: "#03C75A"),
            action: { self.store.send(.naverBtnDidTap) }
        )
    }
    
    @ViewBuilder
    private func appleBtn() -> some View {
        SocialButton(
            text: "애플 아이디로 시작하기",
            textColor: .levelWhite,
            image: .appleLogo,
            bgColor: .levelBlack,
            action: {  }
        )
        .overlay {
            SignInWithAppleButton { request in
                request.requestedScopes = [.email]
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    switch auth.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        store.send(.appleBtnDidTap(idToken: appleIDCredential.identityToken))
                    default:
                        break
                    }
                case .failure(let error):
                    break
                }
            }
            .blendMode(.overlay)
            .padding(.horizontal, 14)
        }
    }
    
    struct SocialButton: View {
        var text: String
        var textColor: Color
        var image: ImageResource
        var bgColor: Color?
        var action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Image(image)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(text)
                        .font(.climeetFontTitle3())
                        .foregroundStyle(textColor)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            .tint(bgColor)
            .padding(.horizontal, 14)
        }
    }
}

#Preview {
    AuthView(store: Store(
        initialState: .init(),
        reducer: {
        AuthReducer()
    }))
}
