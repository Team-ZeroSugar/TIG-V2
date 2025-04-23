//
//  EditTimeViewModel.swift
//  TIG
//
//  Created by 신승재 on 4/15/25.
//

import Foundation

@Observable
final class EditTimeViewModel {
  
  struct State {
    
    private let sharedState: SharedState
    
    init(sharedState: SharedState) {
      self.sharedState = sharedState
    }
    
    var selectedDate: Date {
      get { sharedState.selectedDate }
      set { sharedState.selectedDate = newValue.formattedDate }
    }
    
    var timeSlots: [TimeSlot] {
      get { sharedState.timeSlots }
      set { sharedState.timeSlots = newValue }
    }
    
    var weeklyTimeSlots: [WeekDay: [TimeSlot]] = [:]
  }
  
  enum Action {
    // EditTimeView
    case dailyTimeSaveTapped([TimeSlot])
    
    // WeeklyRepeatView
    case onAppearWeeklyRepeat
    case onChangeWeeklyTimeSlot(WeekDay, [TimeSlot])
    case weeklyTimeSaveTapped
    
    // AnnounceView
    case settingButtonTapped
  }
  
  private(set) var state: State = .init(
    sharedState: DIContainer.shared.resolve()
  )
  
  private let appConfigRepository: AppConfigRepository = DIContainer.shared.resolve()
  private let dailyScheduleRepository: DailyScheduleRepository = DIContainer.shared.resolve()
  private let weeklyScheduleRepository: WeeklyScheduleRepository = DIContainer.shared.resolve()
  
  func send(_ action: Action) {
    switch action {
    case .dailyTimeSaveTapped(let timeSlots):
      updateDailyTimeSlot(date: state.selectedDate, timeSlots: timeSlots)
      
    case .onAppearWeeklyRepeat:
      fetchWeeklyTimeSlots()
      
    case .onChangeWeeklyTimeSlot(let day, let timeSlots):
      state.weeklyTimeSlots[day] = timeSlots
      
    case .weeklyTimeSaveTapped:
      updateWeeklyTimeSlots()
    
    case .settingButtonTapped:
      initializeWeeklyTimeSlots()
    }
  }
}

// MARK: - Function
private extension EditTimeViewModel {
  /// WeeklyTimeSlots 데이터를 기본 상태로 초기화합니다.
  func initializeWeeklyTimeSlots() {
    
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
      
      weeklyScheduleRepository.initializeWeeklySchedules(timeSlots: timeSlots)
      WeekDay.allCases.forEach { state.weeklyTimeSlots[$0] = timeSlots }
    } catch {
      print(error)
    }
  }
  
  /// 각 요일에 해당하는 TimeSlot 데이터를 불러옵니다.
  func fetchWeeklyTimeSlots() {
    let result = weeklyScheduleRepository.fetchAllWeeklySchedules()
    switch result {
    case .success(let weeklySchedules):
      weeklySchedules.forEach { state.weeklyTimeSlots[$0.day] = $0.timeSlots }
    case .failure(let error):
      print(error)
    }
  }
  
  
  /// WeeklyTimeSlots을 업데이트 합니다.
  func updateWeeklyTimeSlots() {
    state.weeklyTimeSlots.forEach {
      weeklyScheduleRepository.updateWeeklySchedule(
        weekDay: $0.key, timeSlots: $0.value
      )
    }
  }
  
  
  /// DailyTimeSlots을 업데이트 합니다.
  /// - Parameters:
  ///   - date: 업데이트할 날짜.
  ///   - timeSlots: 해당 일정에 적용할 `TimeSlot` 배열.
  func updateDailyTimeSlot(date: Date, timeSlots: [TimeSlot]) {
    switch dailyScheduleRepository.fetchDailySchedule(date: date) {
    case .success(let dailySchedule):
      if let dailySchedule {
        // 1. 기존에 데이터가 있을 경우, Update
        dailyScheduleRepository.updateDailySchedule(
          date: dailySchedule.date, timeSlots: timeSlots
        )
      } else {
        // 2. 없을 경우, Create
        dailyScheduleRepository.createDailySchedule(
          DailySchedule(date: date, timeSlots: timeSlots)
        )
      }
      state.timeSlots = timeSlots
    case .failure(let error):
      print(error)
    }
  }
}
