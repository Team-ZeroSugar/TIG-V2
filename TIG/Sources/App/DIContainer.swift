//
//  DIContainer.swift
//  TIG
//
//  Created by 이정동 on 8/20/24.
//

import Foundation

@Observable
final class DIContainer {
  private let storage: SwiftDataStorage
  
  private let appConfigRepository: AppConfigRepository
  private let dailyScheduleRepository: DailyScheduleRepository
  private let weeklyScheduleRepository: WeeklyScheduleRepository
  
  init() {
    self.storage = SwiftDataStorage()
    
    self.appConfigRepository = StubAppConfigRepository()
    self.dailyScheduleRepository = StubDailyScheduleRepository()
    self.weeklyScheduleRepository = StubWeeklyScheduleRepository()
  }
}
