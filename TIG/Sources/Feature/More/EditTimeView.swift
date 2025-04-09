//
//  EditTimeView.swift
//  TIG
//
//  Created by 신승재 on 4/8/25.
//

import SwiftUI

struct EditTimeView: View {
  
  @State var timeSlots: [TimeSlot] = TimeSlot.mock
  @Binding var isPresented: Bool
  
  var body: some View {
    
    
    HeaderView(isPresented: $isPresented)
    
    ScrollView {
      
      Text("수면, 식사 시간 등 비가용시간을 선택해 주세요")
        .foregroundStyle(.contentNormal)
        .font(.pretendard(size: 14, weight: .regular))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(.borderPrimary, lineWidth: 1)
        ).padding(.top, 16)
      
      SelectableTimeSlots(timeSlots: $timeSlots)
        .padding(.top, 4)
      
    }
    .scrollIndicators(.hidden)
    .padding(.horizontal, 20)
  }
}

private struct HeaderView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    HStack {
      headerButton(title: "취소") {
        isPresented = false
      }
      
      Spacer()
      
      headerButton(title: "저장") {
        print("저장 버튼")
      }
    }
    .overlay(
      Text("시간 수정")
        .foregroundStyle(.contentStrong)
        .font(.pretendard(size: 16, weight: .semiBold)),
      alignment: .center
    )
    .padding(.vertical, 10)
    .padding(.horizontal, 20)
  }
  
  @ViewBuilder
  private func headerButton(
    title: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Text(title)
        .foregroundStyle(.primaryNormal)
        .font(.pretendard(size: 16, weight: .regular))
    }
  }
}

#Preview {
  EditTimeView(isPresented: .constant(true))
}
