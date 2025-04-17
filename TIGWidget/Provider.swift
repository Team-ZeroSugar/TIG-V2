//
//  Provider.swift
//  TIGWidgetExtension
//
//  Created by 신승재 on 4/17/25.
//

import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> TIGEntry {
    TIGEntry(date: .now)
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
