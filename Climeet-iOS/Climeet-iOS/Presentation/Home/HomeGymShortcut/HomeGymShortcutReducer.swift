//
//  HomeGymShortcutReducer.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeGymShortcutReducer {
    @ObservableState
    struct State: Equatable {
        var homeGymInfo: IdentifiedArrayOf<HomeGymInfo> = []
    }
    
    enum Action {
        case onFirstAppear
        case homeGymInfoResponse([HomeGymInfo])
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    // 홈짐 바로가기 데이터 호출
                    let response = try await userClient.homeGyms(nil)
                    let result = response.map { HomeGymInfo(from: $0) }
                    await send(.homeGymInfoResponse(result))
                }
                
            case let .homeGymInfoResponse(homeGymInfo):
                state.homeGymInfo = IdentifiedArray(uniqueElements: homeGymInfo)
                return .none
            }
        }
    }
}
