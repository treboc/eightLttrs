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
      return Alert(title: "Word Not Recognized",
                        message: "You can't just make them up, you know?")
    case .notOriginal:
      return Alert(title: "Word Already Used",
                        message: "Come on, be more original!")
    case .notPossible(let word):
      return Alert(title: "Word Not Possible",
                        message: "You can't spell that from \"\(word)\". Please, look again.")
    case .tooShort:
      return Alert(title: "Too Short",
                        message: "THe word should have at least three letters.")
    }
  }
}
