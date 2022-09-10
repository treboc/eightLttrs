//
//  String+CalculatedScore.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import Foundation

extension String {
  func calculatedScore() -> Int {
    var score = 0
    var scoreMultiplier = 2
    var length = self.count

    switch length {
    case ...3:
      score = 3
    case 4...:
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

  public func replacedWithStars() -> String {
    return String(self.map { _ in "✯" })
  }
}
