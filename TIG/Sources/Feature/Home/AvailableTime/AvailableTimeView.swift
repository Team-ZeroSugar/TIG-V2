//
//  AvailableTimeView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct AvailableTimeView: View {
  @State var isPresented = false
  let homeViewModel: HomeViewModel
  private var isToday: Bool {
    homeViewModel.state.selectedDate.isToday
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if isToday {
        HeaderView(homeViewModel: homeViewModel)
          .padding(.top, 40)
        TimerView(homeViewModel: homeViewModel)
          .padding(.top, 34)
      }
      FooterView(isPresented: $isPresented, homeViewModel: homeViewModel)
        .padding(.top, 36)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.bottom, 10)
    .fullScreenCover(isPresented: $isPresented) {
      EditTimeView(homeViewModel: homeViewModel)
    }
  }
}

private struct HeaderView: View {
  private var startTime: String
  private var endTime: String
  private var isAvailable: Bool
  
  init(homeViewModel: HomeViewModel) {
    let currentTimeSlot = homeViewModel.state.currentTimeSlot
    self.startTime = currentTimeSlot.start.time(format: .ampm_kr)
    self.endTime = currentTimeSlot.end.time(format: .ampm_kr)
    self.isAvailable = currentTimeSlot.isAvailable
  }
  
  var body: some View {
    VStack(spacing: 8) {
      Text("\(startTime) - \(endTime)")
        .font(.pretendard(size: 16, weight: .medium))
        .foregroundStyle(.contentAlternative)
      
      HStack(spacing: 0) {
        Text("지금은 ")
        Text(isAvailable ? "가용시간" : "비가용시간")
          .foregroundStyle(isAvailable ? .primaryNormal : .contentNormal)
        Text("이에요")
      }
      .font(.pretendard(size: 20, weight: .semiBold))
      .foregroundStyle(.contentNormal)
    }
  }
}

// TODO: 코드 리팩토링 필요
private struct TimerView: View {
  let homeViewModel: HomeViewModel
  
  private var mainTitle: String {
    getMainTitle()
  }
  
  private var subTitle: String {
    getSubTitle()
  }
  
  private var isAvailable: Bool {
    homeViewModel.state.currentTimeSlot.isAvailable
  }
  
  private var progressPercent: CGFloat {
    if !isAvailable { return 1 }
    
    let now = homeViewModel.state.currentTimeInSeconds
    let start = homeViewModel.state.currentTimeSlot.start
    let end = homeViewModel.state.currentTimeSlot.end
    return CGFloat(now - start) / CGFloat(end - start)
  }
  
  private var isLastTimeSlot: Bool {
    let currentTimeSlot = homeViewModel.state.currentTimeSlot
    return currentTimeSlot.end == Time.hour * 24
  }
  
  var body: some View {
    ZStack {
      progressCircle
      
      progressText
    }
    .padding(.horizontal, 41.5)
  }
  
  private var progressCircle: some View {
    ZStack {
      Circle()
        .fill(Color.clear)
        .overlay(Circle().stroke(.primaryInactive, lineWidth: 10))
      
      Circle()
        .trim(from: progressPercent, to: 1)
        .stroke(style: StrokeStyle(
            lineWidth: 10,
            lineCap: .square,
            lineJoin: .round
        ))
        .rotationEffect(.degrees(-90))
        .foregroundStyle(.primaryNormal)
    }
  }
  
  private var progressText: some View {
    VStack(spacing: 17) {
      Text(isAvailable ? "남은 가용시간" : "다음 가용시간")
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundStyle(.exceptionNormal)
        .padding(.vertical, 6)
        .padding(.horizontal, 12.5)
        .background(isAvailable ? .primaryNormal : .primaryInactive)
        .clipShape(Capsule())
      
      Text(mainTitle)
        .font(.pretendard(size: 36, weight: .semiBold))
        .foregroundStyle(isAvailable ? .primaryNormal : .primaryInactive)
      
      Text("\(subTitle)")
        .font(.pretendard(size: 16, weight: .medium))
        .foregroundStyle(isAvailable ? .contentNormal : .primaryInactive)
        // 중간 텍스트를 중앙에 배치하기 위해 spacing을 동일하게 주고 offset으로 위치 이동
        .offset(y: -11)
    }
    // 중간 텍스트가 원 중앙에 배치하기 위함
    // 상단, 하단에 위치한 텍스트의 높이가 각각 26, 19로 다름
    // 상단 텍스트가 7만큼 더 높이가 크기 때문에 그 절반만큼 뷰를 위로 옮김
    .offset(y: -3.5)
  }
  
  private func getMainTitle() -> String {
    // 현재 비가용시간인 경우
    if !isAvailable {
      // 현재 마지막 타임슬롯인 경우
      if isLastTimeSlot { return "0시간 0분" }
      // 아닌 경우
      else {
        let nowSeconds = homeViewModel.state.currentTimeInSeconds
        guard let index = homeViewModel.state.groupedTimeSlots.firstIndex(where: {
          $0.start <= nowSeconds && nowSeconds < $0.end
        }) else { return "" }
        let nextTimeSlot = homeViewModel.state.groupedTimeSlots[index + 1]
        return nextTimeSlot.duration.time(format: .duration_kr)
      }
    
    // 현재 가용시간인 경우
    } else {
      let remainSeconds = homeViewModel.state.currentTimeSlot.end - homeViewModel.state.currentTimeInSeconds
      return remainSeconds.time(format: .duration_kr)
    }
  }
  
  private func getSubTitle() -> String {
    // 현재 비가용시간인 경우
    if !isAvailable {
      // 현재 마지막 타임슬롯인 경우
      if isLastTimeSlot { return "" }
      // 아닌 경우
      else {
        let nowSeconds = homeViewModel.state.currentTimeInSeconds
        guard let index = homeViewModel.state.groupedTimeSlots.firstIndex(where: {
          $0.start <= nowSeconds && nowSeconds < $0.end
        }) else { return "" }
        let nextTimeSlot = homeViewModel.state.groupedTimeSlots[index + 1]
        let start = nextTimeSlot.start.time(format: .ampm_kr)
        let end = nextTimeSlot.end.time(format: .ampm_kr)
        return "\(start) - \(end)"
      }
      
    // 현재 가용시간인 경우
    } else {
      let currentTimeSlot = homeViewModel.state.currentTimeSlot
      return "/ \(currentTimeSlot.duration.time(format: .duration_kr))"
    }
  }
}

private struct FooterView: View {
  
  @Binding var isPresented: Bool
  let homeViewModel: HomeViewModel
  
  
  private var remainTime: String {
    let now = homeViewModel.state.currentTimeInSeconds
    return homeViewModel.state.groupedTimeSlots
      .filter { $0.isAvailable && now < $0.end }
      .reduce(0) {
        let anchor = max(now, $1.start)
        return $0 + ($1.end - anchor)
      }
      .time(format: .duration_kr)
  }
  
  private var totalTime: String {
    homeViewModel.state.timeSlots
      .filter { $0.isAvailable }
      .reduce(0) { result, _ in result + Time.interval }
      .time(format: .duration_kr)
  }
  
  private var isToday: Bool {
    homeViewModel.state.selectedDate.isToday
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
        Text("하루 가용시간")
          .font(.pretendard(size: 12, weight: .regular))
        
        HStack(spacing: 0) {
          if isToday {
            Text("\(remainTime)")
            Text(" / ")
          }
          Text("\(totalTime)")
        }
        .font(.pretendard(size: 16, weight: .semiBold))
      }
      .foregroundStyle(.contentNeutral)
      
      Spacer()
      
      if Date().formattedDate <= homeViewModel.state.selectedDate {
        Button {
          isPresented = true
        } label: {
          Text("시간 수정")
            .foregroundStyle(.exceptionPrimary)
            .font(.pretendard(size: 14, weight: .medium))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 18)
        .background(.primaryAlternative)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 22)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(lineWidth: 1)
        .fill(.borderPrimary)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  HomeView()
}

#Preview {
  AvailableTimeView(homeViewModel: HomeViewModel())
}
