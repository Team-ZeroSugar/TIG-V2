//
//  SleepTimeSettingView.swift
//  TIG
//
//  Created by seozero on 8/1/25.
//

import SwiftUI

struct SleepTimeSettingView: View {
  
  @State private var viewmodel = OnboardingViewModel()
  
  @State private var amPmIndex: Int = 0
  @State private var hourIndex: Int = 7
  @State private var minuteIndex: Int = 0
  
  private let amPmData: [String] = ["오전", "오후"]
  private let hourData: [String] = (1...12).map { "\($0)" }
  private let minuteData: [String] = ["00", "30"]
  
  var body: some View {
    VStack(spacing: 0) {
      Text(viewmodel.state.isWakeupMode ? "기상 시간을 설정해주세요" : "취침 시간을 설정해주세요")
        .font(.pretendard(size: 24, weight: .bold))
        .padding(.top, 86)
      
      Text(
        """
        수면 시간을 제외한 가용 시간을 알려드릴게요
        설정에서 언제든지 변경할 수 있습니다
        """
      )
      .font(.pretendard(size: 14, weight: .regular))
      .foregroundStyle(.contentAlternative)
      .multilineTextAlignment(.center)
      .padding(.top, 12)
      
      CustomWheelPicker(
        amPmIndex: $amPmIndex,
        hourIndex: $hourIndex,
        minuteIndex: $minuteIndex,
        amPmData: amPmData,
        hourData: hourData,
        minuteData: minuteData
      )
        .padding(.horizontal, 68)
        .padding(.top, 209)
      
      Spacer()
      
      OnboardingButton(type: viewmodel.state.isWakeupMode ? .next : .start) {
        
        let formattedTime = convertToTimeIndex(amPm: amPmIndex, hour: hourIndex, minute: minuteIndex)
        
        if viewmodel.state.isWakeupMode {
          viewmodel.send(.setWakeUpTime(formattedTime))
          print(formattedTime)
        } else {
          viewmodel.send(.setBedTime(formattedTime))
          UserDefaults.shared.set(false, forKey: UserDefaultsKey.isOnboarding)
          print(formattedTime)
        }
      }
        .padding(.bottom, 58)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.backgroundAlternative.ignoresSafeArea())
    .onChange(of: viewmodel.state.isWakeupMode) { _, isWakeupMode in
      if !isWakeupMode {
        amPmIndex = 0
        hourIndex = 11
        minuteIndex = 0
      } else {
        amPmIndex = 0
        hourIndex = 7
        minuteIndex = 0
      }
    }
  }
  
  private func convertToTimeIndex(amPm: Int, hour: Int, minute: Int) -> Int {
    let adjustedHour: Int = hour + 1
    var hourTo24Format: Int
    
    let isAm: Bool = amPm == 0
    
    if isAm {
      if adjustedHour == 12 {
        hourTo24Format = 0
      } else {
        hourTo24Format = adjustedHour
      }
    } else {
      if adjustedHour == 12 {
        hourTo24Format = 12
      } else {
        hourTo24Format = adjustedHour + 12
      }
    }
    
    let convertedTimeIndex = hourTo24Format * 2 + minute
    
    return convertedTimeIndex
  }
}

#Preview {
  SleepTimeSettingView()
}
