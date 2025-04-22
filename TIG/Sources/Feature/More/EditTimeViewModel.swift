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

  }
  
  enum Action {
    case dailyTimeSaveTapped([TimeSlot])
  }
  
  private(set) var state: State = .init(
    sharedState: DIContainer.shared.resolve()
  )
  
  private let dailyScheduleRepository: DailyScheduleRepository = DIContainer.shared.resolve()
  
  func send(_ action: Action) {
    switch action {
    case .dailyTimeSaveTapped(let timeSlots):
      updateTimeSlot(date: state.selectedDate, timeSlots: timeSlots)
    }
  }
}

// MARK: - Function
private extension EditTimeViewModel {
  /// TimeSlots을 업데이트 합니다.
  /// - Parameters:
  ///   - date: 업데이트할 날짜.
  ///   - timeSlots: 해당 일정에 적용할 `TimeSlot` 배열.
  func updateTimeSlot(date: Date, timeSlots: [TimeSlot]) {
    switch dailyScheduleRepository.fetchDailySchedule(date: date) {
    case .success(let dailySchedule):
      if let dailySchedule {
        // 1. 기존에 데이터가 있을 경우, Update
        dailyScheduleRepository.updateDailySchedule(
          date: date, timeSlots: timeSlots
        )
      } else {
        // 2. 없을 경우, Create
        dailyScheduleRepository.createDailySchedule(
          DailySchedule(date: date, timeSlots: timeSlots)
        )
      }
      state.timeSlots = timeSlots
    case .failure:
      return
    }
    
  }
}
