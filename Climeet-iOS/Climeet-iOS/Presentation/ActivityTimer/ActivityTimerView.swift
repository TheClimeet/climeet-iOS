//
//  ActivityTimerView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/26/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityTimerView: View {
    @Bindable var store: StoreOf<ActivityTimerReducer>
        
    var body: some View {
        
        VStack(spacing: 40) {
            ChallengeStats()
            
            SelectGymButton(
                selectedGym: store.selectedGym,
                buttonAction: { store.send(.gymSelectionButtonTapped) })
            
            ExpandableControlButton(
                startAction: { store.send(.startButtonTapped) },
                pauseAction: { store.send(.pauseButtonTapped) },
                resetAction: { store.send(.resetButtonTapped) }
            )
            
            ActivityTimer(elapsedTime: store.elapsedTime)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(25)
        .background(Color.text09)
        .onReadSize({ size in
            store.send(.readViewSize(size))
        })
        .sheet(
            item: $store.scope(
                state: \.destination?.searchGymSheet,
                action: \.destination.searchGymSheet)
        ) { searchGymStore in
            SearchView(store: searchGymStore)
                .presentationDetents([.height(store.bottomSheetHeight)])
        }
    }
}
