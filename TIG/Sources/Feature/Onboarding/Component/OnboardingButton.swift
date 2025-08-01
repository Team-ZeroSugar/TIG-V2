//
//  OnboardingButton.swift
//  TIG
//
//  Created by seozero on 7/30/25.
//

import SwiftUI

struct OnboardingButton: View {
  private let type: OnboardingButtonType
  private let action: (() -> Void)?
  
  init(
    type: OnboardingButtonType = .start,
    action: (() -> Void)? = nil
  ) {
    self.type = type
    self.action = action
  }
  
  var body: some View {
    Button {
        action?()
    } label: {
        HStack(alignment: .center, spacing: 4) {
          Text(type.title)
            .font(.pretendard(size: 16, weight: .medium))
            .foregroundStyle(.contentException)
        }
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity)
        .background(.primaryNormal)
        .clipShape(Capsule())
    }
    .padding(.horizontal, 68)
    .allowsHitTesting(true)
    .buttonStyle(.plain)
  }
}
