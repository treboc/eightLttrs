//
//  Session+CoreDataProperties.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//
//

import Foundation
import CoreData


extension Session: Identifiable {
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
  @NSManaged public var word: String?
  @NSManaged public var name: String?
  @NSManaged public var startedAt: Date?
  @NSManaged public var timeElapsed: Double
  @NSManaged public var usedWords: [String]
  @NSManaged public var isFinished: Bool
  @NSManaged public var localeIdentifier: String?
}

// MARK: - Unwrapped optional properties
extension Session {
  @objc dynamic
  var score: Int {
    return self.unwrappedUsedWords
      .map { $0.calculateScore() }
      .reduce(0, +)
  }


  var unwrappedWord: String {
    get { word ?? "Unknown Word" }
    set { word = newValue }
  }

  var unwrappedName: String {
    get { name ?? "Unknown Name" }
    set { name = newValue }
  }

  var unwrappedStartedAt: Date {
    get { startedAt ?? .now }
    set { startedAt = newValue }
  }

  @objc
  var unwrappedUsedWords: [String] {
    get { usedWords ?? [] }
    set { usedWords = newValue }
  }
}
