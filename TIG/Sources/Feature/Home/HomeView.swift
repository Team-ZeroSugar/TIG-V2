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
        Color.gray01.ignoresSafeArea()
        
        VStack(spacing: 0) {
          WeeklyCalendar(homeViewModel: homeViewModel)
            
          ScrollableTabBar(homeViewModel: homeViewModel)
        }
      }
    }
  }
}


#Preview {
  HomeView()
}
