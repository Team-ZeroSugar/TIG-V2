//
//  SlotLayout.swift
//  TIG
//
//  Created by 신승재 on 4/8/25.
//

import Foundation

struct SlotLayout {
  static let height = 35.0
  static let space = 2.0
  static func groupedHeight(for slotCount: Int) -> Double {
    Double(slotCount) * height + Double(max(slotCount - 1, 0)) * (space * 2)
  }
}
