//
//  GameService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Foundation
import UIKit

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

struct Alert {
  let title: String
  let message: String
}

protocol GameServiceProtocol {
  var startWords: Set<String> { get set }
  var allPossibleWords: Set<String> { set get }
  var currentWord: String { get set }

  var usedWords: [String] { get set }
  var currentScore: Int { get set }

  func loadWords()
  func startGame(_: (String) -> Void)

  func check(_ word: String) throws
  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws
}

class GameService: GameServiceProtocol {
  var startWords: Set<String> = .init()
  var allPossibleWords: Set<String> = .init()
  var currentWord: String = ""

  var usedWords: [String] = [] {
    didSet {
      calculateScore()
    }
  }
  var currentScore: Int = 0

  init() {
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

  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws {
    do {
      try check(word)
      usedWords.insert(word, at: 0)
      onCompletion()
    }
  }
}

extension String {
  func calclulateScore() -> Int {
    var wordScore = 0
    var scoreMultiplier = 2
    var wordLength = self.count

    switch wordLength {
    case 3:
      wordScore = 3
    case 4...:
      wordScore += 3
      wordLength -= 3
      for _ in 0..<wordLength {
        wordScore += scoreMultiplier
        scoreMultiplier += 2
      }
    default:
      break
    }
    return wordScore
  }

}

// MARK: - Calculation of Scores
extension GameService {
  private func calculateScore() {
    currentScore = usedWords
      .map { calclulateScoreOf($0) }
      .reduce(0, +)
  }

  /*
   Word scoring:
   - for each letter of the first 3, there is 1 point
   - 2 points for the 4th letter,
   - 4 points for the 5th,
   - 6 points for the 6th, etc.
   */
  private func calclulateScoreOf(_ word: String) -> Int {
    var wordScore = 0
    var scoreMultiplier = 2
    var wordLength = word.count

    switch wordLength {
    case 3:
      wordScore = 3
    case 4...:
      wordScore += 3
      wordLength -= 3
      for _ in 0..<wordLength {
        wordScore += scoreMultiplier
        scoreMultiplier += 2
      }
    default:
      break
    }
    return wordScore
  }
}

extension GameService {
  func check(_ word: String) throws {
    let word = word.lowercased()
    // tooShort
    if word.count < 3 {
      throw WordError.tooShort
    }

    // isOriginal
    if usedWords
      .map({ $0.lowercased() })
      .contains(word) || word == currentWord {
      throw WordError.notOriginal
    }

    // isPossible
    var tempWord = currentWord.lowercased()
    try word.forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: currentWord)
      }
    }

    // isReal
    if !allPossibleWords.contains(word) {
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

