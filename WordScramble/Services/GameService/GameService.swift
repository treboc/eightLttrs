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
  var session: Session = .newSession()

  @Published var baseword: String = ""
  @Published var usedWords: [String] = []
  private(set) var possibleWords = Set<String>()
  @Published var totalScore: Int = 0
  @Published var maxPossibleScoreForBaseWord: Int = 0
  @Published var maxPossibleWordsForBaseWord: Int = 0

  var usersLocale: WSLocale

//  init(lastSession: Session) {
//    self.session = lastSession
//    self.usersLocale = lastSession.locIdentifier
//    startGame(with: session)
//  }

  init(gameType: GameType? = .random,
       wsLocale: WSLocale = .getStoredWSLocale()) {
    self.usersLocale = wsLocale

    switch gameType {
    case .random:
      startRndWordSession()
    case .shared(let word):
      startNewSession(with: word)
    case .continueWith(let session):
      startGame(with: session)
    default:
      break
    }

    self.session = Session.newSession()
  }

  func startGame(with session: Session) {
    self.session = session
    setupWithDataFrom(session)
    updateCurrentScore()
  }

  func startNewSession(with word: String) {
//    self.session = Session.newSession()
    baseword = word
    session.baseWord = word
    WordService.getAllPossibleWordsFor(word, withLocale: self.usersLocale) { [weak self] possibleWords, maxPossibleScore in
      self?.possibleWords = possibleWords
      self?.maxPossibleWordsForBaseWord = possibleWords.count
      self?.maxPossibleScoreForBaseWord = maxPossibleScore
    }
    didReceiveNewBaseword(word, possibleWords: possibleWords, maxPossibleScore: maxPossibleScoreForBaseWord)
  }

  func startRndWordSession(onCompletion: (() -> Void)? = nil) {
    self.session = Session.newSession()
    usersLocale = .getStoredWSLocale()
    WordService.getNewBasewordWith(usersLocale, onCompletion: didReceiveNewBaseword)
  }

  private func setupWithDataFrom(_ session: Session) {
    guard
      session.possibleWordsOnBaseWord.count > 0,
      session.maxPossibleWordsOnBaseWord > 0,
      session.maxPossibleScoreOnBaseWord > 0
    else {
      baseword = session.unwrappedWord
      usedWords = session.usedWords
      WordService.getAllPossibleWordsFor(baseword, withLocale: session.locIdentifier, onCompletion: didReceivePossibleWords)
      return
    }

    baseword = session.unwrappedWord
    possibleWords = Set.init(session.possibleWordsOnBaseWord)
    maxPossibleWordsForBaseWord = session.maxPossibleWordsOnBaseWord
    maxPossibleScoreForBaseWord = session.maxPossibleScoreOnBaseWord
    usedWords = session.usedWords
  }

  private func didReceivePossibleWords(_ words: Set<String>, _ score: Int) {
    possibleWords = words
    maxPossibleScoreForBaseWord = score
    maxPossibleWordsForBaseWord = words.count
  }

  private func didReceiveNewBaseword(_ baseword: String, possibleWords: Set<String>, maxPossibleScore: Int) {
    self.baseword = baseword
    self.possibleWords = possibleWords
    self.maxPossibleWordsForBaseWord = possibleWords.count
    self.maxPossibleScoreForBaseWord = maxPossibleScore
    self.session = Session.newSession()
    self.usedWords.removeAll()
    self.updateCurrentScore()
  }

  func endGame(playerName: String) {
    SessionService.persistFinished(session: session, forPlayer: playerName)
    startRndWordSession()
  }

  func submit(_ input: String, onCompletion: () -> Void) throws {
    do {
      try WordService.validate(input,
                               baseword: baseword,
                               usedWords: usedWords,
                               possibleWords: possibleWords)
      usedWords.insert(input, at: 0)
      updateCurrentScore()
      save(session)

      onCompletion()
    }
  }

  private func save(_ session: Session) {
    if session.baseWord == nil {
      session.baseWord = baseword
      session.locIdentifier = usersLocale
      session.possibleWordsOnBaseWord = Array(possibleWords)
      session.maxPossibleWordsOnBaseWord = maxPossibleWordsForBaseWord
      session.maxPossibleScoreOnBaseWord = maxPossibleScoreForBaseWord
    }
    session.usedWords = usedWords
    SessionService.persist(session: session)
  }
}

// MARK: - Calculation of Scores
extension GameService {
  private func updateCurrentScore() {
    self.totalScore = usedWords
      .map { $0.calculatedScore() }
      .reduce(0, +)
  }
}
