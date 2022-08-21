//
//  GameService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Foundation
import UIKit



protocol GameServiceProtocol {
  var scoreService: ScoreService { get set }

  var startWords: Set<String> { get set }
  var allPossibleWords: Set<String> { set get }
  var currentWord: String { get set }

  var usedWords: [String] { get set }
  var currentScore: Int { get set }

  func loadWords()
  func startGame(_: (String) -> Void)
  func endGame(playerName: String)

  func check(_ word: String) throws
  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws
  func populateWordWithScore(at indexPath: IndexPath) -> (String, Int)
}

class GameService: GameServiceProtocol {
  var scoreService: ScoreService

  var startWords: Set<String> = .init()
  var allPossibleWords: Set<String> = .init()
  var currentWord: String = ""

  var usedWords: [String] = [] {
    didSet {
      calculateScore()
    }
  }
  var currentScore: Int = 0

  init(scoreService: ScoreService) {
    self.scoreService = scoreService
    loadWords()
  }

  internal func loadWords() {
    // getting the apps language
    let currentLocale = Locale.autoupdatingCurrent.identifier.suffix(2)

    // load possible words to check for
    if let possibleWordsURL = Bundle.main.url(forResource: "allWords8Letters\(currentLocale).txt", withExtension: nil) {
      if let possibleWords = try? String(contentsOf: possibleWordsURL) {
        let possibleLowercasedWords = possibleWords.components(separatedBy: .newlines).map({ $0.lowercased() })
        self.allPossibleWords = Set(possibleLowercasedWords)
      }
    }

    // load possible startWords in the current language
    if let startWordsURL = Bundle.main.url(forResource: "startWords\(currentLocale).txt", withExtension: nil) {
      if let startWords = try? String(contentsOf: startWordsURL) {
        self.startWords = Set(startWords.components(separatedBy: .newlines))
      }
    } else {
      startWords = ["silkworm"]
    }
  }

  func startGame(_ completionHandler: (String) -> Void) {
    guard let rndWord = startWords.randomElement() else { return }
    currentWord = rndWord
    usedWords.removeAll()
    calculateScore()
    completionHandler(rndWord)
  }

  func endGame(playerName: String) {
    guard !usedWords.isEmpty else { return }
    scoreService.saveScore(word: currentWord, name: playerName, score: currentScore)
  }

  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws {
    do {
      try check(word)
      usedWords.insert(word, at: 0)
      onCompletion()
    }
  }

  func populateWordWithScore(at indexPath: IndexPath) -> (String, Int) {
    guard !usedWords[indexPath.row].isEmpty else { return ("Unknown", 0) }

    let word = usedWords[indexPath.row]
    let points = calculateScoreOf(word)

    return (word, points)
  }
}

// MARK: - Calculation of Scores
extension GameService {
  private func calculateScore() {
    currentScore = usedWords
      .map { calculateScoreOf($0) }
      .reduce(0, +)
  }

  /*
   Word scoring:
   - for each letter of the first 3, there is 1 point
   - 2 points for the 4th letter,
   - 4 points for the 5th,
   - 6 points for the 6th, etc.
   */
  private func calculateScoreOf(_ answer: String) -> Int {
    var score = 0
    var scoreMultiplier = 2
    var length = answer.count

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

extension GameService {
  func check(_ word: String) throws {
    let lowercasedWord = word.lowercased()
    // tooShort
    if lowercasedWord.count < 3 {
      throw WordError.tooShort
    }

    // isOriginal
    if usedWords
      .map({ $0.lowercased() })
      .contains(lowercasedWord) || lowercasedWord == currentWord.lowercased() {
      throw WordError.notOriginal
    }

    // isPossible
    var tempWord = currentWord.lowercased()
    try lowercasedWord.forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: currentWord)
      }
    }

    // isReal
    if !allPossibleWords.contains(lowercasedWord) {
      throw WordError.notReal
    }
//    let checker = UITextChecker()
//    let range = NSRange(location: 0, length: word.utf16.count)
//    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "de_DE")
//
//    if misspelledRange.location != NSNotFound {
//      throw WordError.notReal
//    }
  }
}

