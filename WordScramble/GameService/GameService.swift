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
  private var baseWords = Set<String>()
  private var possibleWords = Set<String>()
  private(set) var possibleWordsForCurrentWord = Set<String>()

  @Published var session: Session

  @Published var baseWord: String = ""
  @Published var usedWords: [String] = []
  @Published var totalScore: Int = 0
  @Published var maxPossibleScoreForBaseWord: Int = 0
  @Published var maxPossibleWordsForBaseWord: Int = 0

  var usersLocale: RegionBasedLocale

  init(lastSession: Session) {
    self.session = lastSession
    self.usersLocale = lastSession.locIdentifier
    loadWords(with: usersLocale)
    startGame(with: lastSession)
  }

  init(gameType: GameType? = .random) {
    // check users region.. if it's at, ch or de -> use german start words
    // if not, english
    let locale = String(Locale.autoupdatingCurrent.identifier.suffix(2)).lowercased()
    self.usersLocale = .init(rawValue: locale) ?? .en
    self.session = Session.newSession()
    loadWords(with: usersLocale)

    switch gameType {
    case .random:
      startGame()
    case .shared(let word):
      startGame(with: word)
    case .none:
      break
    }
  }



  func startGame(with session: Session) {
    loadDataFrom(session)
    updateCurrentScore()
  }

  private func loadDataFrom(_ session: Session) {
    guard
      session.possibleWordsOnBaseWord.count > 0,
      session.maxPossibleWordsOnBaseWord > 0,
      session.maxPossibleScoreOnBaseWord > 0
    else {
      getAllPossibleWordsFor(baseWord, basedOn: possibleWords)
      return
    }

    baseWord = session.unwrappedWord
    possibleWordsForCurrentWord = Set.init(session.possibleWordsOnBaseWord)
    maxPossibleWordsForBaseWord = session.maxPossibleWordsOnBaseWord
    maxPossibleScoreForBaseWord = session.maxPossibleScoreOnBaseWord
    usedWords = session.usedWords
  }

  func startGame(with word: String) {
    baseWord = word
    getAllPossibleWordsFor(baseWord, basedOn: possibleWords)
    session = Session.newSession()
    usedWords.removeAll()
  }

  func startGame() {
    guard let rndWord = baseWords.randomElement() else { return }
    baseWord = rndWord
    getAllPossibleWordsFor(rndWord, basedOn: possibleWords)
    session = Session.newSession()
    usedWords.removeAll()
  }

  func endGame(playerName: String) {
    SessionService.persistFinished(session: session, forPlayer: playerName)
    startGame()
  }

  func submit(_ input: String, onCompletion: () -> Void) throws {
    do {
      try validate(input)
      usedWords.insert(input, at: 0)
      save(session)
      updateCurrentScore()
      onCompletion()
    }
  }

  private func save(_ session: Session) {
    if session.baseWord == nil {
      session.baseWord = baseWord
      session.locIdentifier = usersLocale
      session.possibleWordsOnBaseWord = Array(possibleWordsForCurrentWord)
      session.maxPossibleWordsOnBaseWord = maxPossibleWordsForBaseWord
      session.maxPossibleScoreOnBaseWord = maxPossibleScoreForBaseWord
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
      self.maxPossibleScoreForBaseWord = score
      self.maxPossibleWordsForBaseWord = words.count
    }
  }

  private func updateCurrentScore() {
    self.totalScore = usedWords
      .map { $0.calculatedScore() }
      .reduce(0, +)
  }
}

extension GameService {
  func validate(_ word: String) throws {
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
    var tempWord = baseWord.lowercased()
    try word.lowercased().forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: baseWord)
      }
    }

    // isReal
    if !possibleWordsForCurrentWord.contains(word) {
      throw WordError.notReal
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
        self.baseWords = Set(startWords.components(separatedBy: .newlines))
      }
    }
  }

  static func isValidBaseWord(_ word: String) -> Bool {
    let localeIdentifier = String(Locale.autoupdatingCurrent.identifier.suffix(2)).uppercased()
    if
      let startWordsURL = Bundle.main.url(forResource: "startWords\(localeIdentifier)", withExtension: "txt"),
      let startWords = try? String(contentsOf: startWordsURL),
      let decodedWord = word.removingPercentEncoding
    {
      return startWords.contains(decodedWord)
    } else {
      return false
    }
  }

  static func isValidStartWord(_ word: String, in locale: RegionBasedLocale) -> Bool {
    if
      let startWordsURL = Bundle.main.url(forResource: "startWords\(locale.fileNameSuffix)", withExtension: "txt"),
      let startWords = try? String(contentsOf: startWordsURL),
      let decodedWord = word.removingPercentEncoding
    {
      return startWords.contains(decodedWord)
    } else {
      return false
    }
  }


}

