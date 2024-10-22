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
            
            Button(action: {
                store.send(.gymSelectionButtonTapped)
            }, label: {
                HStack(alignment: .center, spacing: 5) {
                    if !store.selectedGym.name.isEmpty {
                        Image("activitytimer_map")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text(store.selectedGym.name)
                            .font(.climeetFontParagraph4())
                            .foregroundColor(Color.starNotFilled)
                    } else {
                        Text("암장을 선택해주세요")
                            .font(.climeetFontParagraph4())
                            .foregroundColor(Color.starNotFilled)
                    }
                }
            })
            .padding(.horizontal, 20)
            .frame(height: 35)
            .background(Color.text08)
            .cornerRadius(5.0)
            
            ExpandableControlButton()
            
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
