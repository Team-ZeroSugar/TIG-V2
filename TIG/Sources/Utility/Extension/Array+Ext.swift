//
//  Array+Ext.swift
//  TIG
//
//  Created by 이정동 on 2/15/25.
//

import Foundation

extension Array where Element == TimeSlot {
  var groupedTimeSlots: [GroupedTimeSlot] {
    var result: [GroupedTimeSlot] = []
    
    if self.isEmpty { return result }
    
    var currentIsAvailable = self[0].isAvailable
    var currentCount = 1
    var currentStart = self[0].start
    var currentEnd = self[0].end
    
    for index in 1..<self.count {
      if self[index].isAvailable == currentIsAvailable {
        currentCount += 1
        currentEnd = self[index].end
      } else {
        result.append(GroupedTimeSlot(
          start: currentStart,
          end: currentEnd,
          isAvailable: currentIsAvailable,
          count: currentCount
        ))
        currentIsAvailable = self[index].isAvailable
        currentCount = 1
        currentStart = self[index].start
        currentEnd = self[index].end
      }
    }
    
    result.append(GroupedTimeSlot(
      start: currentStart,
      end: currentEnd,
      isAvailable: currentIsAvailable,
      count: currentCount
    ))
    
    return result
  }
}
