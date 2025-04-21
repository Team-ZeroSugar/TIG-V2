//
//  EditTimeView.swift
//  TIG
//
//  Created by 신승재 on 4/8/25.
//

import SwiftUI

struct EditTimeView: View {
  
  @Environment(\.dismiss) var dismiss
  @State var timeSlots: [TimeSlot]
  let editTimeViewModel: EditTimeViewModel
  
  init() {
    self.editTimeViewModel = EditTimeViewModel()
    self.timeSlots = editTimeViewModel.state.timeSlots
  }
  
  var body: some View {
    
    NavigationStack {
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
      .padding(.horizontal, 20)
      .navigationTitle("시간 수정")
      .navigationBarTitleDisplayMode(.inline)
      .scrollIndicators(.hidden)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          navigationButton(title: "취소") {
            self.dismiss()
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          navigationButton(title: "저장") {
            editTimeViewModel.send(.dailyTimeSaveTapped(timeSlots))
            self.dismiss()
          }
        }
      }
    }
  }
  
  // MARK: (F)navigationButton
  @ViewBuilder
  private func navigationButton(
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
  EditTimeView()
}
