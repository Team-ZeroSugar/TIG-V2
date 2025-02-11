//
//  StubDailyScheduleRepository.swift
//  TIG
//
//  Created by 이정동 on 1/31/25.
//

import Foundation

final class StubDailyScheduleRepository: DailyScheduleRepository {
  private var dailySchedules: [DailySchedule] = []
  
  func createDailySchedule(_ dailySchedule: DailySchedule) {
    dailySchedules.append(dailySchedule)
  }
  
  func fetchAllDailySchedules() -> Result<[DailySchedule], any Error> {
    .success(dailySchedules)
  }
  
  func fetchDailySchedule(date: Date) -> Result<DailySchedule?, any Error> {
    let schedule = dailySchedules.first { $0.date == date }
    return .success(schedule)
  }
  
  func updateDailySchedule(
    dailySchedule: DailySchedule,
    timeSlots: [TimeSlot]
  ) {
    if let index = dailySchedules.firstIndex(
      where: { $0.date == dailySchedule.date }
    ) {
      var updatedSchedule = dailySchedules[index]
      updatedSchedule.timeSlots = timeSlots
      dailySchedules[index] = updatedSchedule
    }
  }
  
  func deleteDailySchedule(_ dailySchedule: DailySchedule) {
    if let index = dailySchedules.firstIndex(
      where: { $0.date == dailySchedule.date }
    ) {
      dailySchedules.remove(at: index)
    }
  }
}
