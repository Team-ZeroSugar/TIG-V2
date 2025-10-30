//
//  OnboardingViewModel.swift
//  TIG
//
//  Created by seozero on 7/30/25.
//

import Foundation

@Observable
final class OnboardingViewModel {
  struct State {
    var isWakeupMode: Bool = true
    var wakeUpTime: Int = 0
    var bedTime: Int = 0
  }
  
  enum Action {
    case setWakeUpTime(Int)
    case setBedTime(Int)
  }
  
  private(set) var state: State = .init()
  
  private let appConfigRepository: AppConfigRepository = DIContainer.shared.resolve()
  
  func send(_ action: Action) {
    switch action {
    case .setWakeUpTime(let timeString):
      state.wakeUpTime = timeString
      state.isWakeupMode = false
    case .setBedTime(let timeString):
      state.bedTime = timeString
      appConfigRepository.setOnboardingCompleted(wakeupTime: state.wakeUpTime, bedTime: state.bedTime)
    }
  }
}
