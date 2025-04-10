//
//  SettingView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct SettingView: View {
  @State private var mockDate: Date = Date()
  @State var isPresented: Bool = false
  
  var body: some View {
    VStack {
      List {
        Section("수면 시간 수정") {
          HStack {
            Text("기상 시간")
            Spacer()
            DatePicker("", selection: $mockDate, displayedComponents: .hourAndMinute)
          }
          HStack {
            Text("기상 시간")
            Spacer()
            DatePicker("", selection: $mockDate, displayedComponents: .hourAndMinute)
          }
        }
      }
    }
    .navigationTitle("수면 시간")
    .navigationBarTitleDisplayMode(.inline)

  }
}

#Preview {
  NavigationStack {
    SettingView()
  }
}
