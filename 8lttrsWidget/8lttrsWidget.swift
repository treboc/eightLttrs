//
//  8lttrsWidget.swift
//  8lttrsWidget
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import WidgetKit
import SwiftUI


@main
struct eightlttrsWidget: Widget {
  let kind: String = "8lttrsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WidgetView(entry: entry)
    }
    .supportedFamilies([.systemSmall, .systemMedium])
    .configurationDisplayName("Baseword")
    .description("Show the current baseword.")
  }
}
