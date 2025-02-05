//
//  WeeklyScheduleRepository.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

protocol WeeklyScheduleRepository {
  
  /// 주간 반복 일정을 초기화하고 기본값을 설정합니다.
  /// 앱에서 사용할 수 있도록 초기 `WeeklySchedule` 데이터를 생성합니다.
  func initializeWeeklySchedule()
  
  /// 저장된 모든 주간 반복 일정을 가져옵니다.
  /// - Returns: 저장된 모든 `WeeklySchedule`
  func fetchAllWeeklySchedules() -> Result<[WeeklySchedule], Error>
  
  /// 특정 요일의 주간 반복 일정을 조회합니다.
  /// - Parameter weekDay: 조회할 요일 (`WeekDay` 타입).
  /// - Returns: 해당 요일의 `WeeklySchedule`
  func fetchWeeklySchedule(weekDay: WeekDay) -> Result<WeeklySchedule, Error>
  
  /// 기존 주간 반복 일정을 업데이트합니다.
  /// - Parameters:
  ///   - weeklySchedule: 업데이트할 `WeeklySchedule` 객체.
  ///   - timeSlots: 해당 일정에 적용할 `TimeSlot` 배열.
  func updateWeeklySchedule(weeklySchedule: WeeklySchedule, timeSlots: [TimeSlot])
  
}
