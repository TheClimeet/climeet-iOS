//
//  RecordsListReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/6/24.
//

import Foundation
import ComposableArchitecture

struct RouteRecord: Identifiable {
    var id = UUID()
    let selectedRoute: FilteredRoute
    let attemptCount: Int
    let isCompleted: Bool
}

@Reducer
struct RecordsListReducer {
    @ObservableState
    struct State {
        var routeRecords: IdentifiedArrayOf<RouteRecord> = []
    }
    
    enum Action {
        case addRouteRecord(FilteredRoute)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addRouteRecord(let route):
                let isUniqueRoute = !state.routeRecords.contains { routeRecord in
                    routeRecord.selectedRoute.routeId == route.routeId
                }
                
                guard isUniqueRoute else {
                    return .none
                }
                
                let routeRecord = RouteRecord(
                    selectedRoute: route,
                    attemptCount: 0,
                    isCompleted: false
                )
                state.routeRecords.append(routeRecord)
                
                return .none
            }
        }
    }
}

// 1. 루트아이디, 시도횟수, 컴플리트여부, 짐아이디, 현재시간, 평균난이도
// 루트칩, 스테퍼, 완등률, 삭제
// 필터드루트, 도전횟수, isComplete
