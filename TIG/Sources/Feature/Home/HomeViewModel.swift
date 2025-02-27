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
  
  private let dailyScheduleRepository: DailyScheduleRepository = StubDailyScheduleRepository()
  private let weeklyScheduleRepository: WeeklyScheduleRepository = StubWeeklyScheduleRepository()
  private let appConfigRepository: AppConfigRepository = StubAppConfigRepository()
  
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
  /// 특정 날짜에 맞는 TimeSlots로 상태를 초기화 합니다.
  /// - Parameter date: 날짜
  func initializeTimeSlot(date: Date) {
    
    let result = getDailySchedule(date: date)
    switch result {
    case .success(let dailySchedule):
      state.timeSlots = dailySchedule.timeSlots
      state.groupedTimeSlots = state.timeSlots.groupedTimeSlots
      state.currentTimeSlot = getCurrentGroupedTimeSlot()
    case .failure:
      break
    }
  }
  
  /// DB에서 해당 날짜에 맞는 DailySchedule을 가져옵니다.
  /// - Parameter date: 불러올 날짜
  /// - Returns: DailySchedule
  func getDailySchedule(date: Date) -> Result<DailySchedule, Error> {
    let result = dailyScheduleRepository.fetchDailySchedule(date: date)
    
    switch result {
    case .success(let dailySchedule):
      if let dailySchedule = dailySchedule {
        return .success(dailySchedule)
      } else {
        return getDailyScheduleFromWeeklySchedule(date: date)
      }
      
    case .failure(let error):
      return .failure(error)
    }
  }
  
  /// WeeklySchedule로부터 DailySchedule을 가져옵니다.
  /// - Parameter date: 불러올 날짜
  /// - Returns: DailySchedule
  func getDailyScheduleFromWeeklySchedule(date: Date) -> Result<DailySchedule, Error> {
    let result = weeklyScheduleRepository.fetchWeeklySchedule(weekDay: WeekDay(rawValue: date.weekday - 1)!)
    
    switch result {
    case .success(let weekdaySchedule):
      if let weekdaySchedule = weekdaySchedule {
        return .success(DailySchedule(
          date: date,
          timeSlots: weekdaySchedule.timeSlots
        ))
      } else {
        return getDailyScheduleFromSleepTime()
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  /// 수면 시간에 맞춘 DailySchedule을 불러옵니다.
  /// - Returns: DailySchedule
  func getDailyScheduleFromSleepTime() -> Result<DailySchedule, Error> {
    let wakeupTime = appConfigRepository.fetchWakeupTime()
    let bedTime = appConfigRepository.fetchBedTime()
    
    do {
      let wakeup = try wakeupTime.get()
      let bed = try bedTime.get()
      
      var timeSlots: [TimeSlot] = []
      
      for time in stride(from: 0, to: Time.hour * 24, by: Time.interval) {
        timeSlots.append(TimeSlot(
          start: time,
          end: time + Time.interval,
          isAvailable: wakeup <= time && time < bed - Time.interval ? true : false
        ))
      }
      
      return .success(DailySchedule(date: Date().formattedDate, timeSlots: timeSlots))
    } catch {
      return .failure(error)
    }
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
