//
//  BannerFeature.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BannerReducer {
    
    let bannerChangeTime = 5
    
    @ObservableState
    struct State: Equatable {
        var selection = 0
        var bannerInfos: [BannerInfo] = []
        var timerCount = 0
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onFirstAppear
        case onAppear
        case onDisappear
        case timerTick
        case bannerResponse([BannerInfo])
    }
    
    @Dependency(\.bannerClient) var bannerClient
    
    enum CancelID { case timer }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .onFirstAppear:
                return .run { send in
                    do {
                        let response = try await bannerClient.banners()
                        let result = try response.map {
                            try BannerInfo(from: $0)
                        }
                        await send(.bannerResponse(result))
                    } catch let error {
                        Log.error("Error on onFirstAppear", "error: \(error)")
                    }
                }
                
            case .onAppear:
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
                
            case .onDisappear:
                return .cancel(id: CancelID.timer)
                
            case .timerTick:
                state.timerCount += 1
                if state.timerCount == bannerChangeTime {
                    state.timerCount = 0
                    // TODO: banner change
                    if state.selection < state.bannerInfos.count - 1 {
                        state.selection += 1
                    } else {
                        state.selection = 0
                    }
                }
                return .none
                
            case let .bannerResponse(bannerInfos):
                state.bannerInfos = bannerInfos
                return .none
            }
        }
    }
}
