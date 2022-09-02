//
//  SmallSizeView.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI

struct SmallSizeView: View {
  var entry: SimpleEntry
  var session: WidgetSession {
    return entry.session
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(L10n.baseword.uppercased())
        .alignmentGuide(.firstTitle) { d in d[VerticalAlignment.center] }
        .font(.caption2)
        .foregroundColor(.secondary)

      Text(session.baseword)
        .font(.system(.title2, design: .rounded))
        .fontWeight(.semibold)

      Spacer()
      Text(L10n.Widget.wordsFound(session.wordsFound, session.maxPossibleWords))
        .font(.caption)
        .foregroundColor(.secondary)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(10)
    .overlay(CircularProgressView(progress: session.percentageWordsFound)
      .padding(-10))
    .padding()
  }
}
