//
//  TimeSlotRepository.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

protocol TimeSlotRepository {
  
  /// 특정 날짜의 시간 슬롯(TimeSlot) 데이터를 업데이트합니다.
  /// - Parameters:
  ///   - date: 시간 슬롯을 업데이트할 날짜.
  ///   - timeSlots: 업데이트할 `TimeSlot` 객체들의 배열.
  func updateTimeSlots(date: Date, timeSlots: [TimeSlot])
  
  /// 특정 반복 요일의 시간 슬롯(TimeSlot) 데이터를 업데이트합니다.
  /// - Parameters:
  ///   - weekDay: 시간 슬롯을 업데이트할 요일.
  ///   - timeSlots: 업데이트할 `TimeSlot` 객체들의 배열.
  func updateTimeSlots(weekDay: WeekDay, timeSlots: [TimeSlot])
  
}
