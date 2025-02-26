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
    var currentTimeInSeconds: Int = Date().totalSeconds
    
    // 주간 캘린더 상태
    var weekSlider: [[Date.WeekDay]] = []
    var currentDate: Date = Date().formattedDate
    
    // 탭바 상태
    var selectedTab: HomeTab = .available
    
    // 타임 슬롯 상태
    var timeSlots: [TimeSlot] = []
    var groupedTimeSlots: [GroupedTimeSlot] = []
    var currentTimeSlot: GroupedTimeSlot = .init(start: 0, end: 0, isAvailable: false, duration: 0, count: 0)
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
      handleTimer()
      initializeTimeSlot(date: state.currentDate)
      
    case .onDisappear:
      stopTimer()
      
    case .moveWeekPeriod(let index):
      if state.weekSlider.indices.contains(index) {
        paginateWeek(currentIndex: index)
      }
      
    case .selectDate(let date):
      state.weekSlider = generateWeekSlider(anchor: date)
      state.currentDate = date.formattedDate
      handleTimer()
      initializeTimeSlot(date: date)
      
    case .changeTab(let tab):
      state.selectedTab = tab
    }
  }
}

// MARK: - Timer Function
private extension HomeViewModel {
  /// 타이머를 조작합니다.
  /// 현재 선택된 날짜가 오늘 날짜인 경우에만 타이머를 실행하고 그 외 날짜는 타이머 동작을 멈춥니다.
  func handleTimer() {
    if state.currentDate.isToday { startTimer() }
    else { stopTimer() }
  }
  
  func startTimer() {
    state.timerCancellable = Timer
      .publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink(receiveValue: { [weak self] date in
        self?.processTimerTask(date: date)
      })
  }
  
  func stopTimer() {
    state.timerCancellable?.cancel()
  }
  
  // TODO: 수정 필요
  func processTimerTask(date: Date) {
    // 현재 선택된 날짜가 현재 날짜와 다른 경우 TimeSlot 업데이트
    if state.currentDate != date.formattedDate {
      initializeTimeSlot(date: date)
    }
    
    // 현재 선택된 날짜 업데이트
    state.currentDate = date.formattedDate
    
    // 현재 시간(초) 업데이트
    let currentSeconds = date.totalSeconds
    state.currentTimeInSeconds = currentSeconds
    
    // 현재 위치한 타임 슬롯 업데이트
    guard let currentTimeSlot = state.groupedTimeSlots.first(where: {
      $0.start <= currentSeconds && currentSeconds < $0.end
    }) else { return }
    
    state.currentTimeSlot = currentTimeSlot
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

// MARK: - TimeSlot Function
private extension HomeViewModel {
  /// State 내에 정의된 TimeSlot 변수들을 초기화 합니다
  func initializeTimeSlot(date: Date) {
    // TODO: 현재 선택된 날짜에 맞춰 TimeSlot 가져오는 로직 필요
    // 1. 현재 선택된 날짜의 DailySchedule 가져오기
    // 2. 만약 없다면 WeeklySchedule을 통해 생성
    // 3. WeeklySchedule 또한 없다면 기상, 수면시간에 맞춰 생성
    // 현재는 Test
    let now = Date().formattedDate
    let mock = now == date.formattedDate ? TimeSlot.mock : TimeSlot.mock.map { TimeSlot(start: $0.start, end: $0.end, isAvailable: Bool.random()) }
    state.timeSlots = mock
    state.groupedTimeSlots = state.timeSlots.groupedTimeSlots
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
