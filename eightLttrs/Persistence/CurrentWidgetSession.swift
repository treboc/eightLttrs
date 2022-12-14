//
//  CurrentWidgetSession.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI
import WidgetKit

struct WidgetSession: Codable {
  let baseword: String
  let usedWords: [String]
  let maxPossibleWords: Int
  let wordsFound: Int
  let percentageWordsFound: Double
}

struct CurrentWidgetSession {
  @AppStorage(UserDefaults.Keys.currentSession, store: UserDefaults(suiteName: "group.com.marvinleekobert.eightLttrs")) private var currentSessionData: Data = Data()
  
  let currentSession: WidgetSession

  func storeItem() {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(currentSession) else {
      return
    }

    currentSessionData = data
    WidgetCenter.shared.reloadAllTimelines()
  }
}
