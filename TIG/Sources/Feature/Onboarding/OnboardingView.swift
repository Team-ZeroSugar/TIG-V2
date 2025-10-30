//
//  OnboardingView.swift
//  TIG
//
//  Created by seozero on 2/3/25.
//

import SwiftUI

struct OnboardingView: View {
  @State private var viewModel = OnboardingViewModel()
  @State private var currentPage: Int = 0
  @State private var finishedOnboarding: Bool = false

  var body: some View {
    NavigationStack {
      VStack {
        TabView(selection: $currentPage) {
          OnboardingContentView(
            image: OnboardingContent.onboardingFirst.image,
            title: OnboardingContent.onboardingFirst.title,
            description: OnboardingContent.onboardingFirst.description
          )
          .tag(0)
          
          OnboardingContentView(
            image: OnboardingContent.onboardingSecond.image,
            title: OnboardingContent.onboardingSecond.title,
            description: OnboardingContent.onboardingSecond.description
          )
          .tag(1)
          
          OnboardingContentView(
            image: OnboardingContent.onboardingThird.image,
            title: OnboardingContent.onboardingThird.title,
            description: OnboardingContent.onboardingThird.description
          )
          .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        onboardingPagination
          .padding(.top, 104)
        
        OnboardingButton(
          type: currentPage == 2 ? .setSleepTime : .next
        ) {
          if currentPage == 2 {
            finishedOnboarding = true
          } else {
            self.nextPage()
          }
        }
        .padding(.top, 64)
      }
      .background(Color.backgroundAlternative)
      .navigationDestination(isPresented: $finishedOnboarding){
          SleepTimeSettingView()
          .navigationBarBackButtonHidden(true)
        }
    }
    
  }
  
  private func nextPage() {
    currentPage += 1
  }
}

struct OnboardingContentView: View {
  
  private let image: ImageResource
  private let title: String
  private let description: String
  
  init(
    image: ImageResource,
    title: String,
    description: String
  ) {
    self.image = image
    self.title = title
    self.description = description
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 64) {
      VStack(alignment: .center, spacing: 0) {
        VStack(alignment: .center, spacing: 88) {
          Image(image)
            .resizable()
            .frame(width: 240, height: 240)
          
          VStack(alignment: .center, spacing: 12) {
            Text(title)
              .font(.pretendard(size: 24, weight: .bold))
              .foregroundStyle(.contentStrong)
              .multilineTextAlignment(.center)
            
            Text(description)
              .font(.pretendard(size: 16, weight: .regular))
              .foregroundStyle(.contentAlternative)
              .multilineTextAlignment(.center)
          }
        }
      }
    }
    .frame(maxHeight: .infinity)
    .padding(.top, 100)
  }
}

extension OnboardingView {
  private var onboardingPagination: some View {
    HStack(alignment: .center, spacing: 8) {
      ForEach(0..<OnboardingContent.allCases.count, id: \.self) { index in
        Circle()
          .fill(index == currentPage ? Color.primaryNormal : Color.contentLight)
          .frame(width: 8, height: 8)
      }
    }
  }
}

#Preview {
  OnboardingView()
}
