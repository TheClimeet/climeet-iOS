//
//  ActivityRecordView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/4/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityRecordView: View {
    @Bindable var store: StoreOf<ActivityRecordReducer>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        ActivityRecordHeader(text: "날짜")
                            .padding(.top, 28)
                            .padding(.bottom, 13)
                        
                        ClimbingSetupButton(
                            placeholderText: "날짜를 입력해주세요",
                            text: store.selectedDate,
                            isEmpty: store.selectedDate.isEmpty) {
                                store.send(.selectDateButtonTapped)
                            }
                        
                        ClimbingSetupButton(
                            placeholderText: "시간을 선택해주세요(선택)",
                            text: store.selectedTime,
                            isEmpty: store.selectedTime.isEmpty) {
                                store.send(.selectTimeButtonTapped)
                            }
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 26)
                    
                    VStack {
                        ActivityRecordHeader(text: "암장")
                            .padding(.top, 28)
                            .padding(.bottom, 13)
                        
                        NavigationLink(state: SearchReducer.State()) {
                            ClimbingSetupView(
                                placeholderText: "클라이밍 암장을 선택해주세요",
                                text: store.selectedGym.name,
                                isEmpty: store.selectedGym.name.isEmpty
                            )
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.text08)
                        .cornerRadius(5)
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 26)
                    
                    VStack {
                        ActivityRecordHeader(text: "루트기록")
                            .padding(.top, 28)
                            .padding(.bottom, 13)
                        
                        if store.selectedGym.name.isEmpty {
                            NavigationLink(state: SearchReducer.State()) {
                                ClimbingSetupView(
                                    placeholderText: "암장을 선택하면 루트를 기록할 수 있어요!",
                                    text: "",
                                    isEmpty: store.selectedGym.name.isEmpty
                                )
                            }
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color.text08)
                            .cornerRadius(5)
                        } else {
                            RouteSelectionView(
                                store: store.scope(
                                    state: \.routeSelectionState, action: \.routeSelectionAction
                                )
                            )
                        }
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 26)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.text09)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        store.send(.closeButtonTapped)
                    }, label: {
                        Image("activity_close")
                            .frame(width: 24, height: 24)
                    })
                    
                }
            }
            .toolbarBackground(
                Color.text09,
                for: .navigationBar
            )
        } destination: { store in
            SearchView(store: store)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.searchGyms,
                action: \.destination.searchGyms)
        ) { searchStore in
            SearchView(store: searchStore)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.selectDateTime,
                action: \.destination.selectDateTime)
        ) { dateTimePickerStore in
            DateTimePickerView(store: dateTimePickerStore)
                .presentationDetents([.height(store.bottomSheetHeight)])
        }
        .onReadSize({ size in
            store.send(.readViewSize(size))
        })
    }
}

#Preview {
    ActivityRecordView(store: Store(
        initialState: ActivityRecordReducer.State(), reducer: {
            ActivityRecordReducer()
        }))
}
