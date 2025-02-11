//
//  WeeklyScheduleRepositoryImpl.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

final class WeeklyScheduleRepositoryImpl: WeeklyScheduleRepository {

  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  
  func initializeWeeklySchedules() {
    print("Impl:", #function)
    
    (1...7).forEach {
      let model = WeeklyScheduleDTO(day: $0, timeSlots: [])
      modelContext.insert(model)
    }
  }

  
  func fetchAllWeeklySchedules() -> Result<[WeeklySchedule], any Error> {
    print("Impl:", #function)
    
    let sort = SortDescriptor(\WeeklyScheduleDTO.day, order: .forward)
    let descriptor = FetchDescriptor(sortBy: [sort])
    
    do {
      let datas = try modelContext.fetch(descriptor)
      return .success(datas.map { $0.toEntity() })
    } catch {
      return .failure(SwiftDataError.fetchError)
    }
    
  }

  func fetchWeeklySchedule(weekDay: WeekDay) -> Result<WeeklySchedule?, any Error> {
    print("Impl:", #function)
    
    let predicate = #Predicate<WeeklyScheduleDTO> { $0.day == weekDay.rawValue }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      return .success(data?.toEntity())
    } catch {
      return .failure(SwiftDataError.fetchError)
    }
  }

  
  func updateWeeklySchedule(
    weeklySchedule: WeeklySchedule,
    timeSlots: [TimeSlot]
  ) {
    print("Impl:", #function)
    
    let predicate = #Predicate<WeeklyScheduleDTO> { $0.day == weeklySchedule.day.rawValue }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      data?.timeSlots = timeSlots.map { TimeSlotDTO($0) }
    } catch {
      print(error)
    }
  }
}
