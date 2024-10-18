//
//  SearchReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 5/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchReducer {
    @ObservableState
    struct State {
        var transitionType: TransitionType = .push
        var keyword = ""
        var searchResult: GymSearchResult?
        var homeGyms: IdentifiedArrayOf<Gym> = []
        var isHomeGymsVisible = false
        var isEmptySearchResult = false
    }
    
    enum Action {
        case onAppear
        case keywordChanged(String)
        case searchResponse(GymSearchResult)
        case retrieveHomeGymsResponse([Gym])
        case selectButtonTapped(Gym)
        case backButtonTapped
        case delegate(Delegate)
        enum Delegate {
            case selectGym(Gym)
        }
    }
    
    // MARK: Dependencies
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.userClient) var userClient
    @Dependency(\.climbingGymClient) var climbingGymClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let response = try await userClient.homeGyms(33)
                        let result = response.map {
                            Gym(
                                gymId: $0.gymID,
                                name: $0.gymName,
                                managerId: nil,
                                follower: $0.followerCount, // 관리자 ID 정보가 없으므로 nil로 설정
                                profileImageUrl: $0.gymProfileURL,
                                isFollow: nil // 팔로우 상태 정보가 없으므로 nil로 설정
                            )
                        }
                        
                        await send(.retrieveHomeGymsResponse(result))
                    } catch let error {
                        // TODO: 에러 발생 시 alert 발생, 유저에게 알리기
                        Log.log("Netowrk Error", ["Error: \(error)"], level: .error)
                    }
                }
                
            case .keywordChanged(let query):
                state.keyword = query
                state.isEmptySearchResult = false
                
                guard !state.keyword.isEmpty else {
                    state.searchResult = nil
                    state.isHomeGymsVisible = false
                    return .none
                }
                state.isHomeGymsVisible = true
                
                return .run { [keyword = state.keyword] send in
                    do {
                        let response = try await climbingGymClient.search(
                            .init(
                                gymname: keyword,
                                page: 0,
                                size: 15
                            )
                        )
                        let result = GymSearchResult(
                            page: response.page,
                            hasNext: response.hasNext,
                            gyms: response.result.compactMap {
                                Gym(
                                    gymId: Int($0.id),
                                    name: $0.name,
                                    managerId: Int($0.managerID),
                                    follower: $0.follower,
                                    profileImageUrl: $0.profileImageURL
                                )
                            })
                        
                        await send(.searchResponse(result))
                    } catch let error {
                        // TODO: 에러 발생 시 alert 발생, 유저에게 알리기
                        Log.log("Netowrk Error", ["Error: \(error)"], level: .error)
                    }
                }
                
            case let .searchResponse(gymSearchResult):
                state.searchResult = gymSearchResult
                if let isEmptySearchResult = state.searchResult?.gyms.isEmpty {
                    state.isEmptySearchResult = isEmptySearchResult
                }
                return .none
                
            case let .retrieveHomeGymsResponse(homeGyms):
                state.homeGyms = IdentifiedArray(uniqueElements: homeGyms)
                return .none
                
            case let .selectButtonTapped(selectedGym):
                return .run(operation: { send in
                    print(selectedGym)
                    await send(.delegate(.selectGym(selectedGym)))
                    await self.dismiss()
                })
                
            case .backButtonTapped:
                return .run { _ in await dismiss() }
                
            case .delegate:
                return .none
            }
        }
    }
}
