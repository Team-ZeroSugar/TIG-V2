//
//  WeeklyScheduleRepositoryImpl.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

final class WeeklyScheduleRepositoryImpl: WeeklyScheduleRepository {
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
}
