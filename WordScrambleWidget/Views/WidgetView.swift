//
//  WidgetView.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import WidgetKit
import SwiftUI

struct WidgetView: View {
  @Environment(\.widgetFamily) private var widgetFamily
  var entry: Provider.Entry

  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SmallSizeView(entry: entry)
    case .systemMedium:
      MediumSizeView(entry: entry)
    default:
      Text("Not implemented.")
    }

  }
}

