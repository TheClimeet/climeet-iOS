//
//  WeeklyPopularShortsReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/26/24.
//

import Foundation
import ComposableArchitecture

struct PopularShorts: Equatable, Identifiable {
    let id = UUID()
    let thumbnailImageURL: String
    
    init(from dto: ShortsDTO.Shorts.Response) throws {
        guard let thumbnailImageURL = dto.thumbnailImageURL else {
            throw AppError.dataParsingError("dto property nil")
        }
        self.thumbnailImageURL = thumbnailImageURL
    }
}

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
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    let request = ShortsDTO.List.Request(page: 0, size: 10)
                    let response = try await shortsClient.popularShorts(request)
                    let result = try response.result.map {
                        try PopularShorts(from: $0)
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
