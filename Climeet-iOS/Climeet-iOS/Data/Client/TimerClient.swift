//
//  TimerClient.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/1/24.
//

import Foundation
import Dependencies

final class TimerClient: DependencyKey {
    static var liveValue: TimerClient = .init()
    
    private var timer: Timer?
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    private var isPaused: Bool = false
    private var continuation: AsyncStream<TimeInterval>.Continuation?
    
    private var elapsedTime: TimeInterval {
        guard let startTime else { return .zero }
        return Date().timeIntervalSince(startTime)
    }
    
    var timerSequence: AsyncStream<TimeInterval> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    @MainActor
    func startTimer() {
        print("#1 mainThread? = \(Thread.isMainThread)")
        guard timer == nil else {
            print("타이머가 이미 작동중")
            return
        }
        
        if isPaused {
            startTime = Date().addingTimeInterval(-pausedTime)
            isPaused = false
        } else {
            startTime = Date()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.continuation?.yield(self.elapsedTime)
        })
    }
    
    func pauseTimer() {
        guard let startTime,
              !isPaused else {
            print("타이머가 작동중이지 않거나, 이미 정지됨.")
            return
        }
        
        pausedTime = Date().timeIntervalSince(startTime)
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        pausedTime = 0
        isPaused = false
        continuation?.yield(.zero)
    }
}

extension DependencyValues {
    var timerClient: TimerClient {
        get { self[TimerClient.self] }
        set { self[TimerClient.self] = newValue }
    }
}
