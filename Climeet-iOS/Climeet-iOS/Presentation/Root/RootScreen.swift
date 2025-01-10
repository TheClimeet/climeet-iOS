//
//  RootScreen.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 1/10/25.
//

import SwiftUI
import ComposableArchitecture

struct RootScreen: View {
    @Bindable var store: StoreOf<RootScreenReducer>
    
    var body: some View {
        MainTabView()
            .fullScreenCover(store: store.scope(state: \.$auth, action: \.auth)) { store in
                AuthScreen(store: store)
            }
            .task {
                store.send(.onLoad)
            }
    }
}
