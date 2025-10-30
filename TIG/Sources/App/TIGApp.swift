//
//  TIGApp.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

@main
struct TIGApp: App {
  
  @AppStorage(
    UserDefaultsKey.isOnboarding,
    store: UserDefaults(suiteName: "group.com.zerosugar.TIG.appgroup")
  ) private var isOnboarding: Bool = true
  
  init() {
    DIContainer.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnboardingView()
      } else {
        HomeView()
      }
    }
  }
}
