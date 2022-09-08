//
//  ViewModfifier-PresentAlert.swift
//  WordScramble
//

import SwiftUI

struct AlertToPresent {
  let title: String
  let message: String
  let primaryActionTitle: String = L10n.ButtonTitle.imSure
  let primaryAction: () -> Void
}

extension View {
  func presentAlert(with alertModel: Binding<AlertToPresent?>) -> some View {
    let alertMdl = alertModel.wrappedValue

    return alert(alertMdl?.title ?? "No Title", isPresented: .constant(alertModel.wrappedValue != nil)) {
      Button(alertMdl?.primaryActionTitle ?? "No Title", role: .destructive) { alertMdl?.primaryAction() }
    } message: {
      Text(alertMdl?.message ?? "No Message")
    }
  }
}
