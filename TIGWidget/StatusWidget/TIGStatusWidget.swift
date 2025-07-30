//
//  TIGStatusWidget.swift
//  TIGWidget
//
//  Created by 신승재 on 8/21/24.
//

import WidgetKit
import SwiftUI

struct TIGStatusProvider: TimelineProvider {
  func placeholder(in context: Context) -> TIGEntry {
    TIGEntry(
      date: .now,
      currentTimeSlot: TimeSlot.mock.groupedTimeSlots.currentTimeSlot
    )
  }
  
  func getSnapshot(
    in context: Context,
    completion: @escaping (TIGEntry) -> ()
  ) {
    
  }
  
  func getTimeline(
    in context: Context,
    completion: @escaping (WidgetKit.Timeline<Entry>) -> ()
  ) {
    
  }
}

struct TIGStatusWidgetEntryView : View {
  
  @Environment(\.widgetFamily) var widgetFamily
  
  var entry: TIGStatusProvider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      StatusSmallWidget(entry: entry)
    case .accessoryRectangular:
      StatusLockWidget(entry: entry)
    default:
      VStack {}
    }
  }
}

struct TIGStatusWidget: Widget {
  let kind: String = "TIGWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TIGStatusProvider()) { entry in
      TIGStatusWidgetEntryView(entry: entry)
        .containerBackground(.backgroundNormal, for: .widget)
    }
    .configurationDisplayName("남은 활용 가능 시간")
    .description("오늘 활용할 수 있는 총 시간과\n 남은 활용 가능 시간을 표시합니다.")
    .supportedFamilies([.systemSmall, .accessoryRectangular])
    .contentMarginsDisabled()
  }
}
