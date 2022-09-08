//
//  Session+CoreDataProperties.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//
//

import Foundation
import CoreData

@objc(Session)
public class Session: NSManagedObject, Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
    return NSFetchRequest<Session>(entityName: "Score")
  }

   class func newSession() -> Session {
     let session = Session(context: PersistenceStore.shared.context)
     session.id = UUID()
     session.startedAt = .now
     session.isFinished = false
     return session
  }

  @NSManaged public var id: UUID?
  @NSManaged public var baseword: String?
  @NSManaged public var playerName: String?
  @NSManaged public var startedAt: Date?
  @NSManaged public var timeElapsed: Double
  @NSManaged public var usedWords: [String]
  @NSManaged public var possibleWords: [String]
  @NSManaged public var scoreIntern: Int16
  @NSManaged public var maxPossibleWordsOnBaseWordIntern: Int16
  @NSManaged public var maxPossibleScoreOnBaseWordIntern: Int16
  @NSManaged public var isFinished: Bool
  @NSManaged public var localeIdentifier: String?
}

// MARK: - Unwrapped optional properties
extension Session {
  var percentageWordsFound: Double {
    return Double(usedWords.count) / Double(maxPossibleWordsOnBaseWord)
  }

  var percentageWordsFoundString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2

    if let string = formatter.string(from: percentageWordsFound as NSNumber) {
      return string
    }
    return "0 %"
  }

  @objc dynamic var possibleWordsSet: Set<String> {
    get { Set(possibleWords) }
    set { possibleWords = Array(newValue) }
  }

  var unwrappedBaseword: String {
    get { baseword ?? "Unknown Word" }
    set { baseword = newValue }
  }

  var unwrappedName: String {
    get { playerName ?? "Unknown Name" }
    set { playerName = newValue }
  }

  var unwrappedStartedAt: Date {
    get { startedAt ?? .now }
    set { startedAt = newValue }
  }

  @objc dynamic var score: Int {
    get { Int(scoreIntern) }
    set { scoreIntern = Int16(newValue) }
  }

  @objc dynamic var maxPossibleWordsOnBaseWord: Int {
    get { Int(maxPossibleWordsOnBaseWordIntern) }
    set { maxPossibleWordsOnBaseWordIntern = Int16(newValue) }
  }

  @objc dynamic var maxPossibleScoreOnBaseWord: Int {
    get { Int(maxPossibleScoreOnBaseWordIntern) }
    set { maxPossibleScoreOnBaseWordIntern = Int16(newValue) }
  }


  var locIdentifier: WSLocale {
    get {
      if let identifier = localeIdentifier {
        return .init(rawValue: identifier) ?? .EN
      } else {
        return .EN
      }
    }

    set { localeIdentifier = newValue.rawValue }
  }
}
