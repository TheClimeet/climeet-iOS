//
//  ActivityTimerRecordView.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/4/24.
//
import SwiftUI
import ComposableArchitecture
import DesignSystem
import Kingfisher

struct ActivityTimerRecordView: View {
    @Bindable var store: StoreOf<ActivityTimerRecordReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            selectGymButton
            
            HeaderText("루트기록")
            routeSelection
                .padding(.bottom, 36)
            
            HeaderText("루트 기록 더보기")
            
            Spacer()
            
        }
        .background(Color.text09)
    }
    
    private func radiusVStack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack {
            content()
        }
        .background(Color.text08)
        .cornerRadius(10)
    }
    
    private var routeSelection: some View {
        radiusVStack {
            RouteSelectionView(store: store.scope(
                state: \.routeSelectionState, action: \.routeSelectionAction)
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            
            routeChipAttemptStepper
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 26)
    }
    
    private var routeChipAttemptStepper: some View {
        Group {
            if let selectedFilteredRoute = store.selectedFilteredRoute {
                CardStyleStepper(filteredRoute: selectedFilteredRoute)
            }
        }
        .padding(.horizontal, 12)
    }
    
    private var selectGymButton: some View {
        SelectGymButton(
            selectedGym: store.selectedGym,
            buttonAction: { store.send(.gymSelectionButtonTapped) }
        )
        .padding(.horizontal, 60)
        .padding(.top, 21)
        .padding(.bottom, 42)
    }
}

#Preview {
    ActivityTimerRecordView(store: Store(initialState: ActivityTimerRecordReducer.State(), reducer: {
        ActivityTimerRecordReducer()
    }))
}

fileprivate struct HeaderText: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.climeetFontTitle4())
            .foregroundColor(Color.white)
            .padding(.leading, 28)
            .padding(.bottom, 13)
    }
}
