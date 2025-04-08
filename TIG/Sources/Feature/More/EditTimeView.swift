//
//  EditTimeView.swift
//  TIG
//
//  Created by 신승재 on 4/8/25.
//

import SwiftUI

struct EditTimeView: View {
  @Binding var isPresented: Bool
  var body: some View {
    VStack {
      HeaderView(isPresented: $isPresented)
    }.padding(.horizontal, 20)
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
