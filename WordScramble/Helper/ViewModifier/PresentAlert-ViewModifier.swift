//
//  ViewModfifier-PresentAlert.swift
//  WordScramble
//

import SwiftUI

struct AlertToPresent {
  let simpleAlert: Bool
  let title: String
  let message: String
  let primaryActionTitle: String = L10n.ButtonTitle.imSure
  let primaryAction: () -> Void

  init(simpleAlert: Bool = false, title: String, message: String, primaryAction: @escaping () -> Void) {
    self.simpleAlert = simpleAlert
    self.title = title
    self.message = message
    self.primaryAction = primaryAction
  }
}

extension View {
  func presentAlert(with alertModel: Binding<AlertToPresent?>) -> some View {
    return alert(alertModel.wrappedValue?.title ?? "No Title", isPresented: .constant(alertModel.wrappedValue != nil)) {
      if let simpleAlert = alertModel.wrappedValue?.simpleAlert,
         !simpleAlert {
        Button(alertModel.wrappedValue?.primaryActionTitle ?? "No Button Title", role: .destructive) {
          alertModel.wrappedValue?.primaryAction()
        }
      }
    } message: {
      Text(alertModel.wrappedValue?.message ?? "No Message")
    }
  }
}
