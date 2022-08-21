//
//  Score+CoreDataProperties.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//
//

import Foundation
import CoreData


extension Score {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
    return NSFetchRequest<Score>(entityName: "Score")
  }

  @NSManaged public var score: Int32
  @NSManaged public var word: String?
  @NSManaged public var id: UUID?
  @NSManaged public var finishedAt: Date?
  @NSManaged public var timeElapsed: Double
  @NSManaged public var name: String?
}

extension Score : Identifiable {
}
