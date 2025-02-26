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
      HStack(alignment: .top, spacing: 25) {
        
        TimeIndicatorView()
        
        GroupedTimeSlotsView(
          groupedTimeSlots: homeViewModel.state.groupedTimeSlots
        )
        
        
      }.padding(.horizontal, 20)
    }
    .scrollIndicators(.hidden)
    .onAppear {
      homeViewModel.send(.onAppear)
    }
  }
}

private struct TimeIndicatorView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 25) {
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

private struct GroupedTimeSlotsView: View {
  
  let groupedTimeSlots: [GroupedTimeSlot]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(groupedTimeSlots, id: \.self) { groupedTimeSlot in
        
        let height = Double(groupedTimeSlot.count) * 39.0 - 8
        
        if groupedTimeSlot.isAvailable {
            RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(.blueTimeSlot)
              .frame(width: .infinity, height: height)
              .padding(.vertical, 4)
        } else {
          HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(.blueTimeSlot)
              .frame(width: 4, height: height)
              .padding(.vertical, 4)
            Text("비가용 시간(30분)")
              .padding(.leading, 15)
              .padding(.top, 6)
          }
        }
      }
    }.frame(maxWidth: .infinity)
  }
}

#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
