//
//  SharedState.swift
//  TIG
//
//  Created by 신승재 on 4/15/25.
//

import Foundation

@Observable
final class SharedState {
  var selectedDate: Date = Date().formattedDate
  
  var timeSlots: [TimeSlot] = []
  var groupedTimeSlots: [GroupedTimeSlot] = []
  var currentTimeSlot: GroupedTimeSlot { self.groupedTimeSlots.currentTimeSlot }
}
