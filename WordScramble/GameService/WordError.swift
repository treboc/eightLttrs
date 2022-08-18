//
//  WordError.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 18.08.22.
//

import Foundation

enum WordError: Error {
  case notReal, notOriginal, notPossible(word: String), tooShort

  var alert: Alert {
    switch self {
    case .notReal:
      return Alert(title: L10n.WordError.NotReal.title,
                   message: L10n.WordError.NotReal.message)
    case .notOriginal:
      return Alert(title: L10n.WordError.NotOriginal.title,
                   message: L10n.WordError.NotOriginal.message)
    case .notPossible(let word):
      return Alert(title: L10n.WordError.NotPossible.title,
                   message: L10n.WordError.NotPossible.message(word))
    case .tooShort:
      return Alert(title: L10n.WordError.TooShort.title,
                   message: L10n.WordError.TooShort.message)
    }
  }
}
