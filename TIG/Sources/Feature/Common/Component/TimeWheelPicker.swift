//
//  TimePicker.swift
//  TIG
//
//  Created by 이정동 on 4/22/25.
//

import SwiftUI

private struct TimeValue: Equatable {
  var ampm: Int
  var hour: Int
  var minute: Int
  
  init(timeInSeconds: Int) {
    self.ampm = timeInSeconds.ampm
    self.hour = timeInSeconds.hour
    self.minute = timeInSeconds.minute
  }
}

struct TimeWheelPicker: View {
  @Binding var timeInSeconds: Int
  @State private var timeValue: TimeValue
  
  init(timeInSeconds: Binding<Int>) {
    self._timeInSeconds = timeInSeconds
    self._timeValue = .init(
      initialValue: TimeValue(
        timeInSeconds: timeInSeconds.wrappedValue
      )
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
    .frame(width: 300)
    .onChange(of: timeValue, {
      print(timeValue)
      self.timeInSeconds = convertToSeconds(from: $1)
    })
  }
  
  private func convertToSeconds(from timeValue: TimeValue) -> Int {
    let ampm = timeValue.ampm * Time.hour * 12

    // 12시인 경우는 0시로 계산
    var hour = timeValue.hour * Time.hour
    hour = hour % (Time.hour * 12)
    
    let minute = timeValue.minute * Time.minute
  
    return ampm + hour + minute
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
  @Previewable @State var timeInSeconds: Int = 0
  TimeWheelPicker(timeInSeconds: $timeInSeconds)
}
