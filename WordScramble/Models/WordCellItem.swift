//
//  WordCellItem.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import UIKit

struct WordCellItem: Hashable {
  let word: String
  private let points: Int

  init(word: String) {
    self.word = word
    self.points = word.calculateScore()
  }

  var pointsImage: UIImage {
    let config = UIImage.SymbolConfiguration(textStyle: .headline)
    return UIImage(systemName: "\(points <= 50 ? points : 0).circle.fill", withConfiguration: config)!
  }
}
