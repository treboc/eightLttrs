//
//  GameService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import Foundation
import UIKit

class GameService {
  var startWords = Set<String>()
  var allPossibleWords = Set<String>()
  var possibleWordsForCurrentWord = Set<String>()

  @Published var currentSession: Session

  @Published var currentWord: String = ""
  @Published var usedWords: [String] = []
  @Published var currentScore: Int = 0
  @Published var possibleWordsScore: Int = 0
  @Published var possibleWordsCount = 0

  var currentLocale: RegionBasedLocale

  init(lastSession: Session) {
    self.currentSession = lastSession
    self.currentLocale = .init(rawValue: lastSession.localeIdentifier ?? "DE") ?? .de
    loadWords(with: currentLocale)
    startGame(with: lastSession)
  }

  init(gameType: GameType? = .random) {
    // check users region.. if it's at, ch or de -> use german start words
    // if not, english
    let locale = String(Locale.autoupdatingCurrent.identifier.suffix(2)).lowercased()
    self.currentLocale = .init(rawValue: locale) ?? .en
    self.currentSession = Session.newSession()
    loadWords(with: currentLocale)

    switch gameType {
    case .random:
      startGame()
    case .shared(let word):
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
        self.allPossibleWords = Set(possibleLowercasedWords)
      }
    }

    // load possible startWords in the current language
    if let startWordsURL = Bundle.main.url(forResource: "startWords\(locale.fileNameSuffix)", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        self.startWords = Set(startWords.components(separatedBy: .newlines))
      }
    }
  }

  func startGame(with session: Session) {
    currentWord = session.unwrappedWord
    loadDataFrom(session)
    updateCurrentScore()
  }

  private func loadDataFrom(_ session: Session) {
    guard
      session.possibleWords.count > 0,
      session.possibleWordsCount > 0,
      session.possibleWordsScore > 0
    else {
      getAllPossibleWordsFor(currentWord, basedOn: allPossibleWords)
      return
    }

    currentWord = session.unwrappedWord
    possibleWordsForCurrentWord = Set.init(session.possibleWords)
    possibleWordsCount = session.possibleWordsCount
    possibleWordsScore = session.possibleWordsScore
    usedWords = session.usedWords
  }

  func startGame(with word: String) {
    currentWord = word
    getAllPossibleWordsFor(currentWord, basedOn: allPossibleWords)
    currentSession = Session.newSession()
    usedWords.removeAll()
  }

  func startGame() {
    guard let rndWord = startWords.randomElement() else { return }
    currentWord = rndWord
    getAllPossibleWordsFor(rndWord, basedOn: allPossibleWords)
    currentSession = Session.newSession()
    usedWords.removeAll()
  }

  func endGame(playerName: String) {
    SessionService.persistFinished(session: currentSession, forPlayer: playerName)
    startGame()
  }

  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws {
    do {
      try check(word)
      usedWords.insert(word, at: 0)
      save(currentSession)
      updateCurrentScore()
      onCompletion()
    }
  }

  private func save(_ session: Session) {
    if session.word == nil {
      session.word = currentWord
      session.localeIdentifier = currentLocale.rawValue
      session.possibleWords = Array(possibleWordsForCurrentWord)
      session.possibleWordsCount = possibleWordsCount
      session.possibleWordsScore = possibleWordsScore
    }
    session.usedWords = usedWords
    SessionService.persist(session: session)
  }
}

// MARK: - Calculation of Scores
extension GameService {
  private func getAllPossibleWordsFor(_ word: String, basedOn list: Set<String>) {
    Task {
      let (words, score) = await word.allPossibleWords(basedOn: list)
      self.possibleWordsForCurrentWord = words
      self.possibleWordsScore = score
      self.possibleWordsCount = words.count
    }
  }

  private func updateCurrentScore() {
    self.currentScore = usedWords
      .map { $0.calculatedScore() }
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
    if !possibleWordsForCurrentWord.contains(word) {
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

  static func isValidStartWord(_ word: String) -> Bool {
    let localeIdentifier = String(Locale.autoupdatingCurrent.identifier.suffix(2)).uppercased()
    guard
      let startWordsURL = Bundle.main.url(forResource: "startWords\(localeIdentifier)", withExtension: "txt"),
      let startWords = try? String(contentsOf: startWordsURL),
      let decodedWord = word.removingPercentEncoding else { return false }

    return startWords.contains(decodedWord)
  }
}

