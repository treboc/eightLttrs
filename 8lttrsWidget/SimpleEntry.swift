//
//  SimpleEntry.swift
//  WordScrambleWidgetExtension
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
  let date: Date
  let session: WidgetSession
  var isPlaceholder: Bool = false
}
