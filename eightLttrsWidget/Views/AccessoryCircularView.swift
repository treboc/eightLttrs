//
//  AccessoryCircularView.swift
//  eightLttrsWidgetExtension
//
//  Created by Marvin Lee Kobert on 12.09.22.
//

import SwiftUI

struct AccessoryCircularView: View {
  var entry: SimpleEntry

  var session: WidgetSession {
    return entry.session
  }

  var wordsFoundFormattedString: String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.numberStyle = .percent
    return formatter.string(from: .init(floatLiteral: session.percentageWordsFound)) ?? "0 %"
  }

  var body: some View {
    Gauge(value: session.percentageWordsFound, in: 0...1) {
      Text(wordsFoundFormattedString)
        .font(.caption)
    }
    .gaugeStyle(.accessoryCircularCapacity)
  }
}
