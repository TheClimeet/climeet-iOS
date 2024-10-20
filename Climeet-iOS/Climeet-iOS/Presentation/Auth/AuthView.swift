//
//  AuthView.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/20/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct AuthView: View {
    @Bindable var store: StoreOf<AuthReducer>
    
    var body: some View {
        VStack(spacing: 83) {
            Image(.authLogo)
            
            VStack(spacing: 22) {
                kakaoBtn()
                
                naverBtn()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
        .toolbar(.hidden, for: .automatic)
    }
}

extension AuthView {
    @ViewBuilder
    private func kakaoBtn() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(.kakaoLogo)
                
                Text("카카오 아이디로 시작하기")
                    .font(.climeetFontTitle3())
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .tint(Color(hex: "#FAE100"))
        .padding(.horizontal, 14)
    }
    
    @ViewBuilder
    private func naverBtn() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(.naverLogo)
                
                Text("네이버 아이디로 시작하기")
                    .font(.climeetFontTitle3())
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .tint(Color(hex: "#03C75A"))
        .padding(.horizontal, 14)
    }
}

#Preview {
    AuthView(store: Store(
        initialState: .init(),
        reducer: {
        AuthReducer()
    }))
}
