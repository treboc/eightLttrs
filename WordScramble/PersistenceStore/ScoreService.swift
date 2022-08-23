//
//  ScoreService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import CoreData
import Foundation

// MARK: - Saving & Loading Scores

class ScoreService {
  internal static let context = PersistenceStore.shared.context

  static func allObjects<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext = PersistenceStore.shared.context) -> [T] {
    let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: T.description())
    do {
      let result = try context.fetch(fetchRequest)
      return result
    } catch let error as NSError {
      NSLog("Error fetching NSManagedObjects \(T.description()): \(error.localizedDescription), \(error.userInfo)")
    }
    return []
  }

  static func loadHighscores(in context: NSManagedObjectContext = PersistenceStore.shared.context) -> [HighscoreCellItem] {
    let fetchRequest: NSFetchRequest<Score> = NSFetchRequest<Score>(entityName: Score.description())
    do {
      let result = try context.fetch(fetchRequest)
      return result
        .enumerated()
        .map { (index, item) in
          return HighscoreCellItem(name: item.name!, score: Int(item.score))
        }
        .sorted { $0.score > $1.score }
    } catch let error as NSError {
      NSLog("Error fetching NSManagedObjects \(Score.description()): \(error.localizedDescription), \(error.userInfo)")
    }
    return []
  }

  static func save(word: String, for name: String, with score: Int) {
    let scoreObject = Score(context: context)
    scoreObject.word = word
    scoreObject.finishedAt = .now
    scoreObject.id = UUID()
    scoreObject.score = Int32(score)
    scoreObject.name = name

    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}
