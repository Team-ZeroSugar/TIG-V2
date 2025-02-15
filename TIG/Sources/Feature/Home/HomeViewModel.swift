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
    
    // 타임 슬롯 상태
    var timeSlots: [TimeSlot] = TimeSlot.mock
  }
  
  enum Action {
    case onAppear
    
    // 주간 캘린더 액션
    case selectDate(Date)
    case moveWeekPeriod(index: Int)
    
    // 탭바 액션
    case changeTab(HomeTab)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      if state.weekSlider.isEmpty {
        state.weekSlider = generateWeekSlider()
      }
    case .moveWeekPeriod(let index):
      if state.weekSlider.indices.contains(index) {
        paginateWeek(currentIndex: index)
      }
    case .selectDate(let date):
      state.weekSlider = generateWeekSlider(anchor: date)
      state.currentDate = date.formattedDate
    case .changeTab(let tab):
      state.selectedTab = tab
    }
  }
}

// MARK: - Function
extension HomeViewModel {
  /// 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음을 생성
  /// - Parameter date: 기준이 되는 날짜
  /// - Returns: 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음
  private func generateWeekSlider(anchor date: Date = .now) -> [[Date.WeekDay]] {
    var newWeeks = [[Date.WeekDay]]()
    let anchorWeek = date.weekOfDate
    
    if let firstDate = anchorWeek.first?.date {
      newWeeks.append(firstDate.createPreviousWeek())
    }
    
    newWeeks.append(anchorWeek)
    
    if let lastDate = anchorWeek.last?.date {
      newWeeks.append(lastDate.createNextWeek())
    }
    
    return newWeeks
  }
  
  /// 현재 주간 캘린더 위치가 weekSlider의 첫번째 또는 마지막인 경우 새로 생성
  /// - Parameter currentIndex: 현재 위치한 주간 캘린더 인덱스
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

