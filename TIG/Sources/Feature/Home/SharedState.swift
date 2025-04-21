//
//  SharedState.swift
//  TIG
//
//  Created by 신승재 on 4/15/25.
//

import Foundation

@Observable
final class SharedState {
  // 선택된 날짜
  var selectedDate: Date = Date().formattedDate
  
  // 선택된 날짜에 따른 timeSlots
  var timeSlots: [TimeSlot] = []
  var groupedTimeSlots: [GroupedTimeSlot] { self.timeSlots.groupedTimeSlots }
  var currentTimeSlot: GroupedTimeSlot { self.groupedTimeSlots.currentTimeSlot }
}
