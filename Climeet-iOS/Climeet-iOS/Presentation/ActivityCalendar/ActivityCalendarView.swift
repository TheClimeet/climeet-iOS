//
//  ActivityCalendarView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/16/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ActivityCalendarView: View {
    @Bindable var store: StoreOf<ActivityCalendarReducer>
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack(spacing: 15) {
                    Button {
                        store.send(.recordButtonTapped)
                    } label: {
                        Text("기록")
                            .font(.climeetFontTitle3())
                            .foregroundColor(
                                store.isSelectedRecordButton ? Color.levelWhite
                                : Color.gray103
                            )
                    }
                    
                    Button {
                        store.send(.statisticButtonTapped)
                    } label: {
                        Text("통계")
                            .font(.climeetFontTitle3())
                            .foregroundColor(
                                !store.isSelectedRecordButton ? Color.levelWhite
                                : Color.gray103
                            )
                    }
                    
                    Spacer()
                }
                .padding(.top, 43)
                .padding(.leading, 26)
                Spacer()
            }
            
            CustomCalendar(
                selectedMonth: $store.selectedMonth.sending(\.selectedMonthChanged), 
                tappedDate: $store.tappedCalendarDate.sending(\.tappedCalendarDateChanged),
                calendarTitleTappedAction: {
                    store.send(.calendarTitleButtonTapped)
                }
            )
            
            HStack(spacing: 6) {
                Spacer()
                
                Button(action: {
                    store.send(.playButtonTapped)
                }, label: {
                    Image("activity_play")
                })
                .frame(width: 54, height: 54)
                .background(Color.climeetMain)
                .clipShape(Circle())
                
                Button(action: {
                    store.send(.plusButtonTapped)
                }, label: {
                    Image("activity_plus")
                })
                .frame(width: 54, height: 54)
                .background(Color.climeetMain)
                .clipShape(Circle())
            }
            .padding(.vertical, 37)
            .padding(.trailing, 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
        .onReadSize({ size in
            store.send(.readViewSize(size))
        })
        .sheet(
            item: $store.scope(
                state: \.destination?.selectDateHalfSheet,
                action: \.destination.selectDateHalfSheet)
        ) { dateTimePickerStore in
            DateTimePickerView(store: dateTimePickerStore)
                .presentationDetents([.height(store.bottomSheetHeight)])
        }
        .fullScreenCover(
            item: $store.scope(
                state: \.destination?.recordActivitySheet,
                action: \.destination.recordActivitySheet)
        ) { recordActivityStore in
            ActivityRecordView(store: recordActivityStore)
        }
        .fullScreenCover(item: $store.scope(
            state: \.destination?.timerActivitySheet,
            action: \.destination.timerActivitySheet)
        ) { timerActivityStore in
            ActivityTabView(store: timerActivityStore)
        }
    }
}

#Preview {
    ActivityCalendarView(store: Store(initialState: ActivityCalendarReducer.State(), reducer: {
        ActivityCalendarReducer()
    }))
}
