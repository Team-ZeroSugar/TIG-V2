//
//  HomeViewModel.swift
//  TIG
//
//  Created by 이정동 on 2/4/25.
//

import Foundation
import Combine

@Observable
final class HomeViewModel {
  struct State {
    // 탭바 상태
    var selectedTab: HomeTab = .available
  }
  
  enum Action {
    case onAppear
    
    // 주간 캘린더 액션
    case changeDate(Date)
    
    // 탭바 액션
    case changeTab(HomeTab)

  }
  
  private(set) var sharedState: SharedState = DIContainer.shared.resolve()
  private(set) var state: State = .init()
  
  private let appConfigRepository: AppConfigRepository = DIContainer.shared.resolve()
  private let dailyScheduleRepository: DailyScheduleRepository = DIContainer.shared.resolve()
  private let weeklyScheduleRepository: WeeklyScheduleRepository = DIContainer.shared.resolve()
  
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      // TODO: 첫 진입 시에만 호출되도록 수정 필요할 듯
      initializeTimeSlot(date: sharedState.selectedDate)
      
    case .changeDate(let date):
      sharedState.selectedDate = date.formattedDate
      initializeTimeSlot(date: date)
      
    case .changeTab(let tab):
      state.selectedTab = tab
    }
  }
}

// MARK: - TimeSlot Function
private extension HomeViewModel {
  /// 특정 날짜에 맞는 TimeSlots로 상태를 초기화 합니다.
  /// - Parameter date: 날짜
  func initializeTimeSlot(date: Date) {
    
    let result = fetchDailySchedule(date: date)
    switch result {
    case .success(let dailySchedule):
      sharedState.timeSlots = dailySchedule.timeSlots
    case .failure:
      break
    }
  }
  
  /// DB에서 해당 날짜에 맞는 DailySchedule을 가져옵니다.
  /// 없는 경우, WeeklySchedule 또는 수면 시간 기준으로 생성합니다.
  /// - Parameter date: 불러올 날짜
  /// - Returns: DailySchedule
  func fetchDailySchedule(date: Date) -> Result<DailySchedule, Error> {
    // 1. DailySchedule이 있으면 바로 반환
    switch dailyScheduleRepository.fetchDailySchedule(date: date) {
    case .success(let dailySchedule):
      if let dailySchedule {
        return .success(dailySchedule)
      }
      
    case .failure(let error):
      return .failure(error)
    }
    
    // 2. 설정된 WeeklySchedule로 DailySchedule 불러오기
    let weekDay = WeekDay(rawValue: date.weekday - 1)!
    switch weeklyScheduleRepository.fetchWeeklySchedule(weekDay: weekDay) {
    case .success(let weeklySchedule):
      if let weeklySchedule {
        let dailySchedule = DailySchedule(
          date: date.formattedDate,
          timeSlots: weeklySchedule.timeSlots
        )
        
        // 오늘 날짜의 dailySchedule인 경우 저장
        if date.isToday {
          dailyScheduleRepository.createDailySchedule(dailySchedule)
        }
        
        return .success(dailySchedule)
      }
      
    case .failure(let error):
      return .failure(error)
    }
    
    // 3. 설정된 수면 시간 기준으로 DailySchedule 불러오기
    do {
      let wakeup = try appConfigRepository.fetchWakeupTime().get()
      let bed = try appConfigRepository.fetchBedTime().get()
      
      let timeSlots = stride(from: 0, to: Time.hour * 24, by: Time.interval).map {
        TimeSlot(
          start: $0,
          end: $0 + Time.interval,
          isAvailable: wakeup <= $0 && $0 < bed
        )
      }
      
      // 오늘 날짜의 dailySchedule인 경우 저장
      let dailySchedule = DailySchedule(date: date.formattedDate, timeSlots: timeSlots)
      if date.isToday {
        dailyScheduleRepository.createDailySchedule(dailySchedule)
      }
      
      return .success(dailySchedule)
      
    } catch {
      return .failure(error)
    }
  }
}
