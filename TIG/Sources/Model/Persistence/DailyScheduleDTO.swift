//
//  DailySchedule.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

typealias DailyScheduleDTO = SchemaV2.DailyScheduleDTO

extension SchemaV2 {
  @Model
  final class DailyScheduleDTO {
    var date: Date
    
    @Relationship(deleteRule: .cascade)
    var timeSlots: [TimeSlotDTO]
    
    init(date: Date, timeSlots: [TimeSlotDTO]) {
      self.date = date
      self.timeSlots = timeSlots
    }
    
    convenience init(_ data: DailySchedule) {
      self.init(
        date: data.date,
        timeSlots: data.timeSlots.map {
          TimeSlotDTO($0)
        }
      )
    }
    
    func toEntity() -> DailySchedule {
      return DailySchedule(
        date: self.date,
        timeSlots: self.timeSlots
          .map { $0.toEntity() }
          .sorted { $0.start < $1.start }
      )
    }
  }
}

