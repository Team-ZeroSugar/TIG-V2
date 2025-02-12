//
//  AppConfigRepository.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

protocol AppConfigRepository {
  
  /// 온보딩 완료 상태로 전환하며, 동시에 기상 시간과 취침 시간을 저장합니다.
  /// - Parameters:
  ///   - wakeupTime: 설정할 기상 시간 (예: Time.hour * 7 + Time.minute * 30 → 오전 7시 30분)
  ///   - bedTime: 설정할 취침 시간 (예: Time.hour * 22 + Time.minute * 30 → 오후 10시 30분)
  func setOnboardingCompleted(wakeupTime: Int, bedTime: Int)
  
  /// 현재 온보딩 상태를 가져옵니다.
  /// - Returns: 온보딩 완료 여부
  func fetchOnboardingStatus() -> Result<Bool, Error>
  
  /// 기상 시간을 업데이트합니다.
  /// - Parameter time: 설정할 기상 시간 (예: Time.hour * 7 + Time.minute * 30 → 오전 7시 30분)
  func updateWakeupTime(_ time: Int)
  
  /// 저장된 기상 시간을 가져옵니다.
  /// - Returns: 저장된 기상 시간
  func fetchWakeupTime() -> Result<Int, Error>
  
  /// 취침 시간을 업데이트합니다.
  /// - Parameter time: 설정할 취침 시간 (예: Time.hour * 22 + Time.minute  * 30 → 오후 10시 30분)
  func updateBedTime(_ time: Int)
  
  /// 저장된 취침 시간을 가져옵니다.
  /// - Returns: 저장된 취침 시간
  func fetchBedTime() -> Result<Int, Error>
  
}
