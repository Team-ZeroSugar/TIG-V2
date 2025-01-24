//
//  MigrationPlan.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      SchemaV1.self,
      SchemaV2.self
    ]
  }
  
  static var stages: [MigrationStage] {
    [migrateV1toV2]
  }
  
  static let migrateV1toV2 = MigrationStage.custom(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self,
    willMigrate: { context in
      try context.delete(model: SchemaV1.DailyContentSD.self)
      try context.delete(model: SchemaV1.WeeklyRepeatSD.self)
      try context.save()
    },
    didMigrate: nil
  )
}
