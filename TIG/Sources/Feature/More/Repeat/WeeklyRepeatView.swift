//
//  WeeklyRepeatView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct WeeklyRepeatView: View {
  
  @State private var editTimeViewModel = EditTimeViewModel()
  @State private var selectedDay: WeekDay = .sun
  @State private var isEditMode = false
  
  private var isInitial: Bool {
    editTimeViewModel.state.weeklyTimeSlots.isEmpty
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if isInitial {
        WeeklyRepeatAnnounceView(editTimeViewModel: editTimeViewModel)
      } else {
        
        WeeklyHeader(selectedDay: $selectedDay)
        DayPageView(
          selectedDay: $selectedDay,
          isEditMode: $isEditMode,
          editTimeViewModel: editTimeViewModel
        )
        
      }
    }
    .background(isInitial ? .backgroundNormal : .backgroundAlternative)
    .navigationTitle(isEditMode ? "반복 일정 수정" : "반복 일정 관리")
    .navigationBarTitleDisplayMode(.inline)
    .animation(.easeInOut(duration: 0.3), value: isInitial)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        editButton()
      }
    }
    .onAppear {
      editTimeViewModel.send(.onAppearWeeklyRepeat)
    }
  }
  
  // MARK: (F)EditButton
  @ViewBuilder
  private func editButton() -> some View {
    Button {
      if isEditMode {
        editTimeViewModel.send(.weeklyTimeSaveTapped)
      }
      isEditMode.toggle()
    } label: {
      Text(isEditMode ? "저장" : "수정")
        .foregroundStyle(isInitial ? .clear : .primaryNormal)
        .font(.pretendard(size: 16, weight: .medium))
    }
    .disabled(isInitial)
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
    .background(.backgroundNormal)
    .padding(.bottom, 5)
  }
}


// MARK: - (S)DayPageView
private struct DayPageView: View {
  
  @Binding var selectedDay: WeekDay
  @Binding var isEditMode: Bool
  
  let editTimeViewModel: EditTimeViewModel
  
  var body: some View {
    TabView(selection: $selectedDay) {
      ForEach(WeekDay.allCases, id: \.self) { day in
        TimeSlotsView(isEditMode: $isEditMode, timeSlots: binding(for: day))
          .tag(day)
      }
    }
    .background(.backgroundNormal)
    .ignoresSafeArea()
    .animation(.spring(duration: 2), value: selectedDay)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
  
  // state.weeklyTimeSlots <-> @Binding timeSlots을 해주는 함수
  private func binding(for key: WeekDay) -> Binding<[TimeSlot]> {
    return Binding(
      get: { return editTimeViewModel.state.weeklyTimeSlots[key] ?? [] },
      set: { editTimeViewModel.send(.onChangeWeeklyTimeSlot(key, $0)) }
    )
  }
}

// MARK: - (S)TimeSlotsView
private struct TimeSlotsView: View {
  
  @Binding var isEditMode: Bool
  @Binding var timeSlots: [TimeSlot]
  
  var body: some View {
    ScrollView {
      VStack {
        if isEditMode {
          SelectableTimeSlots(timeSlots: $timeSlots)
            .padding(.top, 16)
        } else {
          GroupedTimeSlots(
            groupedTimeSlots: timeSlots.groupedTimeSlots
          ).padding(.top, 19)
        }
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea()
    .scrollIndicators(.hidden)
  }
}

#Preview {
  NavigationStack {
    WeeklyRepeatView()
  }
}
