//
//  StatusLockWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct StatusLockWidget: View {
  
  var entry: TIGEntry
  
  var body: some View {
    Text("\(entry.date)")
  }
}

#Preview(as: .accessoryRectangular) {
  TIGStatusWidget()
} timeline: {
  TIGEntry(
    date: .now,
    groupedTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
