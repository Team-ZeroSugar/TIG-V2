//
//  WeeklyRepeatView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct WeeklyRepeatView: View {
  @State var selectedDay: WeekDay = .sun
  @State var isEditMode = false
  
  let homeViewModel: HomeViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      WeeklyHeader(selectedDay: $selectedDay)
        
      DayPageView(selectedDay: $selectedDay, isEditMode: $isEditMode)
    }
    .background(.backgroundNormal)
    .navigationTitle(isEditMode ? "반복 일정 수정" : "반복 일정 관리")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          isEditMode.toggle()
        } label: {
          Text(isEditMode ? "저장" : "수정")
            .foregroundStyle(.primaryNormal)
            .font(.pretendard(size: 16, weight: .medium))
        }
      }
    }
  }
}

// MARK: - (S)WeeklyHeader
private struct WeeklyHeader: View {
  
  @Binding var selectedDay: WeekDay
  
  var body: some View {
    HStack {
      ForEach(WeekDay.allCases, id: \.self) { day in
        Text(day.text)
          .frame(maxWidth: .infinity)
          .foregroundStyle(
            day == selectedDay ? .contentException : .contentNormal
          )
          .font(
            .pretendard(
              size: 14,
              weight: day == selectedDay ? .semiBold : .medium
            )
          )
          .onTapGesture {
            selectedDay = day
          }
          .background(
            Circle()
              .fill(day == selectedDay ? .primaryNormal : .clear)
              .frame(width: 42, height: 42)
              .scaleEffect(selectedDay != day ? 0.85 : 1.0)
              .animation(.easeInOut(duration: 0.2), value: selectedDay)
          )
      }
    }
    .padding(26)
  }
}


// MARK: - (S)DayPageView
private struct DayPageView: View {
  
  @Binding var selectedDay: WeekDay
  @Binding var isEditMode: Bool
  
  var body: some View {
    TabView(selection: $selectedDay) {
      ForEach(WeekDay.allCases, id: \.self) { day in
        DaySlotView(isEditMode: $isEditMode)
          .tag(day)
      }
    }
    .background(.backgroundAlternative)
    .animation(.default, value: selectedDay)
    .ignoresSafeArea()
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

// MARK: - (S)DaySlotView
private struct DaySlotView: View {
  
  @Binding var isEditMode: Bool
  @State var timeSlots = TimeSlot.mock
  
  var body: some View {
    ScrollView {
      VStack {
        if isEditMode {
          SelectableTimeSlots(timeSlots: $timeSlots)
            .padding(.top, 16)
        } else {
          GroupedTimeSlots(
            groupedTimeSlots: TimeSlot.mock.groupedTimeSlots
          ).padding(.top, 18)
        }
      }
      .padding(.horizontal, 20)
      .background(.backgroundNormal)
      .padding(.top, 5)
    }
    .ignoresSafeArea()
    .scrollIndicators(.hidden)
  }
}

#Preview {
  NavigationStack {
    WeeklyRepeatView(homeViewModel: HomeViewModel())
  }
}
