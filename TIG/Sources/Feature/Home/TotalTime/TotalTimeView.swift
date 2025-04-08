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
      HStack(alignment: .top, spacing: 18) {
        
        TimeIndicatorView()
        
        GroupedTimeSlotsView(groupedTimeSlots: homeViewModel.state.groupedTimeSlots)
        
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 29)
      
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
      ForEach(0..<49) { index in
        let meridiem = (index / 2) < 12 ? "오전" : "오후"
        let hour = (index / 2) % 12 == 0 ? 12 : (index / 2) % 12
        HStack(alignment: .top) {
          
          Text("\(meridiem) \(hour)시")
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundStyle(.gray03)
            .frame(width: 47, height: 14, alignment: .leading)
            .opacity(index % 2 == 0 ? 1 : 0)
            .offset(y: -7)
          
          Rectangle()
            .frame(width: index % 2 == 0 ? 24 : 16, height: 1)
            .foregroundStyle(.gray02)
        }
      }
    }
  }
}

private struct GroupedTimeSlotsView: View {
  
  let groupedTimeSlots: [GroupedTimeSlot]
  
  private let slotHeight = 35.0
  private let slotSpace = 2.0
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(groupedTimeSlots, id: \.self) { groupedTimeSlot in
        
        let (start, end, slotCount) = (groupedTimeSlot.start, groupedTimeSlot.end, groupedTimeSlot.count)
        let duration = slotCount * Time.interval
        let groupedHeight = Double(slotCount) * slotHeight + Double(slotCount - 1) * (slotSpace * 2)
        
        if groupedTimeSlot.isAvailable {
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(.blueTimeSlot)
              .frame(height: groupedHeight)
            
            if slotCount == 1 {
              Text(duration.time(format: .duration_kr))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(.contentNormal)
                .font(.pretendard(size: 20, weight: .semiBold))
                .padding(.trailing, 20)
            } else {
              VStack(alignment: .leading, spacing: 8) {
                Text("\(start.time(format: .ampm_kr)) - \(end.time(format: .ampm_kr))")
                  .foregroundStyle(.contentNormal)
                  .font(.pretendard(size: 12, weight: .medium))
                
                HStack(alignment: .top) {
                  Text("가용시간")
                    .foregroundStyle(.contentException)
                    .font(.pretendard(size: 12, weight: .medium))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(.primaryNormal)
                    .clipShape(Capsule())
                  
                  Spacer()
                  
                  Text(duration.time(format: .duration_kr))
                    .foregroundStyle(.contentNormal)
                    .font(.pretendard(size: 20, weight: .semiBold))
                    .frame(height: groupedHeight - 47, alignment: .bottom)
                }
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 13)
            }
          }.padding(.vertical, slotSpace)
            
        } else {
          HStack(alignment: .top, spacing: 15) {
            RoundedRectangle(cornerRadius: 4)
              .foregroundStyle(.blueTimeSlot)
              .frame(width: 4, height: groupedHeight)
              .padding(.vertical, slotSpace)
              
            Text("비가용 시간(\(duration.time(format: .duration_kr)))")
              .foregroundStyle(.contentAlternative)
              .font(.pretendard(size: 12, weight: .medium))
              .padding(.top, slotCount == 1 ? 12 : 19)
          }
        }
      }
    }.frame(maxWidth: .infinity)
  }
}



#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
