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
    
    // TODO: CurrentTime 이름으로 초단위가 아닌 Date 타입으로 저장하는 게 더 나을지 생각 필요
    var currentTimeInSeconds: Int = Date().totalSeconds
    
    var selectedDate: Date = Date().formattedDate
    
    // 탭바 상태
    var selectedTab: HomeTab = .available
    
    // 타임 슬롯 상태
    var timeSlots: [TimeSlot] = []
    var groupedTimeSlots: [GroupedTimeSlot] = []
    var currentTimeSlot: GroupedTimeSlot {
      self.groupedTimeSlots.currentTimeSlot
    }
  }
  
  enum Action {
    case onAppear
    case onDisappear
    
    // 주간 캘린더 액션
    case selectDate(Date)
    
    // 탭바 액션
    case changeTab(HomeTab)
    
    // 시간 수정 액션
    case dailyTimeSaveTapped([TimeSlot])
  }
  
  private(set) var sharedState: SharedState = DIContainer.shared.resolve()
  private(set) var state: State = .init()
  
  private let dailyScheduleRepository: DailyScheduleRepository = DIContainer.shared.resolve()
  private let weeklyScheduleRepository: WeeklyScheduleRepository = DIContainer.shared.resolve()
  private let appConfigRepository: AppConfigRepository = DIContainer.shared.resolve()
  
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      // TODO: 첫 진입 시에만 호출되도록 수정 필요할 듯
      initializeTimeSlot(date: state.selectedDate)
      handleTimer()
    case .onDisappear:
      stopTimer()
      
    case .selectDate(let date):
      state.selectedDate = date.formattedDate
      initializeTimeSlot(date: date)
      handleTimer()
      
    case .changeTab(let tab):
      state.selectedTab = tab
      
    case .dailyTimeSaveTapped(let timeSlots):
      updateTimeSlot(date: state.selectedDate, timeSlots: timeSlots)
    }
  }
}

// MARK: - Timer Function
private extension HomeViewModel {
  /// 타이머를 조작합니다.
  /// 현재 선택된 날짜가 오늘 날짜인 경우에만 타이머를 실행하고 그 외 날짜는 타이머 동작을 멈춥니다.
  func handleTimer() {
    if state.selectedDate.isToday { startTimer() }
    else { stopTimer() }
  }
  
  func startTimer() {
    state.timerCancellable = Timer
      .publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink(receiveValue: { [weak self] now in
        // 현재 시간(초) 업데이트
        self?.state.currentTimeInSeconds = now.totalSeconds
        
        // 현재 선택된 날짜가 타이머 날짜(현재 날짜)와 일치하지 않는 경우 -> 다음날로 넘어가는 시점
        if self?.state.selectedDate != now.formattedDate {
          // 타임슬롯 초기화(업데이트)
          self?.initializeTimeSlot(date: now)
          
          // 현재 선택된 날짜 업데이트
          self?.state.selectedDate = now.formattedDate
        }
      })
  }
  
  func stopTimer() {
    state.timerCancellable?.cancel()
  }
}

// MARK: - TimeSlot Function
private extension HomeViewModel {
  /// 특정 날짜에 맞는 TimeSlots로 상태를 초기화 합니다.
  /// - Parameter date: 날짜
  func initializeTimeSlot(date: Date) {
    
    let result = fetchDailySchedule(date: date)
    switch result {
    case .success(let dailySchedule):
      state.timeSlots = dailySchedule.timeSlots
      state.groupedTimeSlots = state.timeSlots.groupedTimeSlots
    case .failure:
      break
    }
  }
  
  /// DB에서 해당 날짜에 맞는 DailySchedule을 가져옵니다.
  /// 없는 경우, WeeklySchedule 또는 수면 시간 기준으로 생성합니다.
  /// - Parameter date: 불러올 날짜
  /// - Returns: DailySchedule
  func fetchDailySchedule(date: Date) -> Result<DailySchedule, Error> {
    // 1. DailySchedule이 있으면 바로 반환
    switch dailyScheduleRepository.fetchDailySchedule(date: date) {
    case .success(let dailySchedule):
      if let dailySchedule {
        return .success(dailySchedule)
      }
      
    case .failure(let error):
      return .failure(error)
    }
    
    // 2. 설정된 WeeklySchedule로 DailySchedule 불러오기
    let weekDay = WeekDay(rawValue: date.weekday - 1)!
    switch weeklyScheduleRepository.fetchWeeklySchedule(weekDay: weekDay) {
    case .success(let weeklySchedule):
      if let weeklySchedule {
        let dailySchedule = DailySchedule(
          date: date.formattedDate,
          timeSlots: weeklySchedule.timeSlots
        )
        
        // 오늘 날짜의 dailySchedule인 경우 저장
        if date.isToday {
          dailyScheduleRepository.createDailySchedule(dailySchedule)
        }
        
        return .success(dailySchedule)
      }
      
    case .failure(let error):
      return .failure(error)
    }
    
    // 3. 설정된 수면 시간 기준으로 DailySchedule 불러오기
    do {
      let wakeup = try appConfigRepository.fetchWakeupTime().get()
      let bed = try appConfigRepository.fetchBedTime().get()
      
      let timeSlots = stride(from: 0, to: Time.hour * 24, by: Time.interval).map {
        TimeSlot(
          start: $0,
          end: $0 + Time.interval,
          isAvailable: wakeup <= $0 && $0 < bed
        )
      }
      
      // 오늘 날짜의 dailySchedule인 경우 저장
      let dailySchedule = DailySchedule(date: date.formattedDate, timeSlots: timeSlots)
      if date.isToday {
        dailyScheduleRepository.createDailySchedule(dailySchedule)
      }
      
      return .success(dailySchedule)
      
    } catch {
      return .failure(error)
    }
  }
  
  /// TimeSlots을 업데이트 합니다.
  /// - Parameters:
  ///   - date: 업데이트할 날짜.
  ///   - timeSlots: 해당 일정에 적용할 `TimeSlot` 배열.
  func updateTimeSlot(date: Date, timeSlots: [TimeSlot]) {
    dailyScheduleRepository.updateDailySchedule(
      date: state.selectedDate,
      timeSlots: timeSlots
    )
    state.groupedTimeSlots = timeSlots.groupedTimeSlots
    state.timeSlots = timeSlots
  }
}
