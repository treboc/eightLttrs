//
//  MediumSizeView.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI
import WidgetKit



struct MediumSizeView: View {
  var entry: SimpleEntry
  var session: WidgetSession {
    return entry.session
  }

  var body: some View {
    HStack(alignment: .firstTitle) {
      VStack(alignment: .leading) {
        Text(L10n.baseword.uppercased())
          .alignmentGuide(.firstTitle) { d in d[VerticalAlignment.center] }
          .font(.caption2)
          .foregroundColor(.secondary)

        Text(session.baseword)
          .font(.system(.title2, design: .rounded))
          .fontWeight(.semibold)

        VStack {
          Text(L10n.Widget.wordsFound(session.wordsFound, session.maxPossibleWords))
            .font(.subheadline)
        }
        .padding(.top, 1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .leading) {
        Text(L10n.lastAdded.uppercased())
          .font(.caption2)
          .foregroundColor(.secondary)
          .alignmentGuide(.firstTitle) { d in d[VerticalAlignment.center] }
          .padding(.bottom, 8)

        if session.usedWords.count > 0 {
          VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<session.usedWords.count, id: \.self) { i in
              HStack {
                Image(systemName: "\(entry.session.usedWords[i].calculatedScore()).circle.fill")
                  .foregroundColor(.accent)

                Text(entry.session.usedWords[i])
                  .font(.system(.headline, design: .rounded))
              }
            }
          }
          .fixedSize()
        } else {
          Text(L10n.Widget.noWords)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .italic()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }

        Spacer()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
  }

}
