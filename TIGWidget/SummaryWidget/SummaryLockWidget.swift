//
//  SummaryLockWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct SummaryLockWidget: View {
  
  var entry: TIGEntry
  
  var totalTimeString: String {
    entry.currentTimeSlot.duration.time(format: .duration_kr)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("남은 하루 가용시간")
        .font(.pretendard(size: 13, weight: .semiBold))
      Text(totalTimeString)
        .font(.pretendard(size: 13, weight: .medium))
    }
  }
}

#Preview(as: .accessoryRectangular) {
  TIGSummaryWidget()
} timeline: {
  TIGEntry(
    date: .now,
    currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
