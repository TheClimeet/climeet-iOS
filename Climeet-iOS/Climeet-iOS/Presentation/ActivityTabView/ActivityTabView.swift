//
//  ActivityTabView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/27/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityTabView: View {
    @Bindable var store: StoreOf<ActivityTabReducer>
    
    private let activityCalendarStore = Store(
        initialState: ActivityCalendarReducer.State(), reducer: {
            ActivityCalendarReducer()
        })
    
    var body: some View {
        NavigationStack {
            TabView {
                ActivityTimerView(
                    gym: store.selectedGym,
                    handleClimbingGymSelectionTapped: {
                        store.send(.selectGymButtonTapped)
                    }
                )
                
                ActivityCalendarView(store: activityCalendarStore)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.text09)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image("activity_close")
                            .resizable()
                    })
                }
            }
            .navigationTitle("운동기록")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(.gray217)
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.climeetMain)
        }
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

// Preview
struct ActivityTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTabView(store: Store(initialState: ActivityTabReducer.State(), reducer: {
            ActivityTabReducer()
        }))
    }
}
