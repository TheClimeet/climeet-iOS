//
//  AuthScreen.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 1/10/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AuthScreen: View {
    @Bindable var store: StoreOf<AuthScreenReducer>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            AuthView(store: store.scope(state: \.auth, action: \.auth))
        } destination: { store in
            switch store.case {
            case .setNickname(let store):
                SetNicknameView(store: store)
            case .setProfile(let store):
                SetProfileView(store: store)
            case .checkLevel(let store):
                CheckLevelView(store: store)
            }
        }
    }
}
