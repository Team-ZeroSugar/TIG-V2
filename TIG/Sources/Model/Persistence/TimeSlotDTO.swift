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
    var id: String
    var start: Int
    var end: Int
    var isAvailable: Bool
    
    init(id: String, start: Int, end: Int, isAvailable: Bool) {
      self.id = id
      self.start = start
      self.end = end
      self.isAvailable = isAvailable
    }
    
    convenience init(_ data: TimeSlot) {
      self.init(
        id: data.id,
        start: data.start,
        end: data.end,
        isAvailable: data.isAvailable
      )
    }
    
    func toEntity() -> TimeSlot {
      return TimeSlot(
        start: self.start,
        end: self.end,
        isAvailable: self.isAvailable
      )
    }
  }
}
