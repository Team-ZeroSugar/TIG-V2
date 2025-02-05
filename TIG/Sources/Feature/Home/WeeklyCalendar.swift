//
//  WeeklyCalendar.swift
//  TIG
//
//  Created by 이정동 on 2/5/25.
//

import SwiftUI

struct WeeklyCalendar: View {
  let homeViewModel: HomeViewModel
  
  @State private var createWeek: Bool = false
  @State private var currentWeekIndex: Int = 1
  
  @State private var weekSlider: [[Date.WeekDay]] = []
  
  var body: some View {
    TabView(selection: $currentWeekIndex) {
      //      let weekSlider = homeViewModel.state.weekSlider
      let weekSlider = self.weekSlider
      ForEach(weekSlider.indices, id: \.self) { index in
        WeekView(
          homeViewModel: homeViewModel,
          week: weekSlider[index],
          createWeek: $createWeek,
          weekSlider: $weekSlider,
          currentWeekIndex: $currentWeekIndex
        )
        .padding(.horizontal, 20)
        .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(height: 60)
    .onAppear {
      // weekSlider 초기화
      if weekSlider.isEmpty {
        let currentWeek = Date().weekOfDate
        
        if let firstDate = currentWeek.first?.date {
          weekSlider.append(firstDate.createPreviousWeek())
        }
        
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
          weekSlider.append(lastDate.createNextWeek())
        }
      }
    }
    .onChange(of: currentWeekIndex) {
      if $1 == 0 || $1 == weekSlider.count - 1{
        createWeek = true
      }
    }
  }
}

private struct WeekView: View {
  
  let homeViewModel: HomeViewModel
  let week: [Date.WeekDay]
  @Binding var createWeek: Bool
  
  @Binding var weekSlider: [[Date.WeekDay]]
  @Binding var currentWeekIndex: Int
  
  var body: some View {
    HStack(spacing: 9) {
      ForEach(week) { weekDay in
        Button {
          homeViewModel.send(.selectDate(weekDay.date))
        } label: {
          VStack(spacing: 8) {
            Text("\(weekDay.date.formattedToString(.weekDay))")
              .font(.pretendard(size: 12, weight: .medium))
            Text("\(weekDay.date.day)")
              .font(.pretendard(size: 16, weight: .semiBold))
          }
          .foregroundStyle(
            homeViewModel.state.currentDate == weekDay.date
            ? .white : .black
          )
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
        }
        .background {
          if weekDay.date.isSameDate(as: homeViewModel.state.currentDate) {
            RoundedRectangle(cornerRadius: 10)
              .fill(.blueMain)
          }
        }
      }
    }
    .background {
      GeometryReader {
        let minX = $0.frame(in: .global).minX
        
        Color.clear
          .preference(key: OffsetKey.self, value: minX)
          .onPreferenceChange(OffsetKey.self) { value in
            if value.rounded() == 0 && createWeek {
              paginateWeek()
              createWeek = false
            } else {
              print(value.rounded())
              print(createWeek)
            }
          }
      }
      
    }
  }
  
  func paginateWeek() {
    if weekSlider.indices.contains(currentWeekIndex) {
      if let firstDate = weekSlider[currentWeekIndex].first?.date,
         currentWeekIndex == 0 {
        weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
        weekSlider.removeLast()
        currentWeekIndex = 1
      }
      
      if let lastDate = weekSlider[currentWeekIndex].last?.date,
         currentWeekIndex == (weekSlider.count - 1) {
        weekSlider.append(lastDate.createNextWeek())
        weekSlider.removeFirst()
        currentWeekIndex = weekSlider.count - 2
      }
    }
  }
}

struct OffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  WeeklyCalendar(homeViewModel: HomeViewModel())
}
