//
//  WeeklyRepeatViewModel.swift
//  TIG
//
//  Created by 이정동 on 2/4/25.
//

import Foundation

@Observable
final class WeeklyRepeatViewModel {
  struct State {
    var timeSlots: [TimeSlot] = []
  }
  
  enum Action {
    case onAppear
    case onDisappear
  }
  
  private(set) var state: State = .init()
  
  private let dailyScheduleRepository: DailyScheduleRepository
  private let weeklyScheduleRepository: WeeklyScheduleRepository
  private let appConfigRepository: AppConfigRepository
  
  init(
    dailyScheduleRepository: DailyScheduleRepository = StubDailyScheduleRepository(),
    weeklyScheduleRepository: WeeklyScheduleRepository = StubWeeklyScheduleRepository(),
    appconfigRepository: AppConfigRepository = StubAppConfigRepository()
  ) {
    self.dailyScheduleRepository = dailyScheduleRepository
    self.weeklyScheduleRepository = weeklyScheduleRepository
    self.appConfigRepository = appconfigRepository
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      print("onAppear")
    case .onDisappear:
      print("onDisappear")
    }
  }
}



// MARK: - TimeSlot Function
private extension WeeklyRepeatViewModel {
  
}
