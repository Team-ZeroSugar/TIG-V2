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

// MARK: - Mock Data

extension TimeSlot {
  static let mock: [TimeSlot] = [
    // 00시 ~ 01시
    TimeSlot(start: 0, end: 30 * 60, isAvailable: true),
    TimeSlot(start: 30 * 60, end: 60 * 60, isAvailable: true),
    // 01시 ~ 02시
    TimeSlot(start: 60 * 60, end: 90 * 60, isAvailable: true),
    TimeSlot(start: 90 * 60, end: 120 * 60, isAvailable: true),
    // 02시 ~ 03시
    TimeSlot(start: 120 * 60, end: 150 * 60, isAvailable: true),
    TimeSlot(start: 150 * 60, end: 180 * 60, isAvailable: true),
    // 03시 ~ 04시
    TimeSlot(start: 180 * 60, end: 210 * 60, isAvailable: true),
    TimeSlot(start: 210 * 60, end: 240 * 60, isAvailable: true),
    // 04시 ~ 05시
    TimeSlot(start: 240 * 60, end: 270 * 60, isAvailable: true),
    TimeSlot(start: 270 * 60, end: 300 * 60, isAvailable: false),
    // 05시 ~ 06시
    TimeSlot(start: 300 * 60, end: 330 * 60, isAvailable: false),
    TimeSlot(start: 330 * 60, end: 360 * 60, isAvailable: false),
    // 06시 ~ 07시
    TimeSlot(start: 360 * 60, end: 390 * 60, isAvailable: false),
    TimeSlot(start: 390 * 60, end: 420 * 60, isAvailable: false),
    // 07시 ~ 08시
    TimeSlot(start: 420 * 60, end: 450 * 60, isAvailable: false),
    TimeSlot(start: 450 * 60, end: 480 * 60, isAvailable: false),
    // 08시 ~ 09시
    TimeSlot(start: 480 * 60, end: 510 * 60, isAvailable: false),
    TimeSlot(start: 510 * 60, end: 540 * 60, isAvailable: false),
    // 09시 ~ 10시
    TimeSlot(start: 540 * 60, end: 570 * 60, isAvailable: true),
    TimeSlot(start: 570 * 60, end: 600 * 60, isAvailable: true),
    // 10시 ~ 11시
    TimeSlot(start: 600 * 60, end: 630 * 60, isAvailable: true),
    TimeSlot(start: 630 * 60, end: 660 * 60, isAvailable: true),
    // 11시 ~ 12시
    TimeSlot(start: 660 * 60, end: 690 * 60, isAvailable: true),
    TimeSlot(start: 690 * 60, end: 720 * 60, isAvailable: true),
    // 12시 ~ 13시
    TimeSlot(start: 720 * 60, end: 750 * 60, isAvailable: true),
    TimeSlot(start: 750 * 60, end: 780 * 60, isAvailable: false),
    // 13시 ~ 14시
    TimeSlot(start: 780 * 60, end: 810 * 60, isAvailable: false),
    TimeSlot(start: 810 * 60, end: 840 * 60, isAvailable: false),
    // 14시 ~ 15시
    TimeSlot(start: 840 * 60, end: 870 * 60, isAvailable: false),
    TimeSlot(start: 870 * 60, end: 900 * 60, isAvailable: false),
    // 15시 ~ 16시
    TimeSlot(start: 900 * 60, end: 930 * 60, isAvailable: false),
    TimeSlot(start: 930 * 60, end: 960 * 60, isAvailable: true),
    // 16시 ~ 17시
    TimeSlot(start: 960 * 60, end: 990 * 60, isAvailable: true),
    TimeSlot(start: 990 * 60, end: 1020 * 60, isAvailable: true),
    // 17시 ~ 18시
    TimeSlot(start: 1020 * 60, end: 1050 * 60, isAvailable: true),
    TimeSlot(start: 1050 * 60, end: 1080 * 60, isAvailable: false),
    // 18시 ~ 19시
    TimeSlot(start: 1080 * 60, end: 1110 * 60, isAvailable: true),
    TimeSlot(start: 1110 * 60, end: 1140 * 60, isAvailable: true),
    // 19시 ~ 20시
    TimeSlot(start: 1140 * 60, end: 1170 * 60, isAvailable: true),
    TimeSlot(start: 1170 * 60, end: 1200 * 60, isAvailable: true),
    // 20시 ~ 21시
    TimeSlot(start: 1200 * 60, end: 1230 * 60, isAvailable: true),
    TimeSlot(start: 1230 * 60, end: 1260 * 60, isAvailable: true),
    // 21시 ~ 22시
    TimeSlot(start: 1260 * 60, end: 1290 * 60, isAvailable: true),
    TimeSlot(start: 1290 * 60, end: 1320 * 60, isAvailable: true),
    // 22시 ~ 23시
    TimeSlot(start: 1320 * 60, end: 1350 * 60, isAvailable: true),
    TimeSlot(start: 1350 * 60, end: 1380 * 60, isAvailable: true),
    // 23시 ~ 24시
    TimeSlot(start: 1380 * 60, end: 1410 * 60, isAvailable: true),
    TimeSlot(start: 1410 * 60, end: 1440 * 60, isAvailable: true)
  ]
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
