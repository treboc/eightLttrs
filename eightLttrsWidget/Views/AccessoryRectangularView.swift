//
//  AccessoryRectangularView.swift
//  eightLttrsWidgetExtension
//
//  Created by Marvin Lee Kobert on 12.09.22.
//

import SwiftUI

struct AccessoryRectangularView: View {
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
    VStack(alignment: .leading) {
      Text(session.baseword)
        .font(.system(.headline, design: .rounded, weight: .semibold))

      Gauge(value: session.percentageWordsFound) {
        Text("\(wordsFoundFormattedString) words found")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .gaugeStyle(.accessoryLinearCapacity)
    }
  }
}
