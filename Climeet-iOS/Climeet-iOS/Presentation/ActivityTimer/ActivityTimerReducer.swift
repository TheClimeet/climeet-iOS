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
    @ObservableState
    struct State {
        var selectedGym: Gym?
        var elapsedTime: String = "00:00:0"
    }
    
    enum Action {
        case gymSelectionButtonTapped
        case gymSet(Gym)
        case startButtonTapped
        case pauseButtonTapped
        case resetButtonTapped
        case timerTask
        case timeChanged(TimeInterval)
    }
    
    @ObservationIgnored @Dependency(\.timerClient) private var timerClient
    private enum TimerTaskID { case timer }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .gymSelectionButtonTapped:
                return .none
                
            case .gymSet(let gym):
                state.selectedGym = gym
                
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
            }
        }
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
