//
//  Provider.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  @AppStorage(UserDefaultsKeys.currentSession, store: UserDefaults(suiteName: "group.com.marvinleekobert.eightLttrs")) private var currentSessionData: Data = Data()

  func placeholder(in context: Context) -> SimpleEntry {
    let placeholderSession = WidgetSession(baseword: "Taubenei", usedWords: ["Taube", "taub", "Tau"], maxPossibleWords: 123, wordsFound: 25, percentageWordsFound: 0.23)
    return SimpleEntry(date: Date(), session: placeholderSession, isPlaceholder: true)
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    guard let currentSession = try? JSONDecoder().decode(WidgetSession.self, from: currentSessionData) else {
      return
    }
    let entry = SimpleEntry(date: Date(), session: currentSession)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    guard let currentSession = try? JSONDecoder().decode(WidgetSession.self, from: currentSessionData) else {
      return
    }
    let entry = SimpleEntry(date: Date(), session: currentSession)
    let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 30 * 60)))
    completion(timeline)
  }
}
