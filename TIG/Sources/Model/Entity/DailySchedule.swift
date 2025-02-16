//
//  DailySchedule.swift
//  TIG
//
//  Created by 이정동 on 1/26/25.
//

import Foundation

struct DailySchedule {
  var date: Date
  var timeSlots: [TimeSlot]
}

struct ComparableDailySchedule: Equatable {
  var date: Date
  var timeSlots: [ComparableTimeSlot]
}

// timeSlot id 값을 제외하고 비교할 수 있게 해주는 속성
extension DailySchedule {
  var comparable: ComparableDailySchedule {
    let comparableTimeSlots = timeSlots.map { $0.comparable }
    return ComparableDailySchedule(date: date, timeSlots: comparableTimeSlots)
  }
}
