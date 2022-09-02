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

  static func loadHighscores(in context: NSManagedObjectContext = PersistenceStore.shared.context) -> [Session] {
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

  static func persist(session: Session) {
    do {
      // updating widget
      let widgetSession = WidgetSession(baseword: session.unwrappedWord, usedWords: Array(session.usedWords.prefix(3)), maxPossibleWords: session.maxPossibleWordsOnBaseWord, wordsFound: session.usedWords.count, percentageWordsFound: session.percentageWordsFound)
      let currentSession = CurrentSession(currentSession: widgetSession)
      currentSession.storeItem()
      dump(currentSession)
      try context.save()
    } catch {
      print(error.localizedDescription)
      context.rollback()
    }
  }
}
