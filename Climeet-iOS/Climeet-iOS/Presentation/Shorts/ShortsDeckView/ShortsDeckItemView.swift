//
//  ShortsDeckItemView.swift
//  Climeet-iOS
//
//  Created by mac on 8/29/24.
//

import SwiftUI
import ComposableArchitecture

struct ShortsDeckItemScrollView: View {
    @Bindable var store: StoreOf<ShortsDeckItemReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ShortsDeckItemScrollView(store: Store(initialState: {
        ShortsDeckItemReducer.State()
    }(), reducer: {
        ShortsDeckItemReducer()
    }))
}
