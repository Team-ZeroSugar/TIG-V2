//
//  TimerViewModel.swift
//  TIG
//
//  Created by 신승재 on 4/15/25.
//

import Foundation
import Combine

@Observable
final class TimerViewModel {
  struct State {
    var timerCancellable: Cancellable?
    
    // TODO: CurrentTime 이름으로 초단위가 아닌 Date 타입으로 저장하는 게 더 나을지 생각 필요
    var currentTimeInSeconds: Int = Date().totalSeconds
  }
  
  enum Action {
    case onAppear
    case onDisappear
  }
  
  private(set) var sharedState: SharedState = DIContainer.shared.resolve()
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      startTimer()
    case .onDisappear:
      stopTimer()
    }
  }
}

// MARK: - Timer Function
private extension TimerViewModel {
  func startTimer() {
    state.timerCancellable = Timer
      .publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink(receiveValue: { [weak self] now in
        self?.state.currentTimeInSeconds = now.totalSeconds
      })
  }
  
  func stopTimer() {
    state.timerCancellable?.cancel()
  }
}
