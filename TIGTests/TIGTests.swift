//
//  TIGTests.swift
//  TIGTests
//
//  Created by 신승재 on 2/13/25.
//

import XCTest
@testable import TIG

final class TIGTests: XCTestCase {
  
  var appConfigRepository: AppConfigRepository?
  var dailyScheduleRepository: DailyScheduleRepository?
  var weeklyScheduleRepository: WeeklyScheduleRepository?
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    let testSwiftDataStorage = SwiftDataStorage()
    appConfigRepository = AppConfigRepositoryImpl(
      modelContext: testSwiftDataStorage.modelContext
    )
    dailyScheduleRepository = DailyScheduleRepositoryImpl(
      modelContext: testSwiftDataStorage.modelContext
    )
    weeklyScheduleRepository = WeeklyScheduleRepositoryImpl(
      modelContext: testSwiftDataStorage.modelContext
    )
  }
  
  override func tearDownWithError() throws {
    appConfigRepository = nil
    dailyScheduleRepository = nil
    weeklyScheduleRepository = nil
    try super.tearDownWithError()
  }
  
  
  // MARK: - AppConfigRepository 테스트
  func testAppConfigRepository() throws {
    
    guard let appConfigRepository = appConfigRepository else {
      XCTFail("appConfigRepository가 nil입니다.")
      return
    }
    
    // 1. 온보딩 완료 설정 및 초기 값 검증
    let initialWakeupTime = 1
    let initialBedTime = 1
    
    appConfigRepository.setOnboardingCompleted(
      wakeupTime: initialWakeupTime,
      bedTime: initialBedTime
    )
    
    // 1-1. 초기 기상 시간 확인
    let wakeupTimeFetchResultInitial = appConfigRepository.fetchWakeupTime()
    switch wakeupTimeFetchResultInitial {
    case .success(let data):
      XCTAssertEqual(initialWakeupTime, data, "초기 기상 시간이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetchWakeupTime 실패: \(error)")
    }
    
    // 1-2. 초기 취침 시간 확인
    let bedTimeFetchResultInitial = appConfigRepository.fetchBedTime()
    switch bedTimeFetchResultInitial {
    case .success(let data):
      XCTAssertEqual(initialBedTime, data, "초기 취침 시간이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetchBedTime 실패: \(error)")
    }
    
    // 2. 온보딩 완료 상태 검증
    let onboardingFetchResult = appConfigRepository.fetchOnboardingStatus()
    switch onboardingFetchResult {
    case .success(let data):
      XCTAssertTrue(data, "온보딩 완료 상태가 true가 아닙니다.")
    case .failure(let error):
      XCTFail("fetchOnboardingStatus 실패: \(error)")
    }
    
    // 3. 기상 시간 업데이트 후 검증
    let mockWakeupTime = 20
    
    appConfigRepository.updateWakeupTime(mockWakeupTime)
    let wakeupTimeFetchResultUpdated = appConfigRepository.fetchWakeupTime()
    switch wakeupTimeFetchResultUpdated {
    case .success(let data):
      XCTAssertEqual(mockWakeupTime, data, "업데이트된 기상 시간이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetchWakeupTime 업데이트 실패: \(error)")
    }
    
    // 4. 취침 시간 업데이트 후 검증
    let mockBedTime = 30
    
    appConfigRepository.updateBedTime(mockBedTime)
    let bedTimeFetchResultUpdated = appConfigRepository.fetchBedTime()
    switch bedTimeFetchResultUpdated {
    case .success(let data):
      XCTAssertEqual(mockBedTime, data, "업데이트된 취침 시간이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetchBedTime 업데이트 실패: \(error)")
    }
  }
  
  // MARK: - DailyScheduleRepository 테스트
  func testDailyScheduleRepository() throws {
    guard let dailyScheduleRepository = dailyScheduleRepository else {
      XCTFail("appConfigRepository가 nil입니다.")
      return
    }
    
    // 1. DailySchedule 생성
    let today = Date()
    var mokDailySchedule = DailySchedule(
      date: today,
      timeSlots: [TimeSlot(start: 1, end: 1, isAvailable: true)]
    )
    
    dailyScheduleRepository.createDailySchedule(mokDailySchedule)
    
    // 2. DailySchedule 확인
    let fetchResultInitial = dailyScheduleRepository.fetchDailySchedule(date: today)
    switch fetchResultInitial {
    case .success(let data):
      guard let data = data else {
        XCTFail("DailySchedule이 nil 입니다.")
        return
      }
      XCTAssertEqual(mokDailySchedule, data, "DailySchedule이 일치하지 않습니다.")
      
    case .failure(let error):
      XCTFail("fetch DailySchedule 실패: \(error)")
    }
    
    // 3. DailySchedule 업데이트
    let mokTimeSlots = [
      TimeSlot(start: 1, end: 1, isAvailable: true),
      TimeSlot(start: 2, end: 2, isAvailable: true)
    ]
    dailyScheduleRepository.updateDailySchedule(
      dailySchedule: mokDailySchedule,
      timeSlots: mokTimeSlots
    )
    
    // 4. 업데이트 된 DailySchedule 확인
    mokDailySchedule.timeSlots = mokTimeSlots
    
    let fetchResult = dailyScheduleRepository.fetchDailySchedule(date: today)
    switch fetchResult {
    case .success(let data):
      guard let data = data else {
        XCTFail("DailySchedule이 nil 입니다.")
        return
      }
      XCTAssertEqual(mokDailySchedule, data, "DailySchedule이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetch DailySchedule 실패: \(error)")
    }
    
    // 5. 모든 dailySchedule 확인
    let allFetchResult = dailyScheduleRepository.fetchAllDailySchedules()
    switch allFetchResult {
    case .success(let datas):
      print(datas)
    case .failure(let error):
      XCTFail("fetch All DailySchedules 실패: \(error)")
    }
  }
  
  // MARK: - WeeklyScheduleRepository 테스트
  func testWeeklyScheduleRepository() throws {
    guard let weeklyScheduleRepository = weeklyScheduleRepository else {
      XCTFail("weeklyScheduleRepository가 nil입니다.")
      return
    }
    
    var allWeeklySchedules: [WeeklySchedule] = []
    
    // 1. WeeklySchedules 초기화
    weeklyScheduleRepository.initializeWeeklySchedules()
    
    // 2. WeeklySchedule 업데이트 및 확인
    WeekDay.allCases.forEach { weekDay in
      let mokWeeklySchedule = WeeklySchedule(
        day: weekDay,
        timeSlots: [TimeSlot(start: 1, end: 1, isAvailable: true)]
      )
      allWeeklySchedules.append(mokWeeklySchedule)
      
      weeklyScheduleRepository.updateWeeklySchedule(
        weeklySchedule: mokWeeklySchedule,
        timeSlots: mokWeeklySchedule.timeSlots
      )
      
      let fetchResult = weeklyScheduleRepository.fetchWeeklySchedule(
        weekDay: weekDay
      )
      switch fetchResult {
      case .success(let data):
        guard let data = data else {
          XCTFail("\(weekDay)의 WeeklySchedule이 nil 입니다.")
          return
        }
        XCTAssertEqual(mokWeeklySchedule, data, "\(weekDay)의 WeeklySchedule이 일치하지 않습니다.")
      case .failure(let error):
        XCTFail("\(weekDay)의 fetch WeeklySchedule 실패: \(error)")
      }
    }
    
    // 5. 모든 weeklySchedules 확인
    let allFetchResult = weeklyScheduleRepository.fetchAllWeeklySchedules()
    switch allFetchResult {
    case .success(let datas):
      XCTAssertEqual(datas, allWeeklySchedules, "All WeeklySchedule이 일치하지 않습니다.")
    case .failure(let error):
      XCTFail("fetch All WeeklySchedules 실패: \(error)")
    }
  }
}

