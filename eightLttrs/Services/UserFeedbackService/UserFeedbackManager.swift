//
//  UserFeedbackService.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 14.11.22.
//

import Foundation

class UserFeedbackManager {
  enum FeedBacktype {
    case success, error, sliderChange, buyAction
  }

  private let audioManager: AudioManager
  private let hapticsManager: HapticsManager

  init(audioManager: AudioManager = .init(),
       hapticsManager: HapticsManager = .init()) {
    self.audioManager = audioManager
    self.hapticsManager = hapticsManager
  }

  func perform(_ type: FeedBacktype) {
    switch type {
    case .success:
      audioManager.play(type: .success)
      hapticsManager.notification(type: .success)
    case .error:
      audioManager.play(type: .error)
      hapticsManager.notification(type: .error)
    case .sliderChange:
      hapticsManager.impact(style: .soft)
    case .buyAction:
      audioManager.play(type: .buyAction)
      hapticsManager.impact(style: .heavy)
    }
  }
}
