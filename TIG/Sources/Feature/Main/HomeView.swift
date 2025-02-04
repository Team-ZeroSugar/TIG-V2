//
//  MainView.swift
//  TIG
//
//  Created by 이정동 on 1/23/25.
//

import SwiftUI

struct HomeView: View {
  @State private var homeViewModel = HomeViewModel()
  var body: some View {
    NavigationStack {
      ZStack {
        Color.gray03.ignoresSafeArea()
        
        ScrollableTabBar(homeViewModel: homeViewModel)
      }
    }
  }
}

// MARK: - ScrollableTabBar
private struct ScrollableTabBar: View {
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
        homeViewModel.send(.tabChange(new.unsafelyUnwrapped))
        selectedTabOffset = (proxy.size.width / 2) * CGFloat(new?.index ?? 0)
      }
      .onChange(of: homeViewModel.state.selectedTab) {
        scrollPosition = $1
      }
    }
  }
  
  // MARK: - (F)TabBar Button
  private func tabBarButton(size: CGSize) -> some View {
    HStack(spacing: 0) {
      ForEach(HomeTab.allCases, id: \.self) { tab in
        Button {
          homeViewModel.send(.tabChange(tab))
        } label: {
          Text(tab.title)
            .font(.pretendard(size: 18, weight: .semiBold))
            .frame(
              width: (size.width) / 2,
              height: 40
            )
            .padding(.vertical, 12)
            .foregroundStyle(
              homeViewModel.state.selectedTab == tab
              ? .gray05
              : .gray02
            )
            .contentShape(Rectangle())
        }
      }
    }
    .overlay(alignment: .bottomLeading, content: {
      ZStack(alignment: .bottomLeading) {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(.gray05)
        Rectangle()
          .frame(width: size.width / 2, height: 4)
          .foregroundStyle(.blueMain)
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
              Text("가용시간")
            case .total:
              Text("하루시간")
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

#Preview {
  HomeView()
}
