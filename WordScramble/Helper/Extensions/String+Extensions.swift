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
  func calculateScore() -> Int {
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
}
