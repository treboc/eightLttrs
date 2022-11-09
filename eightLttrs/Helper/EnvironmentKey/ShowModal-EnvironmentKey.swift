//
//  ShowModal-EnvironmentKey.swift
//  eightLttrs
//
// Quelle: https://stackoverflow.com/a/59825996/8366079
//

import SwiftUI

// define env key to store our modal mode values
struct ModalModeKey: EnvironmentKey {
  static let defaultValue = Binding<Bool>.constant(false) // < required
}

// define modalMode value
extension EnvironmentValues {
  var modalMode: Binding<Bool> {
    get {
      return self[ModalModeKey.self]
    }
    set {
      self[ModalModeKey.self] = newValue
    }
  }
}
