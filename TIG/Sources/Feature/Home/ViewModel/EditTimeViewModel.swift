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

  }
  
  enum Action {
    case dailyTimeSaveTapped([TimeSlot])
  }
  
  private(set) var sharedState: SharedState = DIContainer.shared.resolve()
  private(set) var state: State = .init()
  
  private let dailyScheduleRepository: DailyScheduleRepository = DIContainer.shared.resolve()
  
  func send(_ action: Action) {
    switch action {
    case .dailyTimeSaveTapped(let timeSlots):
      updateTimeSlot(date: sharedState.selectedDate, timeSlots: timeSlots)
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
    dailyScheduleRepository.updateDailySchedule(
      date: sharedState.selectedDate,
      timeSlots: timeSlots
    )
    sharedState.groupedTimeSlots = timeSlots.groupedTimeSlots
    sharedState.timeSlots = timeSlots
  }
}
