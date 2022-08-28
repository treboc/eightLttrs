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
}

class GameService: GameServiceProtocol {
  var wordCellItemPublisher = CurrentValueSubject<[WordCellItem], Never>([])
  var currentWordPublisher = CurrentValueSubject<String, Never>("")
  var possibleScorePublisher = CurrentValueSubject<(Int, Int), Never>((0, 0))

  var startWords = Set<String>()
  var possibleWords = Set<String>()
  var possibleWordsForCurrentWord = Set<String>()

  var currentLocale: RegionBasedLocale

  var currentWord: String = "" {
    didSet {
      currentWordPublisher.send(currentWord)
      getAllPossibleWordsFor(currentWord, basedOn: possibleWords)
    }
  }


  var usedWords: [WordCellItem] = [] {
    didSet {
      updateCurrentScore()
      wordCellItemPublisher.send(usedWords)
    }
  }

  var currentScore: Int = 0 {
    didSet {
      possibleScorePublisher.send((currentScore, possibleScore))
    }
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
    // load possible words to check for
    if let possibleWordsURL = Bundle.main.url(forResource: "allWords8Letters\(locale.fileNameSuffix).txt", withExtension: nil) {
      if let possibleWords = try? String(contentsOf: possibleWordsURL) {
        let possibleLowercasedWords = possibleWords.components(separatedBy: .newlines)
        self.possibleWords = Set(possibleLowercasedWords)
      }
    }

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
  private func getAllPossibleWordsFor(_ word: String, basedOn list: Set<String>) {
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }
      let (words, score) = word.allPossibleWords(basedOn: list)
      self.possibleWordsForCurrentWord = words
      DispatchQueue.main.async {
        self.possibleScore = score
      }
    }
  }

  private func updateCurrentScore() {
    self.currentScore = usedWords
      .map { $0.word.calculateScore() }
      .reduce(0, +)
  }

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
    // tooShort
    if word.count < 3 {
      throw WordError.tooShort
    }

    // isOriginal
    if usedWords
      .map({ $0.word })
      .contains(word) {
      throw WordError.notOriginal
    }

    // isPossible
    var tempWord = currentWord.lowercased()
    try word.lowercased().forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: currentWord)
      }
    }

    // isReal
    if !possibleWords.contains(word) {
      throw WordError.notReal
    }
//    let checker = UITextChecker()
//    let range = NSRange(location: 0, length: word.utf16.count)
//    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: self.currentLocale.textCheckerLanguage)
//
//    if misspelledRange.location != NSNotFound {
//      throw WordError.notReal
//    }
  }
}

