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

    private let activityTimerStore = Store(
        initialState: ActivityTimerReducer.State(), reducer: {
        ActivityTimerReducer()
    })
    
    private let activityCalendarStore = Store(
        initialState: ActivityCalendarReducer.State(), reducer: {
            ActivityCalendarReducer()
        })
    
    var body: some View {
        NavigationStack {
            TabView {
                ActivityTimerView(store: activityTimerStore)
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
