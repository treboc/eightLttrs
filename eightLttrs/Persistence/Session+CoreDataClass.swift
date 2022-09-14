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

  convenience init(using context: NSManagedObjectContext) {
    let name = String(describing: type(of: self))
    let description = NSEntityDescription.entity(forEntityName: name, in: context)!
    self.init(entity: description, insertInto: context)
  }

  class func newSession(with baseword: String, in context: NSManagedObjectContext = PersistenceController.shared.context) -> Session {
    let session = Session(using: context)
    session.id = UUID()
    session.startedAt = .now
    session.baseword = baseword
    session.locIdentifier = .getStoredWSLocale()
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
  var sharableURL: URL {
    let encodedBaseWord = unwrappedBaseword.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    return URL(string: "wordscramble://baseword/\(locIdentifier.regionCode)/\(encodedBaseWord)")!
  }

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

  var averagePointsPerWord: Double {
    return Double(score) / Double(usedWords.count)
  }

  var averagePointsPerWordString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0

    if let string = formatter.string(from: averagePointsPerWord as NSNumber) {
      return string
    }
    return "0"
  }

  @objc dynamic var possibleWordsSet: Set<String> {
    get { Set(possibleWords) }
    set { possibleWords = Array(newValue) }
  }

  var unwrappedBaseword: String {
    get { baseword ?? "UnknownWord" }
    set { baseword = newValue }
  }

  var unwrappedName: String {
    get { playerName ?? "UnknownName" }
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
        return .init(rawValue: identifier) ?? WSLocale.getStoredWSLocale()
      } else {
        return WSLocale.getStoredWSLocale()
      }
    }

    set { localeIdentifier = newValue.rawValue }
  }
}
