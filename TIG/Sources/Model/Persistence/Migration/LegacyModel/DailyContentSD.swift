//
//  DailyContentSD.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation
import SwiftData


extension SchemaV1 {
  @Model
  final class DailyContentSD {
    @Attribute(.unique) var date: Date
    @Relationship(deleteRule: .cascade) var timelines: [TimelineSD]
    var totalAvailabilityTime: Int
    
    init(date: Date, timelines: [TimelineSD], totalAvailabilityTime: Int) {
      self.date = date
      self.timelines = timelines
      self.totalAvailabilityTime = totalAvailabilityTime
    }
  }
}

