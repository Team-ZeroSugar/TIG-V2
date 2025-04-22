//
//  CustomActionSheet.swift
//  TIG
//
//  Created by 이정동 on 4/10/25.
//

import SwiftUI

struct SheetAction {
  var title: String
  var role: UIAlertAction.Style
  var handler: (() -> Void)?
}

@resultBuilder
struct SheetActionBuilder {
  static func buildBlock(_ components: SheetAction...) -> [SheetAction] {
    components
  }
}

struct CustomActionSheet<Content: View>: UIViewControllerRepresentable {
  
  @Binding var isPresented: Bool
  @ViewBuilder var content: () -> Content
  @SheetActionBuilder var actions: () -> [SheetAction]
  
  
  func makeUIViewController(context: Context) -> some UIViewController {
    UIViewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    if !isPresented { return }
    
    // SwiftUI View를 UIView로 변환
    guard let contentUIView = UIHostingController(
      rootView: content()
    ).view else { return }
    
    // AlertController에 action 추가
    let alertController = UIAlertController(
      title: nil, message: nil, preferredStyle: .actionSheet
    )
    
    actions()
      .map { action in
        UIAlertAction(title: action.title, style: action.role) { _ in
          action.handler?()
          isPresented = false
          uiViewController.presentedViewController?.dismiss(animated: true)
        }
      }
      .forEach { alertController.addAction($0) }
    
    // contentUIView 오토 레이아웃 설정
    let actionButtonHeight: CGFloat = 57
    let toCancelGap: CGFloat = 8
    let padding: CGFloat = 12
    
    let separator = UIView()
    separator.backgroundColor = .separator
    separator.translatesAutoresizingMaskIntoConstraints = false
    alertController.view.addSubview(separator)
    
    separator.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor).isActive = true
    separator.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor).isActive = true
    separator.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -(actionButtonHeight * 2 + toCancelGap)).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 0.33).isActive = true
    
    
    alertController.view.addSubview(contentUIView)
    contentUIView.backgroundColor = .clear
    contentUIView.translatesAutoresizingMaskIntoConstraints = false
    contentUIView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: padding).isActive = true
    contentUIView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: padding).isActive = true
    contentUIView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -padding).isActive = true
    contentUIView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -padding).isActive = true
    
    uiViewController.present(alertController, animated: true)
  }
}

struct CustomActionSheetModifier<C: View>: ViewModifier {
  
  @Binding var isPresented: Bool
  @ViewBuilder var content: () -> C
  @SheetActionBuilder var actions: () -> [SheetAction]
  
  @State private var test: Bool = false
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      CustomActionSheet(
        isPresented: $isPresented,
        content: self.content,
        actions: actions
      )
      .frame(width: .zero, height: .zero)
    }
  }
}

extension View {
  func actionSheet<C: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> C,
    @SheetActionBuilder actions: @escaping () -> [SheetAction]
  ) -> some View {
    modifier(CustomActionSheetModifier(
      isPresented: isPresented,
      content: content,
      actions: actions
    ))
  }
}
