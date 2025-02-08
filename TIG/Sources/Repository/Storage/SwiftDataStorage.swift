//
//  SwiftDataStorage.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation
import SwiftData

final class SwiftDataStorage {
  let modelContext: ModelContext = {
    let schema = Schema(versionedSchema: SchemaV2.self)
    let configuration = ModelConfiguration(
      isStoredInMemoryOnly: false
    )
    
    do {
      let container = try ModelContainer(
        for: schema,
        migrationPlan: MigrationPlan.self,
        configurations: [configuration]
      )
      
      return ModelContext(container)
    } catch {
      fatalError("ModelContext Error: \(error.localizedDescription)")
    }
  }()
}

enum SwiftDataError: LocalizedError {
  case fetchError
  case deleteError
  case modelNotFound
  
  var errorDescription: String {
    switch self {
    case .fetchError:
      "Fetch error"
    case .deleteError:
      "Delete error"
    case .modelNotFound:
      "Model not found"
    }
  }
}
