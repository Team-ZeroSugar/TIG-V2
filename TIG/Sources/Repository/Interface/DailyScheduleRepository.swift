//
//  DailyScheduleRepository.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

protocol DailyScheduleRepository {
  
  /// 새로운 일정을 생성합니다.
  func createDailySchedule()
  
  /// 저장된 모든 일정을 가져옵니다.
  /// - Returns: 저장된 모든 `DailySchedule`
  func fetchAllDailySchedules() -> Result<[DailySchedule], Error>
  
  /// 특정 날짜의 일정을 조회합니다.
  /// - Parameter date: 조회할 날짜.
  /// - Returns: 해당 날짜의 `DailySchedule`
  func fetchDailySchedule(date: Date) -> Result<DailySchedule, Error>
  
  /// 기존 일정을 업데이트합니다.
  /// - Parameters:
  ///   - dailySchedule: 업데이트할 `DailySchedule` 객체.
  ///   - timeSlots: 해당 일정에 적용할 `TimeSlot` 배열.
  func updateDailySchedule(dailySchedule: DailySchedule, timeSlots: [TimeSlot])
  
  /// 특정 일정을 삭제합니다.
  /// - Parameter dailySchedule: 삭제할 `DailySchedule` 객체.
  func deleteDailySchedule(_ dailySchedule: DailySchedule)
  
}
