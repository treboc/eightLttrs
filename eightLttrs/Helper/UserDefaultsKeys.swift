//
//  UserDefaultsKeys.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 17.09.22.
//

import Foundation

extension UserDefaults {
  enum Keys {
    static let flagUppercaseHintAlreadyShown = "flagUppercaseHintAlreadyShown"
    
    static let isFirstStart = "isFirstStart"
    static let lastPlayersName = "lastPlayersName"
    static let currentSession = "currentSession"
    
    static let appearance = "Appearance"
    static let enabledVibration = "enabledVibration"
    static let enabledSound = "enabledSound"
    static let setVolume = "setVolume"
    static let enabledFiltering = "enabledFiltering"
    static let regionCode = "chosenBasewordLocale"
    
    static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    static let isReadyForRequestKey = "isReadyForRequest"
    static let wordCounterForRequestKey = "wordCounterForRequest"
    static let neededWordCounterForRequestKey = "neededWordCounterForRequest"
  }
}
