//
//  HomeBestClimberReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeBestClimberReducer {
    @ObservableState
    struct State: Equatable {
        var bestClearClimbers: IdentifiedArrayOf<BestClearClimber> = []
        var bestTimeClimbers: IdentifiedArrayOf<BestTimeClimber> = []
        var bestLevelClimbers: IdentifiedArrayOf<BestLevelClimber> = []
    }
    
    enum Action {
        case onFirstApear
        case bestClearClimberResponse([BestClearClimber])
        case bestTimeClimberResponse([BestTimeClimber])
        case bestLevelClimberResponse([BestLevelClimber])
    }
    
    @Dependency(\.bestClearClimberClient) var bestClearClimberClient
    @Dependency(\.bestTimeClimberClient) var bestTimeClimberClient
    @Dependency(\.bestLevelClimberClient) var bestLevelClimberClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstApear:
                return .run { send in
                    do {
                        let clearResponse = try await bestClearClimberClient.rankWeekClimbersClear()
                        let clearResult = try clearResponse.map {
                            try BestClearClimber(from: $0)
                        }
                        await send(.bestClearClimberResponse(clearResult))
                        
                        let timeResponse = try await bestTimeClimberClient.rankWeeksClimbersTime()
                        let timeResult = try timeResponse.map {
                            try BestTimeClimber(from: $0)
                        }
                        await send(.bestTimeClimberResponse(timeResult))
                        
                        let levelResponse = try await bestLevelClimberClient.rankWeeksClimbersLevel()
                        let levelResult = try levelResponse.map {
                            try BestLevelClimber(from: $0)
                        }
                        await send(.bestLevelClimberResponse(levelResult))
                    } catch let error {
                        print(error) // TODO: 에러 처리
                    }
                }
                
            case let .bestClearClimberResponse(bestClearClimbers):
                let sortedClimbers = bestClearClimbers.sorted(by: { $0.ranking < $1.ranking } )
                if sortedClimbers.count < 3 {
                    while sortedClimbers.count > 3 {
                    }
                }
                state.bestClearClimbers = IdentifiedArray(uniqueElements: sortedClimbers)
                return .none
                
            case let .bestTimeClimberResponse(bestTimeClimbers):
                let sortedClimbers = bestTimeClimbers.sorted(by: { $0.ranking < $1.ranking } )
                state.bestTimeClimbers = IdentifiedArray(uniqueElements: sortedClimbers)
                return .none
                
            case let .bestLevelClimberResponse(bestLevelClimbers):
                let sortedClimbers = bestLevelClimbers.sorted(by: { $0.ranking < $1.ranking } )
                state.bestLevelClimbers = IdentifiedArray(uniqueElements: sortedClimbers)
                return .none
            }
        }
    }
}
