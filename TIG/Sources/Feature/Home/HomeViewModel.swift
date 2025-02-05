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
    // 주간 캘린더 상태
    var weekSlider: [[Date.WeekDay]] = []
    var currentDate: Date = Date().formattedDate
    var currentWeekIndex: Int = 1
    
    // 탭바 상태
    var selectedTab: HomeTab = .available
  }
  
  enum Action {
    // 주간 캘린더 액션
    case selectDate(Date)
    
    // 탭바 액션
    case tabChange(HomeTab)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .selectDate(let date):
      state.currentDate = date
    case .tabChange(let tab):
      state.selectedTab = tab
    }
  }
}

// MARK: - Function
extension HomeViewModel {
  
}

