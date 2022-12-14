//
//  HapticsManager.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 02.02.22.
//

import SwiftUI

class HapticsManager {
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
    if UserDefaults.standard.bool(forKey: UserDefaults.Keys.enabledVibration) {
      generator.notificationOccurred(.success)
    }
  }

  func error() {
    if UserDefaults.standard.bool(forKey: UserDefaults.Keys.enabledVibration) {
      generator.notificationOccurred(.error)
    }
  }
}
