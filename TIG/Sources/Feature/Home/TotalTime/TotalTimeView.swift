//
//  TotalTimeView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct TotalTimeView: View {
  
  let homeViewModel: HomeViewModel
  
  var body: some View {
    ScrollView {
      GroupedTimeSlots(groupedTimeSlots: homeViewModel.state.groupedTimeSlots)
    }
    .padding(.horizontal, 20)
    .scrollIndicators(.hidden)
    .onAppear {
      homeViewModel.send(.onAppear)
    }
  }
}

#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
