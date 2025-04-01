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
    
    // TODO: CurrentTime 이름으로 초단위가 아닌 Date 타입으로 저장해보기
    var currentTimeInSeconds: Int = Date().totalSeconds
    
    // TODO: SelectedDate로 네이밍 수정
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
    
    // 탭바 액션
    case changeTab(HomeTab)
  }
  
  private(set) var state: State = .init()
  
  // TODO: 외부 주입 필요
  private let dailyScheduleRepository: DailyScheduleRepository = StubDailyScheduleRepository()
  private let weeklyScheduleRepository: WeeklyScheduleRepository = StubWeeklyScheduleRepository()
  private let appConfigRepository: AppConfigRepository = StubAppConfigRepository()
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      // TODO: 첫 진입 시에만 호출되도록 수정 필요할 듯
      handleTimer()
      initializeTimeSlot(date: state.currentDate)
    case .onDisappear:
      stopTimer()
      
    case .selectDate(let date):
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
  
  func processTimerTask(date: Date) {
    // 현재 시간(초) 업데이트
    state.currentTimeInSeconds = date.totalSeconds
    
    // 다음 날짜로 넘어가는 시점인 경우 TimeSlot 업데이트
    if state.currentDate != date.formattedDate {
      initializeTimeSlot(date: date)
      
      // 현재 선택된 날짜 업데이트
      state.currentDate = date.formattedDate
    } else {
      // 현재 위치한 TimeSlot만 업데이트
      state.currentTimeSlot = getCurrentGroupedTimeSlot()
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
        let dailySchedule = DailySchedule(
          date: date.formattedDate,
          timeSlots: weekdaySchedule.timeSlots
        )
        
        // getDailySchedule()을 통해 선택된 날짜에 대한 DailySchedule이 없는 경우 이 메서드를 실행하게 됨
        // 이때 DailySchedule을 불러오는 날짜가 오늘 날짜인 경우 DailySchedule 저장
        if date.isToday {
          dailyScheduleRepository.createDailySchedule(dailySchedule)
        }
        
        return .success(dailySchedule)
      } else {
        return getDailyScheduleFromSleepTime(date: date)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  /// 수면 시간에 맞춘 DailySchedule을 불러옵니다.
  /// - Returns: DailySchedule
  func getDailyScheduleFromSleepTime(date: Date) -> Result<DailySchedule, Error> {
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
      
      // getDailySchedule()을 통해 선택된 날짜에 대한 DailySchedule이 없는 경우와
      // 주간 반복 데이터가 없는 경우 이 메서드를 실행하게 됨
      // 이때 DailySchedule을 불러오는 날짜가 오늘 날짜인 경우 DailySchedule 저장
      let dailySchedule = DailySchedule(date: date.formattedDate, timeSlots: timeSlots)
      if date.isToday {
        dailyScheduleRepository.createDailySchedule(dailySchedule)
      }
      
      return .success(dailySchedule)
    } catch {
      return .failure(error)
    }
  }
  
  /// 현재 시간대에 위치한 그룹화된 TimeSlot을 가져옵니다
  /// - Returns: 현재 시간대에 위치한 GroupedTimeSlot
  func getCurrentGroupedTimeSlot() -> GroupedTimeSlot {
    // TODO: 오늘 날짜가 아닌 경우에 대한 생각 필요
    // currentGroupedTimeSlot 대신 index로 대체 후 오늘 날짜가 아닌 경우 -1로 저장 등등
    let now = Date()
    let totalSeconds = now.totalSeconds
    
    return state.groupedTimeSlots.first(where: {
      $0.start <= totalSeconds && $0.end > totalSeconds
    })!
  }
}
