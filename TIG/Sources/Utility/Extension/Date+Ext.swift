//
//  Date+Ext.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

// MARK: - Calendar Method
extension Date {
  static private let configuredCalendar: Calendar = {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
    return calendar
  }()
  
  /// 년, 월, 일 값만 사용하기 위해 형식화한 Date - [Ex. 2024-10-31 15:00:00 +0000]
  var formattedDate: Date {
    Self.configuredCalendar.startOfDay(for: self)
  }
  
  /// Date의 day를 불러옴
  var day: Int {
    return Self.configuredCalendar.component(.day, from: self)
  }
  
  var weekday: Int {
    return Self.configuredCalendar.component(.weekday, from: self)
  }
  
  /// 오늘 날짜인지 확인
  var isToday: Bool {
    Self.configuredCalendar.isDateInToday(self)
  }
  
  /// 해당 날짜에서 원하는 DateComponent를 반환
  func getDateComponents(
    _ components: Set<Calendar.Component>
  ) -> DateComponents {
    Self.configuredCalendar.dateComponents(
      components, from: self
    )
  }
  
  /// Date에서 특정 component에 값을 더합니다.
  /// - Parameters:
  ///   - component: 값을 더할 component
  ///   - value: 더할 값
  /// - Returns: 계산된 Date
  func adding(by component: Calendar.Component, value: Int) -> Date {
    Self.configuredCalendar.date(
      byAdding: component,
      value: value,
      to: self
    )!
  }
  
  /// 비교하려는 날짜와 동일한지 판별
  /// - Parameter date: 비교 대상 날짜
  /// - Returns: 참, 거짓
  func isSameDate(as date: Date) -> Bool {
    Self.configuredCalendar.isDate(date, inSameDayAs: self)
  }
}


// MARK: - WeeklyCalendar Method
extension Date {
  struct WeekDay: Identifiable {
    var id: UUID = .init()
    var date: Date
  }
  
  /// 해당 날짜가 포함된 한 주를 가져옴
  var weekOfDate: [WeekDay] {
    let calendar = Self.configuredCalendar
    let startOfDate = self.formattedDate
    
    var week: [WeekDay] = []
    
    /// 해당 날짜가 포함된 한 주의 시작, 종료 날짜
    let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
    guard let startOfWeek = weekForDate?.start else { return week }
    
    (0..<7).forEach {
      let weekDay = startOfWeek.adding(by: .day, value: $0)
      week.append(.init(date: weekDay))
    }

    return week
  }
  
  // TODO: 하나의 함수로 재사용하기
  func createNextWeek() -> [WeekDay] {
    let startOfLastDate = self.formattedDate
    let nextDate = startOfLastDate.adding(by: .day, value: 1)
    return nextDate.weekOfDate
  }
  
  func createPreviousWeek() -> [WeekDay] {
    let startOfLastDate = self.formattedDate
    let nextDate = startOfLastDate.adding(by: .day, value: -1)
    return nextDate.weekOfDate
  }
}

// MARK: - DateFormatter Method
extension Date {
  enum DateFormatType: String {
    case yearMonth_kr = "yyyy년 M월"
    case weekDay = "E"
  }
  
  static private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()
  
  /// Date를 String Format으로 변환합니다
  /// - Parameter dateFormatType: 변환하고 싶은 dateFormat 타입
  /// - Returns: 변환된 String 값
  func string(format dateFormatType: DateFormatType) -> String {
    Self.dateFormatter.dateFormat = dateFormatType.rawValue
    return Self.dateFormatter.string(from: self)
  }
}

// MARK: - Time Method
extension Date {
  var totalSeconds: Int {
    let components = self.getDateComponents([.hour, .minute])
    return Time.hour * components.hour! + Time.minute * components.minute!
  }
}
