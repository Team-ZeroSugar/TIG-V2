//
//  SelectableTimeSlots.swift
//  TIG
//
//  Created by 신승재 on 4/9/25.
//

import SwiftUI

struct SelectableTimeSlots: View {
  
  @Binding var timeSlots: [TimeSlot]
  
  var body: some View {
    VStack(spacing: 20) {
      
      HStack(spacing: 10) {
        statusLabel(title: "가용시간", filled: true)
        statusLabel(title: "비가용시간", filled: false)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      
      HStack(alignment: .top, spacing: 17) {
        TimeIndicator()
        TimeSlots(timeSlots: $timeSlots)
      }
    }.padding(.bottom, 29)
  }
  
  @ViewBuilder
  private func statusLabel(title: String, filled: Bool) -> some View {
    HStack(spacing: 6) {
      Circle()
        .strokeBorder(filled ? .clear : .primaryNeutral, lineWidth: 1)
        .fill(filled ? .primaryNeutral : .clear)
        .frame(width: 12, height: 12)
      
      Text(title)
        .foregroundStyle(.contentNormal)
        .font(.pretendard(size: 10, weight: .regular))
    }
  }
}

// MARK: - (S)TimeSlots
private struct TimeSlots: View {
  
  @Binding var timeSlots: [TimeSlot]
  
  var body: some View {
    VStack(spacing: SlotLayout.space * 2) {
      ForEach($timeSlots) { $timeSlot in
        Button {
          timeSlot.isAvailable.toggle()
        } label: {
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(
              timeSlot.isAvailable ? .clear : .primaryNeutral, lineWidth: 1.5
            )
            .fill(timeSlot.isAvailable ? .primaryNeutral : .clear)
            .frame(height: SlotLayout.height)
        }
        
      }
    }.padding(.vertical, SlotLayout.space)
  }
}

#Preview {
  ScrollView {
    SelectableTimeSlots(timeSlots: .constant(TimeSlot.mock))
  }
  .scrollIndicators(.hidden)
  .padding(.horizontal, 20)
}
