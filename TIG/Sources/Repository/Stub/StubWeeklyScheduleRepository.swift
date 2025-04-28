//
//  StubWeeklyScheduleRepository.swift
//  TIG
//
//  Created by 이정동 on 1/31/25.
//

import Foundation

final class StubWeeklyScheduleRepository: WeeklyScheduleRepository {
  private var weeklySchedules: [WeeklySchedule] = []
  
  func initializeWeeklySchedules(timeSlots: [TimeSlot]) {
    WeekDay.allCases.forEach { day in
      let schedule = WeeklySchedule(day: day, timeSlots: timeSlots)
      weeklySchedules.append(schedule)
    }
  }
  
  func fetchAllWeeklySchedules() -> Result<[WeeklySchedule], any Error> {
    .success(weeklySchedules)
  }
  
  func fetchWeeklySchedule(
    weekDay: WeekDay
  ) -> Result<WeeklySchedule?, any Error> {
    let schedule = weeklySchedules.first { $0.day == weekDay }
    return .success(schedule)
  }
  
  func updateWeeklySchedule(
    weekDay: WeekDay,
    timeSlots: [TimeSlot]
  ) {
    if let index = weeklySchedules.firstIndex(
      where: { $0.day == weekDay }
    ) {
      var schedule = weeklySchedules[index]
      schedule.timeSlots = timeSlots
      weeklySchedules[index] = schedule
    }
  }
}
