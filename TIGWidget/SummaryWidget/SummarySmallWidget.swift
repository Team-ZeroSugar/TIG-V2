//
//  SummarySmallWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct SummarySmallWidget: View {
  
  var entry: TIGEntry
  
  var body: some View {
    Text("\(entry.date)")
  }
}

#Preview(as: .systemSmall) {
  TIGSummaryWidget()
} timeline: {
  TIGEntry(
    date: .now,
    groupedTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
