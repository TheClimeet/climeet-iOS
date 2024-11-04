//
//  ActivityTimerReducer.swift
//  Climeet-iOS
//
//  Created by KOVI on 10/22/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActivityTimerReducer {
    @Reducer
    enum Destination {
        case searchGymSheet(SearchReducer)
    }
    
    @ObservableState
    struct State {
        var screenSize = CGSize(width: 0, height: 0)
        var bottomSheetHeight: CGFloat = 0.0
        var selectedGym = Gym()
        var elapsedTime: String = "00:00:0"
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case gymSelectionButtonTapped
        case startButtonTapped
        case pauseButtonTapped
        case resetButtonTapped
        case timerTask
        case timeChanged(TimeInterval)
        case readViewSize(CGSize)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @ObservationIgnored @Dependency(\.timerClient) private var timerClient
    private enum TimerTaskID { case timer }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .gymSelectionButtonTapped:
                state.bottomSheetHeight = state.screenSize.height *
                SheetType.search.displaySizeRatio
                
                let reducerState = SearchReducer.State(
                    transitionType: .modal
                )
                state.destination = .searchGymSheet(reducerState)
                
                return .none
                
            case .startButtonTapped:
                return .run { send in
                    await timerClient.startTimer()
                    await send(.timerTask)
                }

            case .pauseButtonTapped:
                return .run { send in
                    timerClient.pauseTimer()
                }
                
            case .resetButtonTapped:
                return .run { send in
                    timerClient.resetTimer()
                }
                
            case .timerTask:
                return .run { send in
                    for await time in timerClient.timerSequence {
                        await send(.timeChanged(time))
                    }
                }
                .cancellable(id: TimerTaskID.timer)
                
            case .timeChanged(let timeInterval):
                state.elapsedTime = formattedTime(timeInterval)
                
                return .none
                
            case .readViewSize(let size):
                state.screenSize = size
                
                return .none
                
            case let .destination(.presented(.searchGymSheet(.delegate(.selectGym(gym))))):
                state.selectedGym = gym
                
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ActivityTimerReducer {
    func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let tenths = Int((timeInterval * 10).truncatingRemainder(dividingBy: 10))
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}
