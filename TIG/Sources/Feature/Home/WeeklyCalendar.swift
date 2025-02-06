//
//  WeeklyCalendar.swift
//  TIG
//
//  Created by 이정동 on 2/5/25.
//

import SwiftUI

struct WeeklyCalendar: View {
  let homeViewModel: HomeViewModel
  
  @State private var currentWeekIndex: Int = 1
  
  var body: some View {
    TabView(selection: $currentWeekIndex) {
      let weekSlider = homeViewModel.state.weekSlider
      ForEach(weekSlider.indices, id: \.self) { index in
        WeekView(
          homeViewModel: homeViewModel,
          week: weekSlider[index]
        )
        .padding(.horizontal, 20)
        .tag(index)
      }
      .background {
        GeometryReader {
          let minX = $0.frame(in: .global).minX
          
          Color.clear
            .preference(key: OffsetKey.self, value: minX)
            .onPreferenceChange(OffsetKey.self) { value in
              if value.rounded() == 0 {
                paginateWeek()
              }
            }
        }
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(height: 60)
    .padding(.vertical, 19)
    .onAppear {
      homeViewModel.send(.onAppear)
    }
  }
  
  func paginateWeek() {
    // 현재 WeekSlider의 중간 위치에 있을 경우는 업데이트 X
    if currentWeekIndex == 1 { return }
    
    homeViewModel.send(.moveWeekPeriod(to: currentWeekIndex))
    currentWeekIndex = 1
  }
}

private struct WeekView: View {
  
  let homeViewModel: HomeViewModel
  let week: [Date.WeekDay]
  
  var body: some View {
    HStack(spacing: 9) {
      ForEach(week) { weekDay in
        Button {
          homeViewModel.send(.selectDate(weekDay.date))
        } label: {
          dayView(weekDay.date)
        }
        .background {
          if weekDay.date.isSameDate(as: homeViewModel.state.currentDate) {
            RoundedRectangle(cornerRadius: 10)
              .fill(.blueMain)
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  @ViewBuilder
  private func dayView(_ date: Date) -> some View {
    VStack(spacing: 8) {
      Text("\(date.formattedToString(.weekDay))")
        .font(.pretendard(size: 12, weight: .medium))
      Text("\(date.day)")
        .font(.pretendard(size: 16, weight: .semiBold))
    }
    .foregroundStyle(
      homeViewModel.state.currentDate == date
      ? .white : .black
    )
    .frame(width: 40, alignment: .center)
    .padding(.vertical, 10)
  }
}

private struct OffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  WeeklyCalendar(homeViewModel: HomeViewModel())
}
