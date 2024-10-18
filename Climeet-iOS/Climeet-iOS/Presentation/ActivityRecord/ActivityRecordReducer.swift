//
//  ActivityRecordReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActivityRecordReducer {
    @Reducer
    enum Destination {
        case selectDateTime(DateTimePickerReducer)
        case searchGyms(SearchReducer)
    }
    
    @ObservableState
    struct State {
        var screenSize = CGSize(width: 0, height: 0)
        var bottomSheetHeight: CGFloat = 0.0
        var selectedGym = Gym()
        var selectedDate = ""
        var selectedTime = ""
        var filteredRoute: FilteredRoute?
        
        @Presents var destination: Destination.State?
        var path = StackState<SearchReducer.State>()
        var routeSelectionState = RouteSelectionReducer.State(selectedGym: nil)
    }
    
    enum Action {
        case readViewSize(CGSize)
        case selectDateButtonTapped
        case selectTimeButtonTapped
        case closeButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case path(StackAction<SearchReducer.State, SearchReducer.Action>)
        case routeSelectionAction(RouteSelectionReducer.Action)
    }
    
    // MARK: Lifecycle
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.routeSelectionState,action: \.routeSelectionAction) {
                RouteSelectionReducer()
            }
        
        Reduce { state, action in
            switch action {
            case let .readViewSize(viewSize):
                state.screenSize = viewSize
                
                return .none
                
            case .selectDateButtonTapped:
                state.bottomSheetHeight = state.screenSize.height * SheetType.datePicker.displaySizeRatio
                
                var reducer = DateTimePickerReducer.State(
                    sheetType: .datePicker
                )
                if !state.selectedDate.isEmpty {
                    reducer.selectedDate = parseKoreanFullToDate(
                        dateString: state.selectedDate
                    )
                }
                state.destination = .selectDateTime(reducer)
                
                return .none
                
            case .selectTimeButtonTapped:
                state.bottomSheetHeight = state.screenSize.height * SheetType.timePicker.displaySizeRatio
                
                var reducer = DateTimePickerReducer.State(
                    sheetType: .timePicker
                )
                
                if !state.selectedTime.isEmpty {
                    let times = parseTimeRange(timeRange: state.selectedTime)
                    reducer.selectedStartTime = times.start
                    reducer.selectedEndTime = times.end
                }
                state.destination = .selectDateTime(reducer)
                
                return .none
            
            case .closeButtonTapped:
                
                return .run { _ in await dismiss() }
                
            case let .path(.element(_, action: .delegate(.selectGym(selectedGym)))):
                state.selectedGym = selectedGym
                state.routeSelectionState.selectedGym = selectedGym
                
                return .run { send in
                    await send(.routeSelectionAction(.gymSet))
                }
                
            case let .destination(.presented(.selectDateTime(.delegate(.selectDate(selectedDate))))):
                state.selectedDate = DateFormatter.koreanFullDateWithDayFormatter.string(from: selectedDate)
                
                return .none
                
            case let .destination(.presented(.selectDateTime(.delegate(.selectTime(startTime, endTime))))):
                let amStartTime = DateFormatter.amTimeFormatter.string(from: startTime)
                let amEndTime = DateFormatter.amTimeFormatter.string(from: endTime)
                state.selectedTime = "\(amStartTime) ~ \(amEndTime)"
                
                return .none
                            
            case .routeSelectionAction(.filteredRouteChangeButtonTapped(let filteredRoute)):
                state.filteredRoute = filteredRoute
                
                return .none
                
            case .destination, .path:
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path) {
            SearchReducer()
        }
    }
}

extension ActivityRecordReducer {
    
    /// AM 9:00 ~ AM 11:00 -> `(Date, Date)`
    private func parseTimeRange(timeRange: String) -> (start: Date, end: Date) {
        let dateFormatter = DateFormatter.amTimeFormatter
        
        let times = timeRange
            .split(separator: "~")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard times.count == 2,
              let startTime = dateFormatter.date(from: String(times[0])),
              let endTime = dateFormatter.date(from: String(times[1])) else {
            return (Date(), Date())
        }
        
        return (startTime, endTime)
    }
    
    /// 2023년 12월 12일 (화) -> `Date`
    private func parseKoreanFullToDate(dateString: String) -> Date {
        guard
            let date = DateFormatter.koreanFullDateWithDayFormatter.date(
                from: dateString) else {
            return Date()
        }
        
        return date
    }
}
