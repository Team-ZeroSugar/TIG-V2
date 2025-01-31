//
//  Font.swift
//  TIG
//
//  Created by 이정동 on 1/26/25.
//

import Foundation
import SwiftUI

extension Font {
  enum Pretendard: String {
    case black = "Pretendard-Black"
    case extraBold = "Pretendard-ExtraBold"
    case bold = "Pretendard-Bold"
    case semiBold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case light = "Pretendard-Light"
    case extraLight = "Pretendard-ExtraLight"
    case thin = "Pretendard-Thin"
  }
  
  func pretendard(size: CGFloat, weight: Pretendard) -> Font {
    return .custom(weight.rawValue, size: size)
  }
}
