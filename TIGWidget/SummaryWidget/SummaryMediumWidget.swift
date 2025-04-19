//
//  SummaryMediumWidget.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit
import SwiftUI

struct SummaryMediumWidget: View {
  
  let entry: TIGEntry
  
  var body: some View {
    GeometryReader { proxy in
      HStack(spacing: 0) {
        SummarySmallWidget(entry: entry)
          .frame(width: proxy.size.width * 0.42)
        SummarySideWidget(entry: entry)
          .frame(width: proxy.size.width * 0.58)
      }.frame(maxHeight: .infinity)
    }
  }
}


private struct SummarySideWidget: View {
  
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
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundStyle(.contentNeutral)
        .frame(height: 18, alignment: .center)
      
      HStack(spacing: 0) {
        Text("지금은 ")
        Text(isAvailable ? "가용시간" : "비가용시간")
          .foregroundStyle(isAvailable ? .primaryNormal : .contentNormal)
        Text("이에요")
      }
      .font(.pretendard(size: 16, weight: .semiBold))
      .padding(.top, 4)
      
      Link(destination: URL(string: "example")!) {
        Text("시간 수정하기")
          .padding(.vertical, 13)
          .padding(.horizontal, 39)
          .font(.pretendard(size: 12, weight: .semiBold))
          .foregroundStyle(.primaryNormal)
          .background(.primaryAlternative)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }.padding(.top, 18)
    }
  }
}


#Preview(as: .systemMedium) {
  TIGSummaryWidget()
} timeline: {
  TIGEntry(
    date: .now,
    currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
  )
}
