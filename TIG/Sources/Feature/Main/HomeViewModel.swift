//
//  HomeViewModel.swift
//  TIG
//
//  Created by 이정동 on 2/4/25.
//

import Foundation

@Observable
final class HomeViewModel {
  struct State {
    var selectedTab: HomeTab = .available
  }
  
  enum Action {
    case tabChange(HomeTab)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .tabChange(let tab):
      state.selectedTab = tab
    }
  }
}
