//
//  AppConfigRepositoryImpl.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation
import SwiftData

final class AppConfigRepositoryImpl: AppConfigRepository {
  
  
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  
  func setOnboardingCompleted(wakeupTime: Int, bedTime: Int) {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success:
      print(SwiftDataError.modelAlreadyExist)
    case .failure(.modelNotFound):
      let model = AppConfigDTO(
        wakeupTime: wakeupTime,
        bedTime: bedTime,
        isOnboarding: true
      )
      modelContext.insert(model)
    case .failure(let error):
      print(error)
    }
  }
  
  
  func fetchOnboardingStatus() -> Result<Bool, any Error> {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success(let model):
      return .success(model.isOnboarding)
    case .failure(.modelNotFound):
      // AppConfig 객체가 없을 경우, false를 반환
      return .success(false)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  
  func updateWakeupTime(_ time: Int) {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success(let model):
      model.wakeupTime = time
    case .failure(let error):
      print(error)
    }
  }
  
  
  func fetchWakeupTime() -> Result<Int, any Error> {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success(let model):
      return .success(model.wakeupTime)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  
  func updateBedTime(_ time: Int) {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success(let model):
      model.bedTime = time
    case .failure(let error):
      print(error)
    }
  }
  
  
  func fetchBedTime() -> Result<Int, any Error> {
    print("Impl:", #function)
    
    let result = getAppConfig()
    switch result {
    case .success(let model):
      return .success(model.bedTime)
    case .failure(let error):
      return .failure(error)
    }
  }
  
}


extension AppConfigRepositoryImpl {
  private func getAppConfig() -> Result<AppConfigDTO, SwiftDataError> {
    print("Impl:", #function)
    
    let descriptor = FetchDescriptor<AppConfigDTO>()
    
    do {
      guard let data = try modelContext.fetch(descriptor).first else {
        return .failure(.modelNotFound)
      }
      return .success(data)
    } catch {
      return .failure(.fetchError)
    }
  }
}
