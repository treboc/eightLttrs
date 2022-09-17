//
//  PossibleWordList.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 17.09.22.
//

import SwiftUI

struct PossibleWordList: View {
  let possibleWords: [String]
  let usedWords: [String]

  var body: some View {
    ForEach(possibleWords.sorted(by: usedFirst), id: \.self) { word in
      HStack {
        Text(word)
          .strikethrough(usedWords.contains(word), color: .accentColor)

        Spacer()

        if usedWords.contains(word) {
          Image(systemName: "checkmark.circle")
            .symbolRenderingMode(.palette)
            .foregroundStyle(.green, .quaternary)
        } else {
          Image(systemName: "circle")
            .foregroundStyle(.quaternary)
        }
      }
    }
  }

  private func usedFirst(lhs: String, rhs: String) -> Bool {
    if usedWords.contains(lhs) {
      return true
    }
    return false
  }
}
