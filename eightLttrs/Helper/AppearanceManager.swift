//
//  AppearanceManager.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 24.04.22.
//
// https://gist.github.com/gavinjerman/a862e3dffa03468b8d1a5cf14e1c1f4f
// Based on this gist

import Foundation
import SwiftUI

class AppearanceManager: ObservableObject {
  private init() {}

  static let shared = AppearanceManager()

  @AppStorage("Appearance") var appearance: Appearance = .system {
    didSet {
      setAppearance()
    }
  }

  enum Appearance: String, CaseIterable, Equatable {
    case light
    case dark
    case system

    var title: String {
      switch self {
      case .dark:
        return L10n.ColorPicker.dark
      case .light:
        return L10n.ColorPicker.light
      case .system:
        return L10n.ColorPicker.system
      }
    }
  }

  func setAppearance() {
    switch appearance {
    case .light:
      window?.overrideUserInterfaceStyle = .light
    case .dark:
      window?.overrideUserInterfaceStyle = .dark
    case .system:
      window?.overrideUserInterfaceStyle = .unspecified
    }
  }

  private var window: UIWindow? {
    guard let scene = UIApplication.shared.connectedScenes.first,
          let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
          let window = windowSceneDelegate.window else {
      return nil
    }
    return window
  }

}
