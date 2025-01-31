//
//  Date+Ext.swift
//  TIG
//
//  Created by 이정동 on 1/24/25.
//

import Foundation

extension Date {
  static private let configuredCalendar: Calendar = {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
    return calendar
  }()
  
  
  var formattedDate: Date {
    let dateComponent = self.getDateComponents([.year, .month, .day])
    return Self.configuredCalendar.date(from: dateComponent) ?? self
  }
  
  /// 해당 날짜에서 원하는 DateComponent를 반환
  func getDateComponents(
    _ components: Set<Calendar.Component>
  ) -> DateComponents {
    Self.configuredCalendar.dateComponents(
      components, from: self
    )
  }
}
