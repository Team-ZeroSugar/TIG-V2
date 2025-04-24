//
//  GroupedTimeSlot.swift
//  TIG
//
//  Created by 신승재 on 4/24/25.
//

import Foundation

struct GroupedTimeSlot: Hashable {
  var start: Int
  var end: Int
  var isAvailable: Bool
  var duration: Int
  var count: Int
}

extension GroupedTimeSlot {
  static let mock = GroupedTimeSlot(
    start: 0,
    end: 0,
    isAvailable: false,
    duration: 0,
    count: 0
  )
}
