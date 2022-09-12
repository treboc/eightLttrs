//
//  eightLttrsWidget.swift
//  eightLttrsWidget
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import WidgetKit
import SwiftUI


@main
struct eightLttrsWidget: Widget {
  let kind: String = "eightLttrsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WidgetView(entry: entry)
    }
    .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular])
    .configurationDisplayName("Baseword")
    .description("Show the current baseword.")
  }
}
