//
//  TimeSlot.swift
//  TIG
//
//  Created by 이정동 on 1/26/25.
//

import Foundation

struct TimeSlot: Equatable {
  var id: String = UUID().uuidString
  var start: Int
  var end: Int
  var isAvailable: Bool
  
  static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
      return lhs.start == rhs.start &&
             lhs.end == rhs.end &&
             lhs.isAvailable == rhs.isAvailable
  }
}
