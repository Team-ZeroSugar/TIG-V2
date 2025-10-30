//
//  UserDefaults+Ext.swift
//  TIG
//
//  Created by seozero on 10/29/25.
//

import Foundation

extension UserDefaults {
  static let appGroupName = "group.com.zerosugar.TIG.appgroup"
  
  static var shared: UserDefaults {
    return UserDefaults(suiteName: appGroupName)!
  }
}
