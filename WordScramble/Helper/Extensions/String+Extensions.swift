//
//  String+Extensions.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import Foundation

extension String {
  /*
   Word scoring:
   - for each letter of the first 3, there is 1 point
   - 2 points for the 4th letter,
   - 4 points for the 5th,
   - 6 points for the 6th, etc.
   */
  func calculatedScore() -> Int {
    var score = 0
    var scoreMultiplier = 2
    var length = self.count

    switch length {
    case 3:
      score = 3
    case 4...:
      score += 3
      length -= 3
      for _ in 0..<length {
        score += scoreMultiplier
        scoreMultiplier += 2
      }
    default:
      break
    }
    return score
  }

  func allPossibleWords(basedOn list: Set<String>,
                        with minStringLen: Int = 3) async -> (Set<String>, Int) {
    let string = self
      .map { String($0).lowercased() }
    let permutedStringList = string.permute(minStringLen: minStringLen)

    // iterate over the list passed in,
    // only keep the string permuted words
    let possibleWordsForString = list
      .filter { word in
        permutedStringList.contains(word.lowercased()) && word != self
      }

    let score = possibleWordsForString
      .map { $0.calculatedScore() }
      .reduce(0, +)

    return (Set(possibleWordsForString), score)
  }


  public func replacedWithStars() -> String {
    return String(self.map { _ in "✯" })
  }
}
