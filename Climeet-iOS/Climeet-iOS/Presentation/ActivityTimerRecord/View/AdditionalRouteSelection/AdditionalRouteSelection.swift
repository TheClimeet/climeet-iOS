//
//  AddtionalRouteSelection.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/6/24.
//

import SwiftUI
import ComposableArchitecture

struct AdditionalRouteSelection: View {
    @Bindable var store: StoreOf<AdditionalRouteSelectionReducer>
    
    var body: some View {
        VStack {
            RouteSelectionView(store: store.scope(
                state: \.routeSelectionState, action: \.routeSelectionAction)
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            
            if
                let filteredRoute = store.selectedFilteredRoute
            {
                CardStyleStepper(
                    filteredRoute: filteredRoute,
                    attemptCount: store.attemtCount,
                    minusButtonAction: { store.send(.minusButtonTapped) },
                    plusButtonAction: { store.send(.plusButtonTapped) }
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 20)
            }
            
        }
    }
}

#Preview {
    AdditionalRouteSelection(store: Store(initialState: AdditionalRouteSelectionReducer.State(), reducer: {
        AdditionalRouteSelectionReducer()
    }))
}
