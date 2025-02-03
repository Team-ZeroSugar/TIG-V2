//
//  WeekDay.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

enum WeekDay: Int, CaseIterable {
  case sun = 0
  case mon = 1
  case tue = 2
  case wed = 3
  case thu = 4
  case fri = 5
  case sat = 6
  
  var text: String {
    switch self {
    case .sun: "일"
    case .mon: "월"
    case .tue: "화"
    case .wed: "수"
    case .thu: "목"
    case .fri: "금"
    case .sat: "토"
    }
  }
}
