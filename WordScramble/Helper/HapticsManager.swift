//
//  HapticsManager.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 02.02.22.
//

import SwiftUI

class HapticManager {
  static let shared = HapticManager()

  func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }

  func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }
}
