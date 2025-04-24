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
          duration: currentEnd - currentStart,
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
      duration: currentEnd - currentStart,
      count: currentCount
    ))
    
    return result
  }
}


extension Array where Element == GroupedTimeSlot {
  /// 배열에서 현재 시간대에 위치한 TimeSlot 객체를 반환합니다. (빈 배열인 경우 mock 반환)
  var currentTimeSlot: GroupedTimeSlot {
    let now = Date()
    let totalSeconds = now.totalSeconds
    
    return self.first(where: {
      $0.start <= totalSeconds && $0.end > totalSeconds
    }) ?? .mock
  }
}
