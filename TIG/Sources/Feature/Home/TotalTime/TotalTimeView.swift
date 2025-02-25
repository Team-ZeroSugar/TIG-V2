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
        VStack {
          ForEach(0..<48) { index in
            let meridiemText = (index / 2) < 12 ? "오전" : "오후"
            let hour = (index / 2) % 12 == 0 ? 12 : (index / 2) % 12
            HStack {
              Text("\(meridiemText) \(hour)")
                .font(.pretendard(size: 12, weight: .medium))
                .foregroundStyle(.gray03)
                .frame(width: 47, height: 14, alignment: .leading)
                .opacity(index % 2 == 0 ? 1 : 0)
            }
          }
        }
        VStack {
          ForEach(groupedTimeSlots, id: \.self) { groupedTimeSlot in
            
          }
        }
      }
    }.onAppear {
      homeViewModel.send(.onAppear)
    }
  }
}

#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
