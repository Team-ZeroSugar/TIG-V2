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
  @State private var weekSlider: [[Date.WeekDay]] = []
  
  var body: some View {
    TabView(selection: $currentWeekIndex) {
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
    .padding(.bottom, 19)
    .onAppear {
      if weekSlider.isEmpty {
        weekSlider = generateWeekSlider()
      }
    }
    .onChange(of: homeViewModel.state.selectedDate) {
      weekSlider = generateWeekSlider(anchor: $1)
    }
  }
  
  private func paginateWeek() {
    // 현재 WeekSlider의 중간 위치에 있을 경우는 업데이트 X
    if currentWeekIndex == 1 { return }
    
    if weekSlider.indices.contains(currentWeekIndex) {
      if let firstDate = weekSlider[currentWeekIndex].first?.date,
         currentWeekIndex == 0 {
        weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
        weekSlider.removeLast()
      }
      
      if let lastDate = weekSlider[currentWeekIndex].last?.date,
         currentWeekIndex == (weekSlider.count - 1) {
        weekSlider.append(lastDate.createNextWeek())
        weekSlider.removeFirst()
      }
    }
    
    currentWeekIndex = 1
  }
  
  /// 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음을 생성
  /// - Parameter date: 기준이 되는 날짜
  /// - Returns: 기준 날짜가 속한 주를 포함한 이전, 다음 주 데이터 묶음
  private func generateWeekSlider(anchor date: Date = .now) -> [[Date.WeekDay]] {
    var newWeeks = [[Date.WeekDay]]()
    let anchorWeek = date.weekOfDate
    
    if let firstDate = anchorWeek.first?.date {
      newWeeks.append(firstDate.createPreviousWeek())
    }
    
    newWeeks.append(anchorWeek)
    
    if let lastDate = anchorWeek.last?.date {
      newWeeks.append(lastDate.createNextWeek())
    }
    
    return newWeeks
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
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  @ViewBuilder
  private func dayView(_ date: Date) -> some View {
    let isSelected = date.isSameDate(
      as: homeViewModel.state.selectedDate
    )
    
    VStack(spacing: 8) {
      Text("\(date.string(format: .weekDay))")
        .font(.pretendard(size: 12, weight: .medium))
      Text("\(date.day)")
        .font(.pretendard(size: 16, weight: .semiBold))
    }
    .foregroundStyle(
      homeViewModel.state.selectedDate == date
      ? .exceptionNormal : .contentNormal
    )
    .frame(maxWidth: .infinity, alignment: .center)
    .padding(.vertical, 10)
    .background {
      RoundedRectangle(cornerRadius: 10)
        .fill(isSelected ? .blueMain : .clear)
    }
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
