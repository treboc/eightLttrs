//
//  ViewModfifier-PresentAlert.swift
//  WordScramble
//

import SwiftUI

struct AlertToPresent {
  let isSimpleAlert: Bool
  let title: String
  let message: String
  let primaryActionTitle: String
  let primaryAction: () -> Void

  init(simpleAlert: Bool = false,
       title: String,
       message: String,
       primaryAction: @escaping () -> Void,
       primaryActionTitle: String = L10n.ButtonTitle.imSure
  ) {
    self.isSimpleAlert = simpleAlert
    self.title = title
    self.message = message
    self.primaryAction = primaryAction
    self.primaryActionTitle = primaryActionTitle
  }
}

extension View {
  @ViewBuilder
  func presentAlert(with alertModel: Binding<AlertToPresent?>) -> some View {
    if let unwrappedAlert = alertModel.wrappedValue {
      if unwrappedAlert.isSimpleAlert {
        alert(unwrappedAlert.title, isPresented: .constant(alertModel.wrappedValue != nil)) {
        } message: {
          Text(unwrappedAlert.message)
        }
      } else {
        alert(unwrappedAlert.title, isPresented: .constant(alertModel.wrappedValue != nil)) {
          Button(unwrappedAlert.primaryActionTitle, role: .destructive) {
            unwrappedAlert.primaryAction()
          }
        } message: {
          Text(unwrappedAlert.message)
        }
      }
    } else {
      alert("Backup", isPresented: .constant(alertModel.wrappedValue != nil)) {}
    }
  }
}
