//
//  SummarySmallWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct SummarySmallWidget: View {
  
  let entry: TIGEntry
  
  var remainTimeString: String {
    let currentTime = Date().totalSeconds
    let remainTime = entry.currentTimeSlot.end - currentTime
    return remainTime.time(format: .duration_kr)
  }
  var totalTimeString: String {
    entry.currentTimeSlot.duration.time(format: .duration_kr)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("현재 가용시간")
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .font(.pretendard(size: 10, weight: .medium))
        .foregroundStyle(.contentException)
        .background(.primaryNormal)
        .clipShape(Capsule())
      
      Text(remainTimeString)
        .foregroundStyle(.primaryNormal)
        .font(.pretendard(size: 24, weight: .semiBold))
        .padding(.top, 10)
      
      Text("/ \(totalTimeString)")
        .foregroundStyle(.contentNormal)
        .font(.pretendard(size: 12, weight: .medium))
        .padding(.top, 6)
        .padding(.bottom, 10)
    }
  }
}

#Preview(as: .systemSmall) {
  TIGSummaryWidget()
} timeline: {
  TIGEntry(
    date: .now,
    currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
