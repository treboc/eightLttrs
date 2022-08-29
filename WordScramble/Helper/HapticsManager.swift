//
//  HapticsManager.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 02.02.22.
//

import SwiftUI

class HapticManager {
  static let shared = HapticManager()
  let generator = UINotificationFeedbackGenerator()


  func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }

  func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }

  func success() {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.enabledVibration) {
      generator.notificationOccurred(.success)
    }
  }

  func error() {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.enabledVibration) {
      generator.notificationOccurred(.error)
    }
  }
}
