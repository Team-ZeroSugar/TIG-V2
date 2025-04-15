//
//  DIContainer.swift
//  TIG
//
//  Created by 이정동 on 8/20/24.
//

import Foundation

class DIContainer {
  
  static let shared = DIContainer()
  
  private var dependencies = [String: Any]()
  
  private init() {}
  
  func register<T>(_ dependency: T, for type: T.Type = T.self) {
    let key = String(describing: type)
    dependencies[key] = dependency
  }
  
  func resolve<T>() -> T {
    let key = String(describing: T.self)
    guard let dependency = dependencies[key] else {
      fatalError("\(key)는 등록되지 않았습니다.")
    }
    
    return dependency as! T
  }
}


extension DIContainer {
  static func configure() {
    DIContainer.shared.register(
      StubAppConfigRepository(), for: AppConfigRepository.self
    )
    DIContainer.shared.register(
      StubDailyScheduleRepository(), for: DailyScheduleRepository.self
    )
    DIContainer.shared.register(
      StubWeeklyScheduleRepository(), for: WeeklyScheduleRepository.self
    )
    DIContainer.shared.register(SharedState())
  }
}
