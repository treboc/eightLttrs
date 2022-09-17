//
//  SessionService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import CoreData
import Foundation

class SessionService {
  internal static let context = PersistenceController.shared.context

  static func allObjects<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext = PersistenceController.shared.context) -> [T] {
    let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: T.description())
    do {
      let result = try context.fetch(fetchRequest)
      return result
    } catch let error as NSError {
      NSLog("Error fetching NSManagedObjects \(T.description()): \(error.localizedDescription), \(error.userInfo)")
    }
    return []
  }

  static func loadHighscores(in context: NSManagedObjectContext = PersistenceController.shared.context) -> [Session] {
    let fetchRequest: NSFetchRequest<Session> = NSFetchRequest<Session>(entityName: Session.description())
    do {
      let result = try context.fetch(fetchRequest)
      return result
        .filter(\.isFinished)
        .sorted { $0.score > $1.score }
    } catch let error as NSError {
      NSLog("Error fetching NSManagedObjects \(Session.description()): \(error.localizedDescription), \(error.userInfo)")
    }
    return []
  }

  static func returnLastSession(in context: NSManagedObjectContext = PersistenceController.shared.context) -> Session? {
    let result = SessionService.allObjects(Session.self, in: context)
      .filter { !$0.isFinished }
      .sorted { $0.unwrappedStartedAt < $1.unwrappedStartedAt }
    // deleting all older, not finished sessions, but the last
    for session in result {
      if session != result.last {
        Self.delete(session)
      } else {
        return session
      }
    }
    return nil
  }

  static func lastOpenSessionHasWords(in context: NSManagedObjectContext = PersistenceController.shared.context) -> Bool {
    if let session = returnLastSession(in: context),
       session.usedWords.count > 0 {
      return true
    }
    return false
  }

  static func delete(_ session: Session, in context: NSManagedObjectContext = PersistenceController.shared.context) {
    context.delete(session)
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  static func persistFinished(session: Session, forPlayer name: String) {
    context.perform {
      session.playerName = name
      session.isFinished = true
      session.timeElapsed = session.unwrappedStartedAt.distance(to: .now)

      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
        context.rollback()
      }
    }
  }

  static func persist(session: Session) {
    let widgetSession = WidgetSession(baseword: session.unwrappedBaseword, usedWords: Array(session.usedWords.prefix(3)), maxPossibleWords: session.maxPossibleWordsOnBaseWord, wordsFound: session.usedWords.count, percentageWordsFound: session.percentageWordsFound)
    let currentSession = CurrentWidgetSession(currentSession: widgetSession)
    currentSession.storeItem()

    guard let context = session.managedObjectContext else { return }
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
