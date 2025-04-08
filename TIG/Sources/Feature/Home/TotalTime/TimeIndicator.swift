//
//  TimeIndicator.swift
//  TIG
//
//  Created by 신승재 on 4/8/25.
//

import SwiftUI

struct TimeIndicator: View {
  var body: some View {
    VStack(alignment: .leading, spacing: SlotLayout.height - 10) {
      ForEach(0..<49) { index in
        let meridiem = (index / 2) < 12 ? "오전" : "오후"
        let hour = (index / 2) % 12 == 0 ? 12 : (index / 2) % 12
        HStack(alignment: .top) {
          
          Text("\(meridiem) \(hour)시")
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundStyle(.contentAlternative)
            .frame(width: 47, height: 14, alignment: .leading)
            .opacity(index % 2 == 0 ? 1 : 0)
            .offset(y: -7)
          
          Rectangle()
            .frame(width: index % 2 == 0 ? 24 : 16, height: 1)
            .foregroundStyle(.borderNormal)
        }
      }
    }
  }
}

#Preview {
    TimeIndicator()
}
