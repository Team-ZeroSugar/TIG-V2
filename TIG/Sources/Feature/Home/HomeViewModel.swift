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
    
    // 탭바 상태
    var selectedTab: HomeTab = .available
  }
  
  enum Action {
    case onAppear
    
    // 주간 캘린더 액션
    case selectDate(Date)
    case moveWeekPeriod(to: Int)
    
    // 탭바 액션
    case tabChange(HomeTab)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      if state.weekSlider.isEmpty {
        initializeWeekSlider()
      }
    case .moveWeekPeriod(let index):
      if state.weekSlider.indices.contains(index) {
        paginateWeek(currentIndex: index)
      }
    case .selectDate(let date):
      state.currentDate = date
    case .tabChange(let tab):
      state.selectedTab = tab
    }
  }
}

// MARK: - Function
extension HomeViewModel {
  /// 오늘 날짜 기준 이전 주, 이번 주, 다음 주 데이터로 초기화
  private func initializeWeekSlider() {
    let currentWeek = Date().weekOfDate
    
    if let firstDate = currentWeek.first?.date {
      state.weekSlider.append(firstDate.createPreviousWeek())
    }
    
    state.weekSlider.append(currentWeek)
    
    if let lastDate = currentWeek.last?.date {
      state.weekSlider.append(lastDate.createNextWeek())
    }
  }
  
  private func paginateWeek(currentIndex: Int) {
    if let firstDate = state.weekSlider[currentIndex].first?.date,
       currentIndex == 0 {
      state.weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
      state.weekSlider.removeLast()
    }
    
    if let lastDate = state.weekSlider[currentIndex].last?.date,
       currentIndex == (state.weekSlider.count - 1) {
      state.weekSlider.append(lastDate.createNextWeek())
      state.weekSlider.removeFirst()
    }
  }
}

