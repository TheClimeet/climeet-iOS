//
//  WeeklyPopularGymReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 12/6/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WeeklyPopularGymReducer {
    @ObservableState
    struct State: Equatable {
        var bestFollowGym: IdentifiedArrayOf<BestFollowGymInfo> = []
        var bestRecordGym: IdentifiedArrayOf<BestRecordGymInfo> = []
    }
    
    enum Action {
        case onFirstAppear
        case rankWeekGymsFollowSuccess([BestFollowGymInfo])
        case rankWeekGymsRecordSuccess([BestRecordGymInfo])
    }
    
    @Dependency(\.bestFollowGymClient) var bestFollowGymClient
    @Dependency(\.bestRecordGymClient) var bestRecordGymClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    do {
                        async let rankFollow = bestFollowGymClient.rankWeeksGymsFollow()
                        async let rankRecord = bestRecordGymClient.rankWeeksGymsRecord()
                        let followResult = try await rankFollow.map {
                            try BestFollowGymInfo(from: $0)
                        }
                        await send(.rankWeekGymsFollowSuccess(followResult))
                        let recordResult = try await rankRecord.map {
                            try BestRecordGymInfo(from: $0)
                        }
                        await send(.rankWeekGymsRecordSuccess(recordResult))
                    } catch let error {
                        print(error) // TODO: 에러 처리
                    }
                }
                
            case let .rankWeekGymsFollowSuccess(followResult):
                state.bestFollowGym = IdentifiedArray(uniqueElements: followResult)
                return .none
                
            case let .rankWeekGymsRecordSuccess(recordResult):
                state.bestRecordGym = IdentifiedArray(uniqueElements: recordResult)
                return .none
            }
        }
    }
}
