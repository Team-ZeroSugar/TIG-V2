//
//  DailyScheduleRepositoryImpl.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

final class DailyScheduleRepositoryImpl: DailyScheduleRepository {
  
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  
  func createDailySchedule(_ dailySchedule: DailySchedule) {
    print("Impl:", #function)
    
    let result = findDailySchedule(dailySchedule)
    switch result {
    case .success:
      print(SwiftDataError.modelAlreadyExist)
    case .failure(.modelNotFound):
      let model = DailyScheduleDTO(dailySchedule)
      modelContext.insert(model)
    case .failure(let error):
      print(error)
    }
  }

  
  func fetchAllDailySchedules() -> Result<[DailySchedule], any Error> {
    print("Impl:", #function)
    
    let now = Date().formattedDate
    let predicate = #Predicate<DailyScheduleDTO> { $0.date >= now }
    let sort = SortDescriptor(\DailyScheduleDTO.date, order: .forward)
    let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
    
    do {
      let datas = try modelContext.fetch(descriptor)
      return .success(datas.map { $0.toEntity() })
    } catch {
      return .failure(SwiftDataError.fetchError)
    }
  }

  
  func fetchDailySchedule(date: Date) -> Result<DailySchedule?, any Error> {
    print("Impl:", #function)
    
    let predicate = #Predicate<DailyScheduleDTO> { $0.date == date }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let data = try modelContext.fetch(descriptor).first
      return .success(data?.toEntity())
    } catch {
      return .failure(SwiftDataError.fetchError)
    }
  }

  
  func updateDailySchedule(
    dailySchedule: DailySchedule,
    timeSlots: [TimeSlot]
  ) {
    print("Impl:", #function)
    
    let result = findDailySchedule(dailySchedule)
    
    switch result {
    case .success(let model):
      model.timeSlots.forEach { modelContext.delete($0) }
      model.timeSlots = timeSlots.map { TimeSlotDTO($0) }
    case .failure(let error):
      print(error)
    }
  }

  
  func deleteDailySchedule(_ dailySchedule: DailySchedule) {
    print("Impl:", #function)
    
    let result = findDailySchedule(dailySchedule)
    
    switch result {
    case .success(let model):
      modelContext.delete(model)
    case .failure(let error):
      print(error)
    }
  }

}

extension DailyScheduleRepositoryImpl {
  private func findDailySchedule(
    _ dailySchedule: DailySchedule
  ) -> Result<DailyScheduleDTO, SwiftDataError> {
    print("Impl:", #function)
    let date = dailySchedule.date
    let predicate = #Predicate<DailyScheduleDTO> { $0.date == date }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      guard let data = try modelContext.fetch(descriptor).first else {
        return .failure(.modelNotFound)
      }
      return .success(data)
    } catch {
      return .failure(.fetchError)
    }
  }
}
