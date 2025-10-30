//
//  OnboardingContent.swift
//  TIG
//
//  Created by seozero on 7/30/25.
//

import SwiftUI

enum OnboardingContent: Int, CaseIterable {
  case onboardingFirst = 0
  case onboardingSecond
  case onboardingThird
  
  var title: String {
    switch self {
    case .onboardingFirst:
      return "가용시간은"
    case .onboardingSecond:
      return "오늘의 남은 가용시간을\n인지할 수 있어요"
    case .onboardingThird:
      return "홈, 잠금 위젯을 사용하면"
    }
  }
  
  var description: String {
    switch self {
    case .onboardingFirst:
      return "하루 중 일정이 있는 시간을 제외한\n자유롭게 활용할 수 있는 시간이에요"
    case .onboardingSecond:
      return "남은 시간에 대한 계획을 세워보세요"
    case .onboardingThird:
      return "더욱 편리하고 쉽게\n가용시간을 알 수 있습니다"
    }
  }
  
  var image: ImageResource {
    switch self {
    case .onboardingFirst:
      return .onboardingFirst
    case .onboardingSecond:
      return .onboardingSecond
    case .onboardingThird:
      return .onboardingThird
    }
  }
}
