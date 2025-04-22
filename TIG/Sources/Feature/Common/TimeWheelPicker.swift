//
//  TimePicker.swift
//  TIG
//
//  Created by 이정동 on 4/22/25.
//

import SwiftUI

private struct TimeValue {
  var ampm: Int
  var hour: Int
  var minute: Int
  
  init(timeInSeconds: Int) {
    self.ampm = timeInSeconds.ampm
    self.hour = timeInSeconds.hour
    self.minute = timeInSeconds.minute
    print(timeInSeconds.minute)
  }
}

struct TimeWheelPicker: View {
  
  @State private var timeValue: TimeValue
  
  init(timeInSeconds: Int) {
    self._timeValue = .init(
      initialValue: TimeValue(timeInSeconds: timeInSeconds)
    )
  }
  
  var body: some View {
    HStack {
      Group {
        // 오전, 오후
        Picker("", selection: $timeValue.ampm) {
          ForEach([0, 1], id: \.self) { int in
            Text(int == 0 ? "오전" : "오후")
              .font(.pretendard(size: 20, weight: .medium))
          }
        }
        
        // 시
        Picker("", selection: $timeValue.hour) {
          ForEach(1..<13, id: \.self) { int in
            Text("\(int)")
              .font(.pretendard(size: 20, weight: .medium))
          }
        }
        
        // 분
        Picker("", selection: $timeValue.minute) {
          ForEach([0, 30], id: \.self) { int in
            Text(int == 0 ? "00" : "30")
              .font(.pretendard(size: 20, weight: .medium))
          }
        }
      }
      .pickerStyle(.wheel)
      
    }
  }
}

private extension Int {
  /// ampm == 0 -> 오전
  /// ampm == 1 -> 오후
  var ampm: Int {
    self / (Time.hour * 12) == 1 ? 1 : 0
  }
  
  /// 12시간 단위
  var hour: Int {
    let hour = self / Time.hour
    return hour % 12 == 0 ? 12 : hour % 12
  }
  
  var minute: Int {
    self % Time.hour / Time.minute
  }
}


#Preview {
  TimeWheelPicker(timeInSeconds: Time.hour * 20 + Time.minute * 30)
}
