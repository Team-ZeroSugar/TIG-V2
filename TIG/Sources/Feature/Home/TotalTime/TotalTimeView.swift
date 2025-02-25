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
    
    let groupedTimeSlots = homeViewModel.state.groupedTimeSlots
    ScrollView {
      HStack {
        
        TimeIndicatorView()
        
        VStack {
          ForEach(groupedTimeSlots, id: \.self) { groupedTimeSlot in
            
          }
        }
      }
    }
    .scrollIndicators(.hidden)
    .onAppear {
      homeViewModel.send(.onAppear)
    }
  }
}

fileprivate struct TimeIndicatorView: View {
  var body: some View {
    VStack(alignment: .trailing, spacing: 39) {
      ForEach(0..<49) { idx in
        let meridiemText = (idx / 2) < 12 ? "오전" : "오후"
        let hour = (idx / 2) % 12 == 0 ? 12 : (idx / 2) % 12
        HStack(alignment: .top) {
          
          Text("\(meridiemText) \(hour)시")
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundStyle(.gray03)
            .frame(width: 47, height: 14, alignment: .leading)
            .opacity(idx % 2 == 0 ? 1 : 0)
            .offset(y: -7)
          
          Rectangle()
            .frame(width: idx % 2 == 0 ? 24 : 16, height: 1)
            .foregroundStyle(.gray02)
        }
      }
    }
  }
}

#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
