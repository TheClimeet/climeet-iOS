//
//  ActivityTimerRecordView.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/4/24.
//
import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityTimerRecordView: View {
    @Bindable var store: StoreOf<ActivityTimerRecordReducer>
    
    var body: some View {
        VStack {
            SelectGymButton(
                selectedGym: store.selectedGym,
                buttonAction: { store.send(.gymSelectionButtonTapped) }
            )
            
            RouteSelectionView(store: store.scope(
                state: \.routeSelectionState, action: \.routeSelectionAction)
            )
            
        }
        .background(Color.text09)
    }
    
}
