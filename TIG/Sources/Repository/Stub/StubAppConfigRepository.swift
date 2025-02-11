//
//  StubAppConfigRepository.swift
//  TIG
//
//  Created by 이정동 on 1/31/25.
//

import Foundation

final class StubAppConfigRepository: AppConfigRepository {
  private var onboardingCompleted: Bool = false
  private var wakeupTime: Int = 0
  private var bedTime: Int = 0
  
  func setOnboardingCompleted(wakeupTime: Int, bedTime: Int) {
    self.onboardingCompleted = true
    self.wakeupTime = wakeupTime
    self.bedTime = bedTime
  }
  
  func fetchOnboardingStatus() -> Result<Bool, any Error> {
    return .success(onboardingCompleted)
  }
  
  func updateWakeupTime(_ time: Int) {
    self.wakeupTime = time
  }
  
  func fetchWakeupTime() -> Result<Int, any Error> {
    return .success(wakeupTime)
  }
  
  func updateBedTime(_ time: Int) {
    self.bedTime = time
  }
  
  func fetchBedTime() -> Result<Int, any Error> {
    return .success(bedTime)
  }
}
