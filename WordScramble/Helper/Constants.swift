//
//  Constants.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 15.08.22.
//

import SwiftUI

struct Constants {
  static let widthPadding: CGFloat = 16
  static let cornerRadius: CGFloat = 8

}

struct UserDefaultsKeys {
  static let isFirstStart = "isFirstStart"
  static let lastPlayersName = "lastPlayersName"
  static let currentSession = "currentSession"

  // Settings
  static let enabledVibration = "enabledVibration"
  static let enabledSound = "enabledSound"
  static let enabledFiltering = "enabledFiltering"
  static let regionCode = "chosenBasewordLocale"
}
