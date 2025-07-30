//
//  ScrollableTabBar.swift
//  TIG
//
//  Created by 이정동 on 2/5/25.
//

import SwiftUI

enum HomeTab: CaseIterable, Hashable {
  case available
  case total
  
  var index: Int {
    self == .available ? 0 : 1
  }
  
  var title: String {
    self == .available ? "가용시간" : "하루시간"
  }
}

struct ScrollableTabBar: View {
  let homeViewModel: HomeViewModel
  @State private var scrollPosition: HomeTab?
  @State private var selectedTabOffset: CGFloat = 0
  
  init(homeViewModel: HomeViewModel) {
    self.homeViewModel = homeViewModel
    UIScrollView.appearance().bounces = false
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        tabBarButton(size: proxy.size)
        
        tabBarContent(size: proxy.size)
      }
      .onChange(of: scrollPosition) { _, new in
        homeViewModel.send(.changeTab(new.unsafelyUnwrapped))
        selectedTabOffset = (proxy.size.width / 2) * CGFloat(new?.index ?? 0)
      }
      .onChange(of: homeViewModel.state.selectedTab) {
        scrollPosition = $1
      }
    }
    .background(.backgroundNormal)
  }
  
  // MARK: - (F)TabBar Button
  private func tabBarButton(size: CGSize) -> some View {
    HStack(spacing: 0) {
      ForEach(HomeTab.allCases, id: \.self) { tab in
        Button {
          homeViewModel.send(.changeTab(tab))
        } label: {
          Text(tab.title)
            .font(.pretendard(size: 16, weight: .semiBold))
            .frame(width: (size.width) / 2)
            .foregroundStyle(
              homeViewModel.state.selectedTab == tab
              ? .contentStrong
              : .contentAlternative
            )
        }
      }
    }
    .padding(.vertical, 16)
    .overlay(alignment: .bottom, content: {
      ZStack(alignment: .bottomLeading) {
        Rectangle()
          .frame(height: 0.5)
          .foregroundStyle(.borderNormal)
        Rectangle()
          .frame(width: size.width / 2, height: 2)
          .foregroundStyle(.primaryNormal)
          .offset(x: selectedTabOffset)
      }
      .animation(.snappy, value: selectedTabOffset)
    })
  }
  
  // MARK: - (F)TabBar Content
  private func tabBarContent(size: CGSize) -> some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ForEach(HomeTab.allCases, id: \.self) { tab in
          VStack {
            switch tab {
            case .available:
              AvailableTimeView(homeViewModel: homeViewModel)
            case .total:
              TotalTimeView(homeViewModel: homeViewModel)
            }
          }
          .frame(width: size.width)
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $scrollPosition)
    .scrollIndicators(.hidden)
    .scrollTargetBehavior(.paging)
    .animation(.snappy, value: scrollPosition)
  }
}

#Preview {
  ScrollableTabBar(homeViewModel: HomeViewModel())
}
