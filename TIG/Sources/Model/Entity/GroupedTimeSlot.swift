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

extension GroupedTimeSlot {
  static let mock = GroupedTimeSlot(
    start: 0,
    end: 0,
    isAvailable: false,
    duration: 0,
    count: 0
  )
}
