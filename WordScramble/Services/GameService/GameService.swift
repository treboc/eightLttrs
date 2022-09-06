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
  var session: Session

  @Published var baseword: String = ""
  @Published var usedWords: [String] = []
  private(set) var possibleWords = Set<String>()
  @Published var totalScore: Int = 0
  @Published var maxPossibleScoreForBaseWord: Int = 0
  @Published var maxPossibleWordsForBaseWord: Int = 0

  var usersLocale: WSLocale

  init(lastSession: Session) {
    self.session = lastSession
    self.usersLocale = lastSession.locIdentifier
    startGame(with: session)
  }

  init(gameType: GameType? = .random) {
    self.usersLocale = .getStoredWSLocale()
    self.session = Session.newSession()

    switch gameType {
    case .random:
      startRndWordSession()
    case .shared(let word):
      startNewSession(with: word)
    case .none:
      break
    }
  }

  func startGame(with session: Session) {
    setupWithDataFrom(session)
    updateCurrentScore()
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

    DispatchQueue.main.async {
      self.session = Session.newSession()
      self.usedWords.removeAll()
      self.updateCurrentScore()
      self.save(self.session)
    }
  }

  func startNewSession(with word: String) {
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
    usersLocale = .getStoredWSLocale()
    WordService.getNewBasewordWith(usersLocale, onCompletion: didReceiveNewBaseword)
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
      save(session)
      updateCurrentScore()
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
