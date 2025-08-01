//
//  OnboardingButtonType.swift
//  TIG
//
//  Created by seozero on 8/1/25.
//

import Foundation

enum OnboardingButtonType {
  case next
  case setSleepTime
  case start
  
  var title: String {
    switch self {
    case .next:
      return "다음"
    case .setSleepTime:
      return "수면시간 설정하기"
    case .start:
      return "시작하기"
    }
  }
}
