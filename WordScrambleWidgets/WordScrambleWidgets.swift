//
//  WordScrambleWidgets.swift
//  WordScrambleWidgets
//
//  Created by Marvin Lee Kobert on 01.09.22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry()
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry()
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  var date: Date = .now

  let baseWord = "Hausboot"
  let foundWords = ["Haus", "Boot"]
}

struct WordScrambleWidgetsEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading) {
      Text("gesucht ist")
        .font(.caption2)
      Text(entry.baseWord)
        .font(.title2)
        .fontWeight(.semibold)

      ForEach(0..<min(3, entry.foundWords.count), id: \.self) { index in
        Text(entry.foundWords[index])
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(
      Text("2%")
        .padding(10)
        .background(.red, in: Circle()),
      alignment: .topTrailing)


  }
}

@main
struct WordScrambleWidgets: Widget {
  let kind: String = "WordScrambleWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WordScrambleWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct WordScrambleWidgets_Previews: PreviewProvider {
  static var previews: some View {
    WordScrambleWidgetsEntryView(entry: SimpleEntry(date: Date()))
      .preferredColorScheme(.dark)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
      .preferredColorScheme(.dark)
  }
}
