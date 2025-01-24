//
//  DIContainer.swift
//  TIG
//
//  Created by 이정동 on 8/20/24.
//

import Foundation

final class DIContainer {
  static let shared = DIContainer()
  private init() {}
  
  private let storage = SwiftDataStorage()
}
