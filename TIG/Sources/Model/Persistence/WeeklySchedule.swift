//
//  WeeklySchedule.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

typealias WeeklyScheduleDTO = SchemaV2.WeeklyScheduleDTO

extension SchemaV2 {
  @Model
  final class WeeklyScheduleDTO {
    var day: Int
    var timeSlots: [TimeSlotDTO]
    
    init(day: Int, timeSlots: [TimeSlotDTO]) {
      self.day = day
      self.timeSlots = timeSlots
    }
  }
}
