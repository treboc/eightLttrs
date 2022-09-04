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
  private var basewords = Set<String>()
  private var possibleWords = Set<String>()
  private(set) var possibleWordsForCurrentWord = Set<String>()

  @Published var session: Session

  @Published var baseword: String = ""
  @Published var usedWords: [String] = []
  @Published var totalScore: Int = 0
  @Published var maxPossibleScoreForBaseWord: Int = 0
  @Published var maxPossibleWordsForBaseWord: Int = 0

  var usersLocale: WSLocale

  init(lastSession: Session) {
    self.session = lastSession
    self.usersLocale = lastSession.locIdentifier
    let (basewords, possibleWords) = WordService.loadAllWords(usersLocale)
    self.basewords = basewords
    self.possibleWords = possibleWords
    startGame(with: session)
  }

  init(gameType: GameType? = .random) {
    self.usersLocale = .getStoredWSLocale()
    self.session = Session.newSession()
    let (basewords, possibleWords) = WordService.loadAllWords(usersLocale)
    self.basewords = basewords
    self.possibleWords = possibleWords
    
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
      WordService.getAllPossibleWordsFor(baseword, basedOn: possibleWords, onCompletion: didReceivePossibleWords)
      return
    }

    baseword = session.unwrappedWord
    possibleWordsForCurrentWord = Set.init(session.possibleWordsOnBaseWord)
    maxPossibleWordsForBaseWord = session.maxPossibleWordsOnBaseWord
    maxPossibleScoreForBaseWord = session.maxPossibleScoreOnBaseWord
    usedWords = session.usedWords
  }

  private func didReceivePossibleWords(_ words: Set<String>, _ score: Int) {
    possibleWordsForCurrentWord = words
    maxPossibleScoreForBaseWord = score
    maxPossibleWordsForBaseWord = words.count
  }

  func startNewSession(with word: String) {
    baseword = word
    WordService.getAllPossibleWordsFor(baseword, basedOn: possibleWords, onCompletion: didReceivePossibleWords)
    session = Session.newSession()
    save(session)
    usedWords.removeAll()
  }

  private func checkLocale() {
    if usersLocale != .getStoredWSLocale() {
      usersLocale = .getStoredWSLocale()
      let (basewords, possibleWords) = WordService.loadAllWords(usersLocale)
      self.basewords = basewords
      self.possibleWords = possibleWords
    }
  }

  func startRndWordSession() {
    checkLocale()
    guard let rndWord = basewords.randomElement() else { return }
    baseword = rndWord
    WordService.getAllPossibleWordsFor(rndWord, basedOn: possibleWords) { [weak self] (words, score) in
      guard let self = self else { return }
      self.session = Session.newSession()
      self.usedWords.removeAll()
      self.possibleWordsForCurrentWord = words
      self.maxPossibleScoreForBaseWord = score
      self.maxPossibleWordsForBaseWord = words.count
      self.updateCurrentScore()
      self.save(self.session)
    }
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
  private func updateCurrentScore() {
    self.totalScore = usedWords
      .map { $0.calculatedScore() }
      .reduce(0, +)
  }
}
