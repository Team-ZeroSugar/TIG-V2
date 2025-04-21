//
//  MainView.swift
//  TIG
//
//  Created by 이정동 on 1/23/25.
//

import SwiftUI

struct HomeView: View {
  @State private var homeViewModel = HomeViewModel()
  @State private var isPresented: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        WeeklyCalendar(homeViewModel: homeViewModel)
          .padding(.top, 6)
        
        ScrollableTabBar(homeViewModel: homeViewModel)
          .clipShape(.rect(
            topLeadingRadius: 20,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 20,
            style: .circular
          ))
      }
      .ignoresSafeArea(.all, edges: .bottom)
      .background(.blueBg)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          calendarButton
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          menuButton
        }
      }
      .sheet(isPresented: $isPresented) {
        CalendarPickerView(
          homeViewModel: homeViewModel,
          isPresented: $isPresented
        )
          .presentationDetents([.fraction(0.6)])
          .presentationCornerRadius(20)
      }
      .onAppear {
        homeViewModel.send(.onAppear)
      }
      .onDisappear {
        homeViewModel.send(.onDisappear)
      }
    }
  }
  
  @ViewBuilder
  private var calendarButton: some View {
    let currentDate = homeViewModel.state.selectedDate
    Button {
      isPresented = true
    } label: {
      HStack {
        Text(currentDate.string(format: .yearMonth_kr))
          .font(.pretendard(size: 16, weight: .semiBold))
          .foregroundStyle(.gray06)
        
        Image(systemName: "chevron.down")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 15, height: 15)
          .foregroundColor(.gray06)
      }
    }
  }
  
  // MARK: - (F)MenuButton
  private var menuButton: some View {
    Menu {
      NavigationLink {
        WeeklyRepeatView(homeViewModel: homeViewModel)
      } label: {
        Label(
          "반복 관리",
          systemImage: "clock.arrow.circlepath"
        )
      }
      
      NavigationLink {
        SettingView()
      } label: {
        Label("수면 시간", systemImage: "moon")
      }
    } label: {
      Image(systemName: "ellipsis")
        .foregroundStyle(.gray06)
    }
  }
}

private struct CalendarPickerView: View {
  let homeViewModel: HomeViewModel
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack(spacing: 31) {
      DatePicker(
        "",
        selection: .init(
          get: { homeViewModel.state.selectedDate },
          set: { homeViewModel.send(.selectDate($0)) }
        ),
        displayedComponents: .date
      )
      .datePickerStyle(.graphical)
      
      Button {
        homeViewModel.send(.selectDate(.now))
        isPresented = false
      } label: {
        Label(
          "오늘로 돌아가기",
          systemImage: "arrow.clockwise"
        )
        // TODO: 디자이너한테 전달
        .font(.pretendard(size: 14, weight: .regular))
      }
      // TODO: 디자이너한테 전달
      .padding(.vertical, 6)
      .padding(.horizontal, 16)
      .overlay {
        RoundedRectangle(cornerRadius: 40)
          .stroke(lineWidth: 1)
          .fill(.blueMain)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.vertical, 24)
    .padding(.horizontal, 16)
    .onChange(of: homeViewModel.state.selectedDate) { _, _ in
      isPresented = false
    }
  }
}

#Preview {
  HomeView()
}

#Preview {
  CalendarPickerView(
    homeViewModel: HomeViewModel(),
    isPresented: .constant(true)
  )
}
