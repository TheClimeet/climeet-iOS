//
//  DateTimePickerReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DateTimePickerReducer {
    @ObservableState
    struct State {
        var sheetType: SheetType
        // ... For DatePicker
        var selectedDate: Date
        var isSelectedDateToday = true
        // ... For TimePicker
        var isStartPickerActive = true
        var selectedStartTime: Date
        var selectedEndTime: Date
        
        init(
            sheetType: SheetType,
            selectedDate: Date = Date(),
            selectedStartTime: Date = Date(),
            selectedEndTime: Date = Date().addingTimeInterval(7200))
        {
            self.sheetType = sheetType
            self.selectedDate = selectedDate
            self.selectedStartTime = selectedStartTime
            self.selectedEndTime = selectedEndTime
        }
    }
    
    enum Action {
        case dateChanged(Date)
        case timeChanged(Date)
        case todayButtonTapped
        case dateConfirmButtonTapped
        case timeConfirmButtonTapped
        case cancelButtonTapped
        case startTimeButtonTapped
        case endTimeButtonTapped
        case delegate(Delegate)
        enum Delegate {
            case selectDate(Date)
            case selectTime(Date, Date)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .todayButtonTapped:
                let date = Date()
                state.selectedDate = date
                state.isSelectedDateToday = Calendar.current.isDateInToday(date)
                
                return .none
                
            case let .dateChanged(date):
                state.selectedDate = date
                state.isSelectedDateToday = Calendar.current.isDateInToday(date)
                
                return .none
                
            case let .timeChanged(time):
                if state.isStartPickerActive {
                    state.selectedStartTime = time
                } else {
                    state.selectedEndTime = time
                }
                
                return .none
                
            case .startTimeButtonTapped:
                state.isStartPickerActive = true
                
                return .none
                
            case .endTimeButtonTapped:
                state.isStartPickerActive = false
                
                return .none
                
            case .dateConfirmButtonTapped:
                return .run { [selectedDate = state.selectedDate] send in
                    await send(.delegate(.selectDate(selectedDate)))
                    await dismiss()
                }
                
            case .timeConfirmButtonTapped:
                return .run { [selectedStartTime = state.selectedStartTime,
                               selectedEndTime = state.selectedEndTime] send in
                    await send(.delegate(.selectTime(selectedStartTime, selectedEndTime)))
                    await dismiss()
                }
                
            case .cancelButtonTapped:
                return .run { _ in await dismiss() }
                
            case .delegate:
                return .none
            }
        }
    }
}
