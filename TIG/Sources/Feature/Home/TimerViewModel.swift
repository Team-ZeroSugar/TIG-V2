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
        // 현재 시간(초) 업데이트
        self?.state.currentTimeInSeconds = now.totalSeconds
        
//        // 현재 선택된 날짜가 타이머 날짜(현재 날짜)와 일치하지 않는 경우 -> 다음날로 넘어가는 시점
//        if self?.sharedState.selectedDate != now.formattedDate {
//          // 타임슬롯 초기화(업데이트)
//          self?.initializeTimeSlot(date: now)
//          
//          // 현재 선택된 날짜 업데이트
//          self?.sharedState.selectedDate = now.formattedDate
//        }
      })
  }
  
  func stopTimer() {
    state.timerCancellable?.cancel()
  }
}
