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

class GameService {
  var startWords = Set<String>()
  var allPossibleWords = Set<String>()
  var possibleWordsForCurrentWord = Set<String>()

  @Published var currentSession: Session

  @Published var currentWord: String = "" {
    didSet {
      getAllPossibleWordsFor(currentWord, basedOn: allPossibleWords)
    }
  }

  @Published var usedWords: [String] = [] {
    didSet {
      updateCurrentScore()
    }
  }
  @Published var currentScore: Int = 0
  @Published var possibleScore: Int = 0
  @Published var possibleWordsCount = 0

  var currentLocale: RegionBasedLocale

  init(lastSession: Session) {
    self.currentSession = lastSession
    self.currentLocale = .init(rawValue: lastSession.localeIdentifier ?? "DE") ?? .de
    loadWords(with: currentLocale)
    startGame(with: lastSession)
  }

  init(_ gameType: GameType? = .random, lastSession: Session? = nil) {
    // check users region.. if it's at, ch or de -> use german start words
    // if not, english
    let locale = String(Locale.autoupdatingCurrent.identifier.suffix(2)).lowercased()
    self.currentLocale = .init(rawValue: locale) ?? .en
    self.currentSession = Session.newSession()
    loadWords(with: currentLocale)

    switch gameType {
    case .random:
      if let session = lastSession {
        startGame(with: session)
      } else {
        startGame()
      }
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
    currentWord = session.word ?? "ERROR"
    session.usedWords.forEach {
      usedWords.append($0)
    }
  }

  func startGame(with session: Session) {
    currentWord = session.word ?? "ERROR"
    session.usedWords?.forEach {
      usedWords.append(WordCellItem(word: $0))

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
    currentSession = Session.newSession()
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
      onCompletion()
    }
  }

  private func save(_ session: Session) {
    if session.word == nil {
      session.word = currentWord
      session.localeIdentifier = currentLocale.rawValue
    }
    session.usedWords = usedWords
    SessionService.persist(session: session)
  }

  private func save(_ session: Session) {
    session.word = currentWord
    session.usedWords = usedWords.map { $0.word }
    session.score = Int32(currentScore)
    session.localeIdentifier = currentLocale.rawValue

    SessionService.persist(session: session)
    dump(session)
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
        self.possibleWordsCount = words.count
      }
    }
  }

  private func updateCurrentScore() {
    self.currentScore = usedWords
      .map { $0.calculateScore() }
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
    if !allPossibleWords.contains(word) {
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

  class func isValidStartWord(_ word: String) -> Bool {
    let localeIdentifier = String(Locale.autoupdatingCurrent.identifier.suffix(2)).uppercased()
    if let startWordsURL = Bundle.main.url(forResource: "startWords\(localeIdentifier)", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        return startWords.contains(word)
      }
    }
    return false
  }
}

