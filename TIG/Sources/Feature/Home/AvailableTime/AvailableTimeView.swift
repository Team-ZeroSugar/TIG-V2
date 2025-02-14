//
//  AvailableTimeView.swift
//  TIG
//
//  Created by 이정동 on 2/3/25.
//

import SwiftUI

struct AvailableTimeView: View {
  let homeViewModel: HomeViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      CurrentTimeView()
        .padding(.top, 40)
      TimerView()
        .padding(.top, 34)
      FooterView()
        .padding(.top, 36)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.bottom, 10)
  }
}

private struct CurrentTimeView: View {
  var body: some View {
    VStack(spacing: 8) {
      Text("오전 11:00 - 오후 2:00")
        .font(.pretendard(size: 16, weight: .medium))
        .foregroundStyle(.gray04)
      
      HStack(spacing: 0) {
        Text("지금은 ")
        Text("가용시간")
          .foregroundStyle(.blueMain)
        Text("이에요")
      }
      .font(.pretendard(size: 20, weight: .semiBold))
      .foregroundStyle(.gray05)
    }
  }
}

private struct TimerView: View {
  
  var body: some View {
    ZStack {
      progressCircle
      
      progressText
    }
    .padding(.horizontal, 41.5)
  }
  
  private var progressCircle: some View {
    ZStack {
      Circle()
        .fill(Color.clear)
        .overlay(
          Circle().stroke(.gray02, lineWidth: 10)
        )
      
      Circle()
        .trim(from: 0.25, to: 1)
        .stroke(
          style: StrokeStyle(
            lineWidth: 10,
            lineCap: .square,
            lineJoin: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .foregroundStyle(.blueMain)
    }
  }
  
  private var progressText: some View {
    VStack(spacing: 17) {
      Text("남은 가용시간")
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundStyle(.gray01)
        .padding(.vertical, 6)
        .padding(.horizontal, 12.5)
        .background(.blueMain)
        .clipShape(Capsule())
      
      Text("1시간 30분")
        .font(.pretendard(size: 36, weight: .semiBold))
        .foregroundStyle(.blueMain)
      
      Text("/ 3시간")
        .font(.pretendard(size: 16, weight: .medium))
        .foregroundStyle(.gray06)
      // 중간 텍스트를 중앙에 배치하기 위해 spacing을 동일하게 주고 offset으로 위치 이동
        .offset(y: -11)
    }
    // 중간 텍스트가 원 중앙에 배치하기 위함
    // 상단, 하단에 위치한 텍스트의 높이가 각각 26, 19로 다름
    // 상단 텍스트가 7만큼 더 높이가 크기 때문에 그 절반만큼 뷰를 위로 옮김
    .offset(y: -3.5)
  }
}

private struct FooterView: View {
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("하루 가용시간")
          .font(.pretendard(size: 12, weight: .regular))
        Text("10시간 38분 / 12시간 30분")
          .font(.pretendard(size: 16, weight: .semiBold))
      }
      .foregroundStyle(.gray04)
      
      Spacer()
      
      Button {
        
      } label: {
        Text("시간 수정")
          .foregroundStyle(.blueMain)
          .font(.pretendard(size: 14, weight: .medium))
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 18)
      .background(.blueButton)
      .clipShape(RoundedRectangle(cornerRadius: 8))

    }
    .padding(.horizontal, 20)
    .padding(.vertical, 22)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(lineWidth: 1)
        .fill(.blueStroke)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  HomeView()
}

#Preview {
  AvailableTimeView(homeViewModel: HomeViewModel())
}
