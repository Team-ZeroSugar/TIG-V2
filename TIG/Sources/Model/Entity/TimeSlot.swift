//
//  TimeSlot.swift
//  TIG
//
//  Created by 이정동 on 1/26/25.
//

import Foundation

struct TimeSlot {
  var id: String = UUID().uuidString
  var start: Int
  var end: Int
  var isAvailable: Bool
}

struct ComparableTimeSlot: Equatable {
  var start: Int
  var end: Int
  var isAvailable: Bool
}

extension TimeSlot {
  var comparable: ComparableTimeSlot {
    ComparableTimeSlot(start: start, end: end, isAvailable: isAvailable)
  }
}
