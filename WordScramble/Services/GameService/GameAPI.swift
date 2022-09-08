//
//  GameAPI.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import Foundation
import UIKit

class GameAPI {
  var usersLocale: WSLocale

  init(wsLocale: WSLocale = .getStoredWSLocale()) {
    self.usersLocale = wsLocale
  }

  func startGame(_ gameType: GameType) -> Session {
    switch gameType {
    case .continueLastSession:
      return SessionService.returnLastSession() ?? randomWordSession()
    case .shared(let word):
      return newSession(with: word)
    default:
      return randomWordSession()
    }
  }

  func newSession(with word: String) -> Session {
    let session: Session = .newSession()
    session.baseword = word
    WordService.getAllPossibleWordsFor(word, withLocale: self.usersLocale) { possibleWords, maxPossibleScore in
      session.possibleWordsSet = possibleWords
      session.maxPossibleWordsOnBaseWord = possibleWords.count
      session.maxPossibleScoreOnBaseWord = maxPossibleScore
    }
    return session
  }

  func randomWordSession() -> Session {
    let session: Session = .newSession()
    usersLocale = .getStoredWSLocale()
    WordService.getNewBasewordWith(usersLocale) { (baseword, possibleWords, maxPossibleScore) in
      session.baseword = baseword
      session.possibleWords = Array(possibleWords)
      session.maxPossibleWordsOnBaseWord = possibleWords.count
      session.maxPossibleScoreOnBaseWord = maxPossibleScore
    }
    return session
  }

  func continueLastSession() -> Session {
    guard let lastSession = SessionService.returnLastSession() else { return randomWordSession() }
    return lastSession
  }

  func submit(_ input: String, session: Session) throws {
    do {
      try WordService.validate(input,
                               baseword: session.unwrappedBaseword,
                               usedWords: session.usedWords,
                               possibleWords: session.possibleWordsSet)
      session.usedWords.insert(input, at: 0)
      session.score = calculatedScore(for: session.usedWords)
      SessionService.persist(session: session)
    }
  }

  private func calculatedScore(for words: [String]) -> Int {
    return words
      .map { $0.calculatedScore() }
      .reduce(0, +)
  }
}
