//
//  Score+CoreDataProperties.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//
//

import Foundation
import CoreData


extension Score: Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
    return NSFetchRequest<Score>(entityName: "Score")
  }

  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var score: Int32
  @NSManaged public var word: String?
  @NSManaged public var finishedAt: Date?
  @NSManaged public var timeElapsed: Double
}

// MARK: - Unwrapped optional properties
extension Score {
  var unwrappedWord: String {
    get { word ?? "Unknown Word" }
    set { word = newValue }
  }

  var unwrappedName: String {
    get { name ?? "Unknown Name" }
    set { name = newValue }
  }

  var unwrappedFinishedAt: Date {
    get { finishedAt ?? .now }
    set { finishedAt = newValue }
  }
}
