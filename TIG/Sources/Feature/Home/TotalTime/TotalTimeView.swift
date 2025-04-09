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
        
        TimeIndicator()
        
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


// MARK: - (S)GroupedTimeSlotsView
private struct GroupedTimeSlotsView: View {
  
  let groupedTimeSlots: [GroupedTimeSlot]
  
  var body: some View {
    VStack(alignment: .leading, spacing: SlotLayout.space * 2) {
      ForEach(groupedTimeSlots, id: \.self) { groupedTimeSlot in
        if groupedTimeSlot.isAvailable {
          AvailableSlot(groupedTimeSlot: groupedTimeSlot)
        } else {
          UnavailableSlot(groupedTimeSlot: groupedTimeSlot)
        }
      }
    }.padding(.vertical, SlotLayout.space)
  }
}

// MARK: - (S)AvailableSlot
private struct AvailableSlot: View {
  
  let groupedTimeSlot: GroupedTimeSlot
  
  var body: some View {
    
    let (start, end) = (groupedTimeSlot.start, groupedTimeSlot.end)
    let slotCount = groupedTimeSlot.count
    let duration = slotCount * Time.interval
    
    VStack(alignment: .leading) {
      if slotCount == 1 {
        durationText(duration)
          .frame(maxWidth: .infinity, alignment: .trailing)
      } else {
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
          
          durationText(duration)
            .frame(
              height: SlotLayout.groupedHeight(for: slotCount) - 47,
              alignment: .bottom
            )
        }
      }
    }
    .padding(.horizontal, 20)
    .frame(height: SlotLayout.groupedHeight(for: slotCount))
    .background(
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(.blueTimeSlot)
    )
  }
  
  // MARK: (F)durationText
  @ViewBuilder
  private func durationText(_ duration: Int) -> some View {
    Text(duration.time(format: .duration_kr))
      .foregroundStyle(.contentNormal)
      .font(.pretendard(size: 20, weight: .semiBold))
  }
}

// MARK: - (S)UnavailableSlot
private struct UnavailableSlot: View {
  
  let groupedTimeSlot: GroupedTimeSlot
  
  var body: some View {
    
    let slotCount = groupedTimeSlot.count
    let duration = slotCount * Time.interval
    
    HStack(alignment: .top, spacing: 15) {
      RoundedRectangle(cornerRadius: 4)
        .foregroundStyle(.primaryNeutral)
        .frame(width: 4, height: SlotLayout.groupedHeight(for: slotCount))
      
      Text("비가용 시간(\(duration.time(format: .duration_kr)))")
        .foregroundStyle(.contentAlternative)
        .font(.pretendard(size: 12, weight: .medium))
        .padding(.top, 11)
    }
  }
}

#Preview {
  TotalTimeView(homeViewModel: HomeViewModel())
}
