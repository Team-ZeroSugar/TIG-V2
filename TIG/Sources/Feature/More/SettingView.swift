//
//  SettingView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct SettingView: View {
  @State private var isWakeupPickerPresented: Bool = false
  @State private var isBedPickerPresented: Bool = false
  
  // 섹션 리스트 버튼에 보여줄 기상, 취침 값
  @State private var wakeupTimeInSeconds: Int = 0
  @State private var bedTimeInSeconds: Int = 0
  
  // TimeWheelPicker에서의 변경을 추적할 값
  @State private var wakeupTimePicker: Int = 0
  @State private var bedTimePicker: Int = 0
  
  var body: some View {
    VStack {
      List {
        Section("수면 시간 수정") {
          HStack {
            Text("기상 시간")
            Spacer()
            
            Button {
              isWakeupPickerPresented = true
            } label: {
                Text(wakeupTimeInSeconds.time(format: .ampm_kr))
                  .font(.system(size: 17, weight: .regular))
                  .foregroundStyle(Color.exceptionPrimary)
                  .padding(.horizontal, 11)
                  .padding(.vertical, 9)
                  .background(Color.backgroundAlternative)
                  .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
          }
          
          HStack {
            Text("취침 시간")
            Spacer()
            
            Button {
              isBedPickerPresented = true
            } label: {
              Text(bedTimeInSeconds.time(format: .ampm_kr))
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.exceptionPrimary)
                .padding(.horizontal, 11)
                .padding(.vertical, 9)
                .background(Color.backgroundAlternative)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
          }
        }
      }
    }
    .navigationTitle("수면 시간")
    .navigationBarTitleDisplayMode(.inline)
    .actionSheet(isPresented: $isWakeupPickerPresented) {
      TimeWheelPicker(timeInSeconds: $wakeupTimePicker)
    } actions: {
      SheetAction(title: "저장", role: .default) {
        wakeupTimeInSeconds = wakeupTimePicker
      }
      SheetAction(title: "취소", role: .cancel) {
        wakeupTimePicker = wakeupTimeInSeconds
      }
    }
    .actionSheet(isPresented: $isBedPickerPresented) {
      TimeWheelPicker(timeInSeconds: $bedTimePicker)
    } actions: {
      SheetAction(title: "저장", role: .default) {
        bedTimeInSeconds = bedTimePicker
      }
      SheetAction(title: "취소", role: .cancel) {
        bedTimePicker = bedTimeInSeconds
      }
    }

  }
}

#Preview {
  NavigationStack {
    SettingView()
  }
}
