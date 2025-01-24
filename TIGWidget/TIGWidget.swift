//
//  TIGWidget.swift
//  TIGWidget
//
//  Created by 신승재 on 8/21/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> TIGEntry {
    TIGEntry(date: .now)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (TIGEntry) -> ()) {
  }
  
  func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
  }
}

struct TIGEntry: TimelineEntry {
  let date: Date
}

struct TIGWidgetEntryView : View {
  
  @Environment(\.widgetFamily) var widgetFamily
  
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      Text("Small")
    case .accessoryRectangular:
      Text("Rectangular")
    default:
      VStack {}
    }
  }
}

struct TIGWidget: Widget {
  let kind: String = "TIGWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      //            if #available(iOS 17.0, *) {
      TIGWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
      //            } else {
      //                TIGWidgetEntryView(entry: entry)
      //                    .padding()
      //                    .background()
      //            }
    }
    .configurationDisplayName("남은 활용 가능 시간")
    .description("오늘 활용할 수 있는 총 시간과\n 남은 활용 가능 시간을 표시합니다.")
    .supportedFamilies([.systemSmall, .accessoryRectangular])
  }
}

#Preview(as: .systemSmall) {
  TIGWidget()
} timeline: {
  TIGEntry(date: .now)
}

