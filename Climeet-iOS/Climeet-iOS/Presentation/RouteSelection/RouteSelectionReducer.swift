//
//  RouteSelectionReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 9/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RouteSelectionReducer {
    
    @ObservableState
    struct State {
        var selectedGym: Gym?
        var gymRoutes: GymRoutes?
        
        var selectedFloor = 0
        var selectedSector = Sector()
        var selectedDifficulty = Difficulty()
        var selectedFilteredRoute = FilteredRoute()
        
        var filteredRoutesResponse = [FilteredRoute]() // 응답결과값
        
        var isSelectionDone: Bool = false
    }
    
    enum Action {
        case gymSet
        case floorChangeSegmentedControlTapped(Int)
        case sectorChangeButtonTapped(Sector)
        case difficultyChangeButtonTapped(Difficulty)
        case filteredRouteChangeButtonTapped(FilteredRoute)
        case requestFilteredRoutes
        case routesResponse(GymRoutes)
        case filteredRouteResponse([FilteredRoute])
        
        case doneSelection
        case inSelection
        
        case delegate(Delegate)
        enum Delegate {
            case selectedRoute(FilteredRoute)
        }
    }
    
    @Dependency(\.routeVersionClient) var routeVersionClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .gymSet:
                return .run { [selectedGym = state.selectedGym] send in
                    guard let gymID = selectedGym?.gymId else {
                        return
                    }
                    
                    let response = try await routeVersionClient.gymVersionKey(gymID, nil)
                    let result = GymRoutes(from: response)
                    
                    await send(.routesResponse(result))
                }
                
            case .floorChangeSegmentedControlTapped(let floor):
                state.selectedFloor = floor
                state.selectedSector = Sector()
                state.selectedDifficulty = Difficulty()
                state.selectedFilteredRoute = FilteredRoute()
                
                return .run { send in
                    await send(.requestFilteredRoutes)
                    await send(.inSelection)
                }
                
            case .sectorChangeButtonTapped(let sector):
                state.selectedSector = sector
                state.selectedDifficulty = Difficulty()
                state.selectedFilteredRoute = FilteredRoute()

                return .run { send in
                    await send(.inSelection)
                    await send(.requestFilteredRoutes)
                }
                
            case .difficultyChangeButtonTapped(let difficulty):
                state.selectedDifficulty = difficulty
                state.selectedFilteredRoute = FilteredRoute()
                
                return .run { send in
                    await send(.inSelection)
                    await send(.requestFilteredRoutes)
                }
                
            case .requestFilteredRoutes:
                return .run { [
                    gymID = state.selectedGym?.gymId,
                    sector = state.selectedSector,
                    floor = state.selectedFloor,
                    difficulty = state.selectedDifficulty] send in
                    
                    guard let gymID = gymID else { return }
                    
                    var allRoutes: [FilteredRoute] = []
                    var currentPage = 0
                    var hasNext = true
                    
                    while hasNext {
                        do {
                            let response = try await routeVersionClient.gymVersionRoute(
                                .init(
                                    gymID: gymID,
                                    page: currentPage,
                                    size: 10,
                                    floor: floor + 1,
                                    sectorID: sector.sectorId ?? 0,
                                    difficulty: difficulty.difficulty ?? 0
                                )
                            )
                            
                            let filterdRoutes = response.result?.compactMap {
                                FilteredRoute(from: $0)
                            }
                            
                            guard let routes = filterdRoutes,
                                  let hasNextResponse = response.hasNext else {
                                Log.error("No filtered Routes", [])
                                throw AppError.networkError("No filtered Routes")
                            }
                            
                            allRoutes.append(contentsOf: routes)
                            hasNext = hasNextResponse
                            currentPage += 1
                        } catch let error {
                            Log.error("RoteSelectionReducerError", "error: \(error)")
                        }
                    }
                    
                    await send(.filteredRouteResponse(allRoutes))
                }
                
            case .filteredRouteChangeButtonTapped(let filteredRoute):
                state.selectedFilteredRoute = filteredRoute
                
                return .run { [selectedRoute = state.selectedFilteredRoute] send in
                    if let _ = selectedRoute.climeetDifficultyName,
                       let _ = selectedRoute.sectorName,
                        let _ = selectedRoute.sectorId,
                       let _ = selectedRoute.routeId {
                        await send(.delegate(.selectedRoute(selectedRoute)))
                        await send(.doneSelection)
                        print(selectedRoute)
                    }
                }
                
            case .doneSelection :
                state.isSelectionDone = true
                return .none
            
            case .inSelection:
                state.isSelectionDone = false
                return .none
            
            case .routesResponse(let gymRoutes):
                state.gymRoutes = gymRoutes
                return .none
                
            case let .filteredRouteResponse(filteredRoutes):
                state.filteredRoutesResponse = filteredRoutes
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}
