//
//  SchemaVersion.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

enum SchemaV2: VersionedSchema {
  static var versionIdentifier: Schema.Version = .init(2, 0, 0)
  
  static var models: [any PersistentModel.Type] {
    [
      DailyScheduleDTO.self,
      WeeklyScheduleDTO.self,
      TimeSlotDTO.self,
      AppConfigDTO.self
    ]
  }
}

enum SchemaV1: VersionedSchema {
  static var versionIdentifier: Schema.Version = .init(1, 0, 0)
  
  static var models: [any PersistentModel.Type] {
    [
      DailyContentSD.self,
      WeeklyRepeatSD.self,
      TimelineSD.self
    ]
  }
}
