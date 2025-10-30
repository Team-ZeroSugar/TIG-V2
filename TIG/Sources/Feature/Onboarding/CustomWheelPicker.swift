//
//  CustomWheelPicker.swift
//  TIG
//
//  Created by seozero on 10/24/25.
//

import Foundation
import SwiftUI

struct CustomWheelPicker: View {
  
  @Binding var amPmIndex: Int
  @Binding var hourIndex: Int
  @Binding var minuteIndex: Int
  
  private let pickerWidth = UIScreen.main.bounds.width * 0.19
  
  private let amPmData: [String]
  private let hourData: [String]
  private let minuteData: [String]
  
  init(
    amPmIndex: Binding<Int>,
    hourIndex: Binding<Int>,
    minuteIndex: Binding<Int>,
    amPmData: [String],
    hourData: [String],
    minuteData: [String]
  ) {
    self._amPmIndex = amPmIndex
    self._hourIndex = hourIndex
    self._minuteIndex = minuteIndex
    self.amPmData = amPmData
    self.hourData = hourData
    self.minuteData = minuteData
  }
  
  var body: some View {
    HStack(spacing: 16) {
      RoundedRectangle(cornerRadius: 10)
        .fill(.primaryNeutral)
        .frame(
          height: 40
        )
        .overlay {
          SingleWheelPicker(data: amPmData, componentWidth: pickerWidth, selectedIndex: $amPmIndex)
            .frame(width: pickerWidth)
            .contentShape(Rectangle())
        }
      
      RoundedRectangle(cornerRadius: 10)
        .fill(.primaryNeutral)
        .frame(
          height: 40
        )
        .overlay {
          SingleWheelPicker(data: hourData, componentWidth: pickerWidth, selectedIndex: $hourIndex)
            .frame(width: pickerWidth)
            .contentShape(Rectangle())
          }
      
      RoundedRectangle(cornerRadius: 10)
        .fill(.primaryNeutral)
        .frame(
          height: 40
        )
        .overlay {
          SingleWheelPicker(data: minuteData, componentWidth: pickerWidth, selectedIndex: $minuteIndex)
            .frame(width: pickerWidth)
            .contentShape(Rectangle())
        }
    }
  }
}

struct SingleWheelPicker: UIViewRepresentable {
  
  private let data: [String]
  private let componentWidth: CGFloat
  
  @Binding var selectedIndex: Int
  
  init(
    data: [String],
    componentWidth: CGFloat,
    selectedIndex: Binding<Int>
  ) {
    self.data = data
    self.componentWidth = componentWidth
    self._selectedIndex = selectedIndex
  }
  
  func makeUIView(context: Context) -> UIPickerView {
    let picker = UIPickerView()
    picker.delegate = context.coordinator
    picker.dataSource = context.coordinator
    return picker
  }
  
  func updateUIView(_ uiView: UIPickerView, context: Context) {
    uiView.selectRow(selectedIndex, inComponent: 0, animated: false)
    uiView.reloadAllComponents()
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parent: SingleWheelPicker
    
    init(_ parent: SingleWheelPicker) {
      self.parent = parent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      1
    }
    
    func pickerView(
      _ pickerView: UIPickerView,
      numberOfRowsInComponent component: Int
    ) -> Int {
      parent.data.count
    }
    
    func pickerView(
      _ pickerView: UIPickerView,
      widthForComponent component: Int
    ) -> CGFloat {
      return parent.componentWidth
    }
    
    func pickerView(
      _ pickerView: UIPickerView,
      viewForRow row: Int,
      forComponent component: Int,
      reusing view: UIView?
    ) -> UIView {
      
      let view = UIView(frame: CGRect(
        x: 0,
        y: 0,
        width: parent.componentWidth,
        height: 380
      ))
      let rowLabel = UILabel(frame: view.bounds)
      
      rowLabel.font = UIFont(name: "Pretendard-Medium", size: 20)
      rowLabel.textAlignment = .center
      
      if row < parent.data.count {
        rowLabel.text = parent.data[row]
      }
      
      pickerView.subviews[1].backgroundColor = .clear
      
      view.addSubview(rowLabel)
      
      return view
    }
    
    func pickerView(
      _ pickerView: UIPickerView,
      didSelectRow row: Int,
      inComponent component: Int
    ) {
      parent.selectedIndex = row
    }
    
    func pickerView(
      _ pickerView: UIPickerView,
      rowHeightForComponent component: Int
    ) -> CGFloat {
      50
    }
  }
}
