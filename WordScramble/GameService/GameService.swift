//
//  GameService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import Foundation
import UIKit

enum RegionBasedLocale: String {
  case de, at, ch, en

  var fileNameSuffix: String {
    switch self {
    case .de, .at, .ch:
      return "DE"
    default:
      return "EN"
    }
  }

  var textCheckerLanguage: String {
    switch self {
    case .de, .at, .ch:
      return "de_DE"
    case .en:
      return "en_US"
    }
  }
}

class GameService: GameServiceProtocol {
  var wordCellItemPublisher = CurrentValueSubject<[WordCellItem], Never>([])
  var currentWordPublisher = CurrentValueSubject<String, Never>("")
  var possibleScorePublisher = CurrentValueSubject<(Int, Int), Never>((0, 0))

  var startWords = Set<String>()
  var allPossibleWords = Set<String>()

  var currentLocale: RegionBasedLocale

  var currentWord: String = "" {
    didSet {
      currentWordPublisher.send(currentWord)

      DispatchQueue.global(qos: .background).async {
        let (_, score) = WordScramble.allPossibleWords(of: self.currentWord)
        self.possibleScore = score
      }
    }
  }

  var usedWords: [WordCellItem] = [] {
    didSet {
      wordCellItemPublisher.send(usedWords)
    }
  }

  var currentScore: Int {
    return usedWords
      .map { $0.word.calculateScore() }
      .reduce(0, +)
  }

  var possibleScore: Int = 0 {
    didSet {
      possibleScorePublisher.send((currentScore, possibleScore))
    }
  }

  init(_ gameType: GameType? = .randomWord) {
    // check users region.. if it's at, ch or de -> use german start words
    // if not, english
    let locale = String(Locale.autoupdatingCurrent.identifier.suffix(2)).lowercased()
    self.currentLocale = .init(rawValue: locale) ?? .en

    loadWords(with: currentLocale)

    switch gameType {
    case .randomWord:
      startGame()
    case .sharedWord(let word):
      startGame(with: word)
    case .none:
      break
    }


  }

  private func loadWords(with locale: RegionBasedLocale) {
    //    // load possible words to check for
    //    if let possibleWordsURL = Bundle.main.url(forResource: "allWords8Letters\(currentLocale).txt", withExtension: nil) {
    //      if let possibleWords = try? String(contentsOf: possibleWordsURL) {
//        let possibleLowercasedWords = possibleWords.components(separatedBy: .newlines).map({ $0.lowercased() })
//        self.allPossibleWords = Set(possibleLowercasedWords)
//      }
//    }

    // load possible startWords in the current language
    if let startWordsURL = Bundle.main.url(forResource: "startWords\(locale.fileNameSuffix)", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        self.startWords = Set(startWords.components(separatedBy: .newlines))
      }
    } else {
      startWords = ["silkworm"]
    }
  }

  func startGame(with word: String) {
    if let decodedWord = word.removingPercentEncoding {
      currentWord = decodedWord
      usedWords.removeAll()
    }
  }

  func startGame() {
    guard let rndWord = startWords.randomElement() else { return }
    currentWord = rndWord
    usedWords.removeAll()
  }

  func endGame(playerName: String) {
    ScoreService.save(word: currentWord, for: playerName, with: currentScore)
    startGame()
  }

  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws {
    do {
      try check(word)
      let wordCellItem = WordCellItem(word: word)
      usedWords.insert(wordCellItem, at: 0)
      onCompletion()
    }
  }

  func populateWordWithScore(at indexPath: IndexPath) -> WordCellItem {
    guard !usedWords[indexPath.row].word.isEmpty else { return WordCellItem(word: "Unknown") }

    let word = usedWords[indexPath.row].word
    return WordCellItem(word: word)
  }
}

// MARK: - Calculation of Scores
extension GameService {
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
      .map({ $0.word.lowercased() })
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
//    if !allPossibleWords.contains(lowercasedWord) {
//      throw WordError.notReal
//    }
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: self.currentLocale.textCheckerLanguage)

    if misspelledRange.location != NSNotFound {
      throw WordError.notReal
    }
  }
}

