//
//  TIGApp.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

@main
struct TIGApp: App {
  
  init() {
    DIContainer.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
    }
  }
}
