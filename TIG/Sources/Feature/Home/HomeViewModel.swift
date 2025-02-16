//
//  HomeViewModel.swift
//  TIG
//
//  Created by 이정동 on 2/4/25.
//

import Foundation
import Combine

@Observable
final class HomeViewModel {
  struct State {
    var timerCancellable: Cancellable?
    var currentTimeInSeconds: Int = 0
    
    // 주간 캘린더 상태
    var weekSlider: [[Date.WeekDay]] = []
    var currentDate: Date = Date().formattedDate
    
    // 탭바 상태
    var selectedTab: HomeTab = .available
    
    // 타임 슬롯 상태
    var timeSlots: [TimeSlot] = []
    var groupedTimeSlots: [GroupedTimeSlot] = []
    var currentTimeSlot: GroupedTimeSlot = .init(start: 0, end: 0, isAvailable: false, count: 0)
  }
  
  enum Action {
    case onAppear
    case onDisappear
    
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
      startTimer()
      initializeTimeSlot()
      
    case .onDisappear:
      stopTimer()
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

// MARK: - Timer Function
private extension HomeViewModel {
  func startTimer() {
    state.timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink(receiveValue: { [weak self] date in
        self?.state.currentTimeInSeconds = date.totalSeconds
      })
  }
  
  func stopTimer() {
    state.timerCancellable?.cancel()
  }
}

// MARK: - Weekly Calendar Function
private extension HomeViewModel {
  /// 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음을 생성
  /// - Parameter date: 기준이 되는 날짜
  /// - Returns: 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음
  func generateWeekSlider(anchor date: Date = .now) -> [[Date.WeekDay]] {
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
  func paginateWeek(currentIndex: Int) {
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

// MARK: - TimeSlotFunction
private extension HomeViewModel {
  /// State 내에 정의된 TimeSlot 변수들을 초기화 합니다
  func initializeTimeSlot() {
    state.timeSlots = TimeSlot.mock
    state.groupedTimeSlots = state.timeSlots.groupedTimeSlot
    state.currentTimeSlot = getCurrentGroupedTimeSlot()
  }
  
  /// 현재 시간대에 위치한 그룹화된 TimeSlot을 가져옵니다
  /// - Returns: 현재 시간대에 위치한 GroupedTimeSlot
  func getCurrentGroupedTimeSlot() -> GroupedTimeSlot {
    let now = Date()
    let totalSeconds = now.totalSeconds
    return state.groupedTimeSlots.first(where: {
      $0.start <= totalSeconds && $0.end > totalSeconds
    })!
  }
}
