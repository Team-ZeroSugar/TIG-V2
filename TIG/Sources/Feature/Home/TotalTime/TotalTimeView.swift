//
//  TotalTimeView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct TotalTimeView: View {
  @State var isPresented = false
  let homeViewModel: HomeViewModel
  
  var body: some View {
    ScrollView {
      GroupedTimeSlots(groupedTimeSlots: homeViewModel.state.groupedTimeSlots)
    }
    .padding(.horizontal, 20)
    .scrollIndicators(.hidden)
    .onTapGesture {
      isPresented = true
    }
    .fullScreenCover(isPresented: $isPresented) {
      EditTimeView()
    }
  }
}

#Preview {
  let homeViewModel = HomeViewModel()
  
  TotalTimeView(homeViewModel: homeViewModel)
    .onAppear {
      homeViewModel.send(.onAppear)
    }
}
