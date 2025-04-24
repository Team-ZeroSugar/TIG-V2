//
//  WeeklyRepeatAnnounceView.swift
//  TIG
//
//  Created by 이정동 on 4/9/25.
//

import SwiftUI

struct WeeklyRepeatAnnounceView: View {
  
  let editTimeViewModel: EditTimeViewModel
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      
      Image(.availableIcon)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 48)
      
      Text("반복 일정을 설정해 보세요")
        .font(.pretendard(size: 18, weight: .semiBold))
        .foregroundStyle(.contentStrong)
        .padding(.top, 24)
      
      Text("요일별로 고정된 일정을 반복할 수 있어요")
        .font(.pretendard(size: 14, weight: .regular))
        .foregroundStyle(.contentNormal)
        .padding(.top, 12)
      
      Button(action: {
        editTimeViewModel.send(.settingButtonTapped)
      }, label: {
        Text("설정하기")
          .font(.pretendard(size: 15, weight: .regular))
          .foregroundStyle(.exceptionNormal)
          .padding(.vertical, 8)
          .padding(.horizontal, 20)
          .background(.primaryNormal)
          .clipShape(Capsule())
      })
      .padding(.top, 32)
    }
  }
}

#Preview {
  WeeklyRepeatAnnounceView(editTimeViewModel: EditTimeViewModel())
}
