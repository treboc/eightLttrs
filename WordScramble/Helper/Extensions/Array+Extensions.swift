//
//  Array+Extensions.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import Foundation

import UIKit

extension Array where Self == [String] {
  func permute(minStringLen: Int = 2) -> Set<String> {
    func permute(fromList: [String], toList: [String], minStringLen: Int, set: inout Set<String>) {
      if toList.count >= minStringLen {
        set.insert(toList.joined(separator: ""))
      }
      if !fromList.isEmpty {
        for (index, item) in fromList.enumerated() {
          var newFrom = fromList
          newFrom.remove(at: index)
          permute(fromList: newFrom, toList: toList + [item], minStringLen: minStringLen, set: &set)
        }
      }
    }

    var set = Set<String>()
    permute(fromList: self, toList:[], minStringLen: minStringLen, set: &set)
    return set
  }
}

func allPossibleWords(of word: String) -> ([String], Int) {
  let wordArr = word.map { String($0) }
  let list = wordArr.permute(minStringLen: 3)

  var possibleWordsSet = Set<String>()

  if let possibleWordsURL = Bundle.main.url(forResource: "allWords8LettersEN.txt", withExtension: nil) {
    if let possibleWords = try? String(contentsOf: possibleWordsURL) {
      let possibleLowercasedWords = possibleWords.components(separatedBy: .newlines).map({ $0.lowercased() })
      possibleWordsSet = Set(possibleLowercasedWords)
    }
  }

  var arr: [String] = []

  arr = list.compactMap { word in
    if possibleWordsSet.contains(word) {
      return word
    }
    return nil
  }

  let score = arr.map{ $0.calculateScore() }.reduce(0, +)

  return (arr, score)
}
