//
//  TimeSlotDTO.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

typealias TimeSlotDTO = SchemaV2.TimeSlotDTO

extension SchemaV2 {
  @Model
  final class TimeSlotDTO {
    var start: Date
    var end: Date
    var isAvailable: Bool
    
    init(start: Date, end: Date, isAvailable: Bool) {
      self.start = start
      self.end = end
      self.isAvailable = isAvailable
    }
  }
}
