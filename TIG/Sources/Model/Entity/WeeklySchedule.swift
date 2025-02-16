//
//  WeeklySchedule.swift
//  TIG
//
//  Created by 이정동 on 1/26/25.
//

import Foundation

struct WeeklySchedule {
  var day: WeekDay
  var timeSlots: [TimeSlot]
}

struct ComparableWeeklySchedule {
  var day: WeekDay
  var comparableTimeSlots: [ComparableTimeSlot]
}

// timeSlot id 값을 제외하고 비교할 수 있게 해주는 속성
extension WeeklySchedule {
  var comparable: ComparableWeeklySchedule {
    let comparableTimeSlots = timeSlots.map { $0.comparable }
    return ComparableWeeklySchedule(
      day: day,
      comparableTimeSlots: comparableTimeSlots
    )
  }
}
