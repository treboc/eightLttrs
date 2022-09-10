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

  static let twitterURL: URL = URL(string: "https://twitter.com/treb0c")!
}

struct UserDefaultsKeys {
  static let isFirstStart = "isFirstStart"
  static let lastPlayersName = "lastPlayersName"
  static let currentSession = "currentSession"

  static let enabledVibration = "enabledVibration"
  static let enabledSound = "enabledSound"
  static let enabledFiltering = "enabledFiltering"
  static let regionCode = "chosenBasewordLocale"
}
