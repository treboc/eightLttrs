//
//  ViewModfifier-PresentAlert.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import SwiftUI
//
//extension View {
//  func errorAlert(error: Binding<WordError?>, buttonTitle: String = "OK") -> some View {
//    let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
//    return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
//      Button(buttonTitle) {
//        error.wrappedValue = nil
//      }
//    } message: { error in
//      Text(error.recoverySuggestion ?? "")
//    }
//  }
//}

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
