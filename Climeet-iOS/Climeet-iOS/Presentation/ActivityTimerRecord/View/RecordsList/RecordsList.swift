//
//  RecordsList.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/6/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct RecordsList: View {
    @Bindable var store: StoreOf<RecordsListReducer>
    
    var body: some View {
        ForEach(store.routeRecords, id: \.id) { record in
            radiusVStack {
                CellStyleStepper(
                    filteredRoute: record.selectedRoute,
                    attemptCount: record.attemptCount,
                    minusButtonAction: nil,
                    plusButtonAction: nil
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func radiusVStack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack {
            content()
        }
        .background(Color.text08)
        .cornerRadius(10)
    }
}

#Preview {
    RecordsList(store: Store(initialState: RecordsListReducer.State(), reducer: {
        RecordsListReducer()
    }))
}
