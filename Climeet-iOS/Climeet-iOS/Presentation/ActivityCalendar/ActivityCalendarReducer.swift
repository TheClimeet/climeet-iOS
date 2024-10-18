//
//  ActivityCalendarReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActivityCalendarReducer {
    @Reducer
    enum Destination {
        case selectDateHalfSheet(DateTimePickerReducer)
        case recordActivitySheet(ActivityRecordReducer)
        case timerActivitySheet(ActivityTabReducer)
    }
    
    @ObservableState
    struct State {
        var screenSize = CGSize(width: 0, height: 0)
        var bottomSheetHeight: CGFloat = 0.0
        var isSelectedRecordButton = true
        var selectedMonth = 0
        var tappedCalendarDate = CalendarDate()
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case selectedMonthChanged(Int)
        case tappedCalendarDateChanged(CalendarDate)
        case readViewSize(CGSize)
        case recordButtonTapped
        case statisticButtonTapped
        case calendarTitleButtonTapped
        case playButtonTapped
        case plusButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    // MARK: Internal
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectedMonthChanged(let selectedMonth):
                state.selectedMonth = selectedMonth
                state.tappedCalendarDate = CalendarDate()
                
                return .none
                
            case let .tappedCalendarDateChanged(calendarDate):
                state.tappedCalendarDate = calendarDate
                
                return .none
                
            case .readViewSize(let size):
                state.screenSize = size
                
                return .none
                
            case .calendarTitleButtonTapped:
                state.bottomSheetHeight = state.screenSize.height * SheetType.datePicker.displaySizeRatio
                
                var reducer = DateTimePickerReducer.State(
                    sheetType: .datePicker
                )
                // DatePicker의 초기값 설정로직
                var datePickerSelectedDate: Date?
                if state.tappedCalendarDate.day != .zero {
                    datePickerSelectedDate = state.tappedCalendarDate.date
                } else {
                    datePickerSelectedDate = firstDayOfOffsetMonth(selectedMonth: state.selectedMonth)
                }
                reducer.selectedDate = datePickerSelectedDate ?? Date()
                
                state.destination = .selectDateHalfSheet(reducer)
                
                return .none

            case .recordButtonTapped:
                state.isSelectedRecordButton = true
                
                return .none
                
            case .statisticButtonTapped:
                state.isSelectedRecordButton = false
                
                return .none
            
            case .playButtonTapped:
                let reducer = ActivityTabReducer.State()
                
                state.destination = .timerActivitySheet(reducer)
                
                return .none
                
            case .plusButtonTapped:
                let reducer = ActivityRecordReducer.State()
                
                state.destination = .recordActivitySheet(reducer)
                
                return .none
                
            case let .destination(.presented(.selectDateHalfSheet(.delegate(.selectDate(selectedDate))))):
                let monthDifference = monthsBetweenNowDate(date: selectedDate)
                state.selectedMonth = monthDifference
                state.tappedCalendarDate = CalendarDate(
                    day: Calendar.current.component(.day, from: selectedDate),
                    date: selectedDate
                )
                
                return .none
                
            case .destination:
                
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func monthsBetweenNowDate(date: Date) -> Int {
        let calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month], from: Date())
        let endComponents = calendar.dateComponents([.year, .month], from: date)
        
        if let startYear = startComponents.year, let startMonth = startComponents.month,
           let endYear = endComponents.year, let endMonth = endComponents.month {
            return (endYear - startYear) * 12 + (endMonth - startMonth)
        }
        
        return 0
    }
    
    private func firstDayOfOffsetMonth(selectedMonth: Int) -> Date? {
        let calendar = Calendar.current
        guard let currentMonthAdded = calendar.date(byAdding: .month, value: selectedMonth, to: Date()) else {
            return nil
        }
        
        var components = calendar.dateComponents([.year, .month], from: currentMonthAdded)
        components.day = 1

        let firstDayOfMonth = calendar.date(from: components)
        
        return firstDayOfMonth
    }
}
