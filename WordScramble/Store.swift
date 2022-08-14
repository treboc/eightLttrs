//
//  Store.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Foundation

class Store {
  var allWords: [String] = []
  var usedWords: [String] = []

  init() {
    loadWords()
  }

  func loadWords() {
    if let startWordsURL = Bundle.main.url(forResource: "start.txt", withExtension: nil) {
      if let startWords = try? String(contentsOf: startWordsURL) {
        self.allWords = startWords.components(separatedBy: .newlines)
      }
    } else {
      allWords = ["silkworm"]
    }
  }

}
