//
//  OnboardingView.swift
//  TIG
//
//  Created by seozero on 2/3/25.
//

import SwiftUI

struct OnboardingView: View {
  var body: some View {
    OnboardingContentView()
      .background(Color.backgroundAlternative)
  }
}

struct OnboardingContentView: View {
  @State private var viewModel = OnboardingViewModel()
  
  var body: some View {
    VStack(alignment: .center, spacing: 64) {
      VStack(alignment: .center) {
        VStack(alignment: .center, spacing: 88) {
          Image(viewModel.state.currentContent.image)
            .resizable()
            .frame(width: 240, height: 240)
          
          VStack(alignment: .center, spacing: 12) {
            Text(viewModel.state.currentContent.title)
              .font(.pretendard(size: 24, weight: .bold))
              .foregroundStyle(.contentStrong)
              .multilineTextAlignment(.center)
            
            Text(viewModel.state.currentContent.description)
              .font(.pretendard(size: 16, weight: .regular))
              .foregroundStyle(.contentAlternative)
              .multilineTextAlignment(.center)
            
            Spacer()
          }
        }
        
        HStack(alignment: .center, spacing: 8) {
          ForEach(0..<OnboardingContent.allCases.count, id: \.self) { index in
            Circle()
              .fill(index == viewModel.state.currentIndex ? Color.primaryNormal : Color.contentLight)
              .frame(width: 8, height: 8)
          }
        }
      }
      .animation(.easeInOut(duration: 0.2), value: viewModel.state.currentIndex)
      
      OnboardingButton(
        type: viewModel.state.isFinished ? .setSleepTime : .next
      ) {
        viewModel.send(.nextOnboarding)
      }
    }
    .frame(maxHeight: .infinity)
    .padding(.top, 100)
    .padding(.bottom, 58)
  }
}

#Preview {
  OnboardingView()
}
