//
//  ShortsGymRoutesReducer.swift
//  Climeet-iOS
//
//  Created by mac on 11/25/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ShortsGymRoutesReducer {
    @ObservableState
    struct State {
        var selectedGym: Gym?
        var gymRoutes: GymRoutes?
        var filteredRoute: FilteredRoute?
        var routeSelector = RouteSelectionReducer.State()
        var isSelectionDone: Bool = false
    }
    
    enum Action: BindableAction {
        case routeSelector(RouteSelectionReducer.Action)
        case doneSelection
        case inSelection
        case saveRoute(FilteredRoute)
        
        case binding(BindingAction<State>)
        case delegate(Delegation)
        enum Delegation {
            case selectedRoute(FilteredRoute)
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.routeSelector, action: \.routeSelector) {
                RouteSelectionReducer()
            }
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            
            case .routeSelector(.floorChangeSegmentedControlTapped),
                    .routeSelector(.sectorChangeButtonTapped),
                    .routeSelector(.difficultyChangeButtonTapped):
                return .run { send in
                    await send(.inSelection)
                }
                
            case  .routeSelector(.filteredRouteChangeButtonTapped(let filteredRoute)):
                return .run { send in
                    if let _ = filteredRoute.climeetDifficultyName,
                       let _ = filteredRoute.sectorName,
                        let _ = filteredRoute.sectorId,
                       let _ = filteredRoute.routeId {
                        await send(.saveRoute(filteredRoute))
                        await send(.doneSelection)
                    }
                }
                
            case .saveRoute(let route):
                state.filteredRoute = route
                
                return .run { send in
                    await send(.delegate(.selectedRoute(route)))
                }
                
            case .inSelection:
                state.isSelectionDone = false
                return .none
                
            case .doneSelection :
                state.isSelectionDone = true
                return .none
                
            case .binding(_):
                return .none
                
            default:
                return .none
            }
        }
    }
}

