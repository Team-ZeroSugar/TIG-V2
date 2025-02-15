//
//  Int+Ext.swift
//  TIG
//
//  Created by 이정동 on 2/14/25.
//

import Foundation

// MARK: - TimeFormat Method
extension Int {
  enum TimeFormatType {
    case ampm_kr
    case duration_kr
  }
  
  /// 시간을 표현할 텍스트로 변환합니다.
  /// - Parameter timeFormatType: 시간 형식
  /// - Returns: 변환된 텍스트
  func time(format timeFormatType: TimeFormatType) -> String {
    switch timeFormatType {
    case .ampm_kr:
      return getAMPMFormat(from: self)
    case .duration_kr:
      return getDurationFormat(from: self)
    }
  }
  
  /// 오전, 오후 시간 및 분으로 표현하는 문자열을 가져옵니다
  /// - Returns: ex) 오전 11:00
  private func getAMPMFormat(from totalSeconds: Int) -> String {
    var hours = totalSeconds / Time.hour
    let minutes = totalSeconds % Time.hour / Time.minute
    let ampm = hours < 12 ? "AM" : "PM"
    hours = hours % 12 == 0 ? 12 : hours % 12
    return "\(ampm) \(hours):\(minutes)"
  }
  
  /// 시간 간격을 표현하는 문자열을 가져옵니다
  /// - Returns: ex) 11시간 30분
  private func getDurationFormat(from totalSeconds: Int) -> String {
    let hours = totalSeconds / Time.hour
    let minutes = totalSeconds % Time.hour / Time.minute
    if minutes == 0 {
      return "\(hours)시간"  // 0분일 경우 생략
    } else {
      return "\(hours)시간 \(minutes)분"
    }
  }
}
