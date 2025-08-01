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
    var currentIndex: Int = 0 {
      didSet {
        if currentIndex == OnboardingContent.allCases.count - 1 {
          isFinished = true
        }
      }
    }
    var currentContent: OnboardingContent {
      OnboardingContent.allCases[currentIndex]
    }
    var isLastPage: Bool {
      currentIndex == OnboardingContent.allCases.count - 1
    }
    var isFinished: Bool = false
  }
  
  enum Action {
    case nextOnboarding
    case finishOnboarding
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .nextOnboarding:
      nextButtonTapped()
    case .finishOnboarding:
      break
    }
  }
}

extension OnboardingViewModel {
  private func nextButtonTapped() {
    if state.currentIndex < OnboardingContent.allCases.count - 1 {
      state.currentIndex += 1
    }
  }
}
