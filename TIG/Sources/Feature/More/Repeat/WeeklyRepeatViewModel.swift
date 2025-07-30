//
//  WeeklyRepeatViewModel.swift
//  TIG
//
//  Created by 신승재 on 4/26/25.
//

import Foundation

@Observable
final class WeeklyRepeatViewModel {
  
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
    
    // WeeklyRepeatView
    case onAppear
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
      
    case .onAppear:
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
private extension WeeklyRepeatViewModel {
  /// WeeklyTimeSlots 데이터를 기본 상태로 초기화합니다.
  func initializeWeeklyTimeSlots() {
    
    do {
      let wakeup = try appConfigRepository.fetchWakeupTime().get()
      let bed = try appConfigRepository.fetchBedTime().get()
      let timeSlots = TimeSlot.generate(wakeup: wakeup, bed: bed)
      
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
    // 1. WeeklySchedule 업데이트
    state.weeklyTimeSlots.forEach { weekDay, timeSlots in
      weeklyScheduleRepository.updateWeeklySchedule(
        weekDay: weekDay, timeSlots: timeSlots
      )
      
      // 2. timeSlots이 요일에 해당된다면 업데이트
      if state.selectedDate.weekday - 1 == weekDay.rawValue {
        state.timeSlots = timeSlots
      }
      
      do {
        // 3. 오늘 이후에 해당되는 dailySchedule만 업데이트
        let dailySchedules = try dailyScheduleRepository.fetchAllDailySchedules().get()
        dailySchedules
          .filter { $0.date >= .now.formattedDate }
          .forEach {
            dailyScheduleRepository.updateDailySchedule(date: $0.date, timeSlots: $0.timeSlots)
          }
        
      } catch {
        print(error)
      }
    }
  }
}
