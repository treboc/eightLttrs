//
//  WordService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 04.09.22.
//

import Foundation
import UIKit

class WordService {
  static func loadBasewords(_ wsLocale: WSLocale) -> Set<String> {
    if let basewordsURL = Bundle.main.url(forResource: "basewords\(wsLocale.fileNameSuffix)", withExtension: "txt"),
       let basewords = try? String(contentsOf: basewordsURL) {
      return Set(basewords.components(separatedBy: .newlines))
    }
    return Set<String>()
  }

  static func loadPossibleWords(_ wsLocale: WSLocale) -> Set<String> {
    if let possibleWordsURL = Bundle.main.url(forResource: "possibleWords\(wsLocale.fileNameSuffix)", withExtension: "txt"),
       let possibleWords = try? String(contentsOf: possibleWordsURL) {
      return Set(possibleWords.components(separatedBy: .newlines))
    }
    return Set<String>()
  }

  static func getNewBasewordWith(_ wsLoacle: WSLocale, onCompletion: @escaping ((String, Set<String>, Int) -> Void)) {
    let basewords = WordService.loadBasewords(wsLoacle)
    let baseword = basewords.randomElement()!
    let allPossibleWords = WordService.loadPossibleWords(wsLoacle)

    Task {
      let (possibleWords, score) = await getAllPossibleWordsFor(baseword, basedOn: allPossibleWords)
      onCompletion(baseword, possibleWords, score)
    }
  }

  static func isValidBaseword(_ word: String,
                              in wordList: Set<String>) -> Bool {
    return wordList.contains(word)
  }

  static func isValidBaseword(_ word: String,
                              with locale: WSLocale) -> Bool {
    let basewords = loadBasewords(locale)
    return basewords.contains(word)
  }

  static func validate(_ word: String,
                       baseword: String,
                       usedWords: [String],
                       possibleWords: Set<String>) throws {
    if word.count < 3 {
      throw WordError.tooShort
    }

    if usedWords
      .contains(word) || baseword == word {
      throw WordError.notOriginal
    }

    var tempWord = baseword.lowercased()
    try word.lowercased().forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: baseword)
      }
    }

    if !possibleWords.contains(word) {
      throw WordError.notReal
    }
  }

  static func getLocale(for word: String) -> WSLocale {
    for locale in WSLocale.allCases {
      let basewords = loadBasewords(locale)
      if basewords.contains(word) {
        return locale
      }
    }
    return .getStoredWSLocale()
  }

  static func getAllPossibleWords(for word: String, onCompletion: @escaping (Set<String>, Int) -> Void) {
    let locale = getLocale(for: word)
    let list = loadPossibleWords(locale)
    Task {
      let (words, score) = await allPossibleWords(for: word, basedOn: list)
      onCompletion(words, score)
    }
  }

  static func getAllPossibleWordsFor(_ word: String,
                                     basedOn list: Set<String>) async -> (Set<String>, Int) {
    return await allPossibleWords(for: word, basedOn: list)
  }

  static func getAllPossibleWordsFor(_ word: String, withLocale locale: WSLocale, onCompletion: @escaping (Set<String>, Int) -> Void) {
    let list = loadPossibleWords(locale)
    Task {
      let (words, score) = await allPossibleWords(for: word, basedOn: list)
      onCompletion(words, score)
    }
  }

  private class func allPossibleWords(for baseword: String,
                                basedOn list: Set<String>,
                                with minStringLen: Int = 3) async -> (Set<String>, Int) {
    let stringArr = baseword
      .map { String($0).lowercased() }
    let permutedStringList = stringArr.permute(minStringLen: minStringLen)

    // iterate over the list passed in,
    // only keep the string permuted words
    
    let possibleWordsForWord = list.filter { word in
      permutedStringList.contains(word.lowercased()) && word != baseword
    }

    let score = possibleWordsForWord
      .map { $0.calculatedScore() }
      .reduce(0, +)

    return (Set(possibleWordsForWord), score)
  }
}
