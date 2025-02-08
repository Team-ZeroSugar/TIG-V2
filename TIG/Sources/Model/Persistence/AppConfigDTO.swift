//
//  AppConfig.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

typealias AppConfigDTO = SchemaV2.AppConfigDTO

extension SchemaV2 {
  @Model
  final class AppConfigDTO {
    var wakeupTime: Int
    var bedTime: Int
    var isOnboarding: Bool
    
    init(wakeupTime: Int, bedTime: Int, isOnboarding: Bool) {
      self.wakeupTime = wakeupTime
      self.bedTime = bedTime
      self.isOnboarding = isOnboarding
    }
    
    convenience init(_ data: AppConfig) {
      self.init(
        wakeupTime: data.wakeupTime,
        bedTime: data.bedTime,
        isOnboarding: data.isOnboarding
      )
    }
  }
}
