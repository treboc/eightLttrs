//
//  SessionService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import CoreData
import Foundation

// MARK: - Saving & Loading Scores

class SessionService {
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
    let fetchRequest: NSFetchRequest<Session> = NSFetchRequest<Session>(entityName: Session.description())
    do {
      let result = try context.fetch(fetchRequest)
      return result
        .enumerated()
        .compactMap { (index, item) in
          if item.isFinished {
            return HighscoreCellItem(name: item.unwrappedName,
                                     word: item.unwrappedWord,
                                     score: Int(item.score))
          }
          return nil
        }
        .sorted { $0.score > $1.score }
    } catch let error as NSError {
      NSLog("Error fetching NSManagedObjects \(Session.description()): \(error.localizedDescription), \(error.userInfo)")
    }
    return []
  }

  static func returnLastSession(in context: NSManagedObjectContext = PersistenceStore.shared.context) -> Session? {
    let result = SessionService.allObjects(Session.self, in: context)
      .filter { !$0.isFinished }
      .sorted { $0.unwrappedStartedAt < $1.unwrappedStartedAt }
    // deleting all older, not finished sessions, but the last
    for session in result {
      if session != result.last {
        context.delete(session)
      } else {
        return session
      }
    }
    return nil
  }

  static func persistFinished(session: Session, forPlayer name: String) {
    session.name = name
    session.isFinished = true

    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  static func persist(session: Session) {
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}
