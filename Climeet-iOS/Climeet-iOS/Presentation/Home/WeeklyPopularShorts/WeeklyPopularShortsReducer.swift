//
//  WeeklyPopularShortsReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WeeklyPopularShortsReducer {
    @ObservableState
    struct  State: Equatable {
        var shortsItems: IdentifiedArrayOf<PopularShorts> = []
    }
    
    enum Action {
        case onFirstAppear
        case popularShortsResponse([PopularShorts])
    }
    
    @Dependency(\.shortsClient) var shortsClient
    @Dependency(\.difficultyMappingClient) var difficultyMappingClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    let request = ShortsDTO.List.Request(page: 0, size: 10)
                    let response = try await shortsClient.popularShorts(request)
                    
                    let result = try await withThrowingTaskGroup(of: PopularShorts?.self) { group in
                        for responseItem in response.result {
                            group.addTask {
                                guard let id = responseItem.shortsDetailInfo?.gymID else {
                                    throw AppError.dataParsingError("gymID not found")
                                }
                                
                                let difficulty = try await difficultyMappingClient.gymDifficulty(id)
                                
                                guard !difficulty.isEmpty else { return nil }
                                
                                return try PopularShorts(
                                    from: responseItem,
                                    difficulty: try GymDifficulty(from: difficulty[0])
                                )
                            }
                        }
                        
                        var popularShorts: [PopularShorts] = []
                        
                        for try await item in group {
                            if let item = item {
                                popularShorts.append(item)
                            }
                        }
                        
                        return popularShorts
                    }
                    
                    await send(.popularShortsResponse(result))
                }
                
            case let .popularShortsResponse(response):
                state.shortsItems = IdentifiedArray(uniqueElements: response)
                print(state.shortsItems)
                return .none
            }
        }
    }
}
