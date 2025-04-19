//
//  StatusSmallWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct StatusSmallWidget: View {
  
  let entry: TIGEntry
  
  var isAvailable: Bool { entry.currentTimeSlot.isAvailable }
  var startTimeString: String {
    entry.currentTimeSlot.start.time(format: .ampm_kr)
  }
  var endTimeString: String {
    entry.currentTimeSlot.end.time(format: .ampm_kr)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("\(startTimeString) - \(endTimeString)")
        .frame(height: 18)
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundStyle(.contentNeutral)
      
      Text("지금은")
        .padding(.top, 10)
      HStack(spacing: 0) {
        Text(isAvailable ? "가용시간" : "비가용시간")
          .foregroundStyle(isAvailable ? .primaryNormal : .contentNormal)
        Text("이에요")
      }.padding(.top, 3)
      
      Image(uiImage: isAvailable ? .activeTimer : .inactiveTimer)
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity,
          alignment: .bottomTrailing
        )
    }
    .padding(.top, 18)
    .padding(.leading, 18)
    .font(.pretendard(size: 16, weight: .bold))
    .foregroundStyle(.contentNormal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview(as: .systemSmall) {
  TIGStatusWidget()
} timeline: {
  TIGEntry(
    date: .now,
    currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
