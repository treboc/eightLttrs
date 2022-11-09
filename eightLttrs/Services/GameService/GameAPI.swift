//
//  GameAPI.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import CoreData
import Foundation
import UIKit

class GameAPI {
  var usersLocale: WSLocale
  static let moc = PersistenceController.shared.context

  init(wsLocale: WSLocale = .getStoredWSLocale()) {
    self.usersLocale = wsLocale
  }

  func startGame(_ gameType: GameType = .random, in context: NSManagedObjectContext = moc) -> Session {
    switch gameType {
    case .continueLastSession:
      return SessionService.returnLastSession(in: context) ?? randomWordSession()
    case .shared(let word):
      return newSession(with: word)
    default:
      return randomWordSession()
    }
  }

  func newSession(with word: String, in context: NSManagedObjectContext = moc) -> Session {
    let session: Session = .newSession(with: word, in: context)
    let (possibleWords, maxPossibleScore) = WordService.getAllPossibleWords(for: word)
    session.possibleWordsSet = possibleWords
    session.maxPossibleWordsOnBaseWord = possibleWords.count
    session.maxPossibleScoreOnBaseWord = maxPossibleScore
    SessionService.persist(session: session)
    return session
  }

  func randomWordSession(in context: NSManagedObjectContext = moc) -> Session {
    usersLocale = .getStoredWSLocale()
    let (baseword, possibleWords, maxPossibleScore) = WordService.getNewBasewordWith(usersLocale)
    let session: Session = .newSession(with: baseword, in: context)
    session.possibleWords = Array(possibleWords)
    session.maxPossibleWordsOnBaseWord = possibleWords.count
    session.maxPossibleScoreOnBaseWord = maxPossibleScore
    SessionService.persist(session: session)
    return session
  }

  func continueLastSession(in context: NSManagedObjectContext = moc) -> Session {
    guard let lastSession = SessionService.returnLastSession(in: context) else {
      return randomWordSession(in: context)
    }
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

  static func calculatedScore(for words: [String]) -> Int {
    return words
      .map { $0.calculatedScore() }
      .reduce(0, +)
  }
}
