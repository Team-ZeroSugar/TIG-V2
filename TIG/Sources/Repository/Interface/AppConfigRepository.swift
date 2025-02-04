//
//  AppConfigRepository.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

protocol AppConfigRepository {
  
  /// 온보딩을 완료 상태로 설정합니다.
  func setOnboardingCompleted()
  
  /// 현재 온보딩 상태를 가져옵니다.
  /// - Returns: 온보딩 완료 여부
  func fetchOnboardingStatus() -> Result<Bool, Error>
  
  /// 사용자의 기상 시간을 업데이트합니다.
  /// - Parameter time: 설정할 기상 시간 (예: 7 → 오전 7시)
  func updateWakeupTime(_ time: Int)
  
  /// 저장된 기상 시간을 가져옵니다.
  /// - Returns: 저장된 기상 시간 또는 오류
  func fetchWakeupTime() -> Result<Int, Error>
  
  /// 사용자의 취침 시간을 업데이트합니다.
  /// - Parameter time: 설정할 취침 시간 (예: 22 → 오후 10시)
  func updateBedTime(_ time: Int)
  
  /// 저장된 취침 시간을 가져옵니다.
  /// - Returns: 저장된 취침 시간 또는 오류
  func fetchBedTime() -> Result<Int, Error>
}
