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
