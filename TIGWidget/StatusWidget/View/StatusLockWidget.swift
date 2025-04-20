//
//  StatusLockWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct StatusLockWidget: View {
  
  let entry: TIGEntry
  
  var isAvailable: Bool { entry.currentTimeSlot.isAvailable }
  var startTimeString: String {
    entry.currentTimeSlot.start.time(format: .ampm_kr)
  }
  var endTimeString: String {
    entry.currentTimeSlot.end.time(format: .ampm_kr)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 1) {
      Text("\(startTimeString) - \(endTimeString)")
        .font(.pretendard(size: 13, weight: .medium))
      Text("지금은 \(isAvailable ? "가용" : "비가용")시간이에요")
        .font(.pretendard(size: 13, weight: .bold))
    }
  }
}

#Preview(as: .accessoryRectangular) {
  TIGStatusWidget()
} timeline: {
  TIGEntry(
    date: .now,
    currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
