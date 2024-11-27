//
//  ShortsPostingReducer.swift
//  Climeet-iOS
//
//  Created by mac on 7/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ShortsPostingReducer {
    
    @ObservableState
    struct State: Equatable {
        var shorts: Shorts
        var isSuccessed: Bool = false
        
        static func == (lhs: ShortsPostingReducer.State, rhs: ShortsPostingReducer.State) -> Bool {
            return lhs.shorts == rhs.shorts && lhs.isSuccessed == rhs.isSuccessed
        }
    }
    
    enum Action {
        case uploadShorts
        case processResponse
        case openErrorSheet
    }
    
    @Dependency(\.shortsClient) var shortsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .uploadShorts:
                return .run { [shorts = state.shorts] send in
                    do {
                        let _ = try await self.shortsClient.upload(
                            .init(
                                video: shorts.video,
                                createShortsRequest: .init(from: shorts.createShortsRequest)
                            )
                        )
                        await send(.processResponse)
                    } catch let error {
                        Log.error("NetworkError", "error: \(error)")
                    }
                }
                
            case .processResponse:
                state.isSuccessed = true
                return .none
                
            case .openErrorSheet:
                state.isSuccessed = false
                return .none
            }
        }
    }
}
